# NGE appearance client inspection

Read-only inspection of `C:/SWG-DEV/SWGDevWork/StarWarsGalaxies/SwgClient_r.exe`.
SHA-256: `c33727e788b2f03ae7b69f8dca456bed22679b4e574b522f63ab8c675a9b9f37`.
32-bit x86 PE, preferred image base `0x00400000`. Addresses below are preferred
virtual addresses for this exact binary; they are not Stardust hook addresses.

## Verified references

- `0x015EF16C`: string `appearanceEquipped`.
- `0x01005640`: initialization function referencing that string and storing a
  property identifier at `0x018FB088`.
- `0x00500E11–0x00500E48`: property lookup using that identifier and an output
  color at `0x018FB0B0`. Failed lookup supplies packed default `0xFFFF0080`.
  Color-channel interpretation and the actual palette value are not verified.
- `0x005050BA`: passes the appearance color to a shared UI call at `0x00A9EB90`.
  This branch is preceded by object-type checks for `0x2033` and `0x2034`.
  The exact types and ordinary cosmetic-equipment selection path require further
  tracing; do not assume every appearance item enters this branch.
- Other strings: `appearance_inventory`, `showAppearanceInventory`,
  `doubleClickAppearanceUnequip`, `equipAppearance`, `unequipAppearance`,
  `/pda.AppearanceTab`, and RTTI naming `SwgCuiAppearanceTab`.
- Shared UI property strings: `RStyleOverlay`, `RStyleOverlayColor`, and
  `RStyleOverlayOpacity`.

These establish explicit native appearance-related UI support. The inventory
layout file alone does not implement the system. Objdump prints nearby exported
symbol names for unrelated addresses; those labels were not treated as reliable
function identities.

## Stardust comparison and injection scope

A byte-string search of `C:/Stardust/Stardust.exe` found `RStyleOverlayColor` but
not `appearanceEquipped`, `appearance_inventory`, or `equipAppearance`. This is
evidence of a difference, not proof that all equivalent logic is absent.

A possible client extension would hook Stardust's item-icon update path, obtain
actual-equipment and cosmetic-selection state separately, and choose distinct
overlays. The generic overlay property offers a lead. Copying an NGE function or
reusing its addresses is not a viable drop-in approach: object layouts, calling
conventions, dependencies, and state sources must first be mapped in Stardust.

A highlight hook alone cannot replace the server prototype's owner-containment
workaround. Full separation also requires a rendering hook or equivalent client
support so real armor stays equipped in the client while cosmetics control the
visible model. A way to synchronize cosmetic item IDs with the client must be
specified and tested; none was implemented during this inspection.

No executable, client asset, TRE archive, or Engine3 file was modified, and no
runtime injection was attempted.

## Extracted appearance-tab layout

Inspected `C:/SWG-DEV/ngeui/ui/ui_appearance_tab.inc` as XML. Its root is
`AppearanceTab`, matching the NGE executable's `/pda.AppearanceTab` reference.
The top-level CodeData binds `LayoutPage`, `Viewer.viewer`, `Viewer.label`,
`Viewer.checkShowInventory`, `Viewer`, and the close button `bg.mmc.close`.

`LayoutPage` contains 25 child pages, all named `p`. Each supplies a generic
`slot` label and CodeData bindings for `text`, `line.loading.text`, and `line.v`.
The layout does not identify which equipment slot belongs to each position.
This strongly suggests the native mediator assigns labels and slot behavior;
the exact ordering is not yet mapped. The 3D character viewer accepts GameObject
drags. The checkbox references `@ui_appearance:check_show_inventory`.

The layout is a useful template for a future appearance UI, and its paths give
concrete targets for tracing the NGE mediator. It does not provide equip command
handling, appearance-state synchronization, or the inventory's appearance color
selection. Its cyan decoration also uses theme palette properties and should
not be confused with the appearance-equipped inventory overlay.

Reuse requires an equivalent Stardust mediator/controller or a compatible
existing mediator, registration/opening of the Page, verified shared styles and
localization, and the separate rendering/state support described above. Merely
adding this include to a TRE would not supply those native behaviors. No UI asset
was installed or changed during inspection.

## Stardust extension and first hook candidates

Both `C:/Stardust/Stardust.exe` and `C:/Stardust-DEV/Stardust.exe` have SHA256
`e782bf1c49b3da730f66b54bc558947c46493f7133f672eed1d8e0c56a6b6150`.
They are 32-bit PE images with preferred base `0x400000`, including an existing
`.apas` section. Addresses below are preferred virtual addresses, not portable
addresses or approved patch sites.

Both installed `d3d9.dll` files have SHA256
`7ed32d3eef4af5d48710478030e37949a376d002188efdcb6cd26c2844a0a876`.
An available extension source is
`C:/SWG-DEV/Client-DEV-Workspace/dlss5-nvidia-experiment/wrapper-source/d3d9_proxy-dlss5-chain.c`.
Its `installNativeAffectorRibbonProbe` validates the executable timestamp and
image size, verifies expected call bytes, and installs an opt-in relative-call
hook. It already supports the APAS image variant. This proves an existing native
extension mechanism is available; it does not establish that the source builds
byte-identically to the installed DLL. Preserve its rendering and compatibility
features when adding an independently configurable appearance module.

Verified static anchors:

| Address | Evidence and interpretation |
| --- | --- |
| `0x9d3da0` | Initializes the `equipped` property identifier at `0x1935600`. |
| `0x9d7a4b` | Passes that identifier through the color lookup path, writing color storage at `0x1935614`. |
| `0x9d71f6` | Passes that color storage to `0x110ca50` with a UI object in ECX. Candidate equipped-color application path; the surrounding item classification must still be traced. |
| `0x7c9a50` | Method accepting one stack argument and ECX receiver; checks the argument's appearance through a virtual call and emits the skeletal-wearable warning. Strong wearable attachment candidate, not yet a complete typed interface. |
| `0x6474e1` | Direct call to the attachment candidate after constructing an object and calling `0xb22f60`; useful observation point for wearable creation. |
| `0x4376d8`, `0x67a0c1`, `0x6ff10d` | Other direct call sites to `0x7c9a50`; their roles are unverified. |
| `0xa4d061`, `0xa63b31` | References to `RStyleOverlay`; generic overlay paths, not proof of equipped state. |
| `0x119cb58` | References the wearable appearance mapping datatable; no per-character cosmetic semantics established. |

The disassembler labels nearby unrelated exported functions as containing these
addresses. Those labels must not be used as function identities.

Next implementation milestone: an opt-in observation module using the existing
proxy infrastructure, with exact executable/hash and instruction-byte checks.
Capture the real item identity, attachment caller, and equipped-color selection
for the chest/duster sequence before changing either path. Validate object
lifetime and UI-thread execution before retaining any references. Do not hook
the shared color setter globally: that would recolor unrelated UI elements.

The functional prototype should keep genuine equipment containment intact,
introduce explicit cosmetic source/target state shared by server and client,
and override only wearable presentation. Cosmetic inventory overlay should use
a separately supplied fixed cyan color while genuine armor keeps its ordinary
equipped indicator. Define and test the state transport before implementation;
there is currently no verified client appearance-state decoder. The existing
server-only containment substitution cannot provide that distinction reliably.

Acceptance sequence remains the composite chest and gunman's duster: both
visible in inventory, armor normally highlighted, duster cyan, cosmetic visible
to wearer and observer, remove restores armor, nested containers supported,
overlapping cosmetic slots rejected, and relog/zone changes coherent. Expand
to the appearance tab and other wearables only after this sequence passes.

This mapping is static evidence only. No extension was compiled or installed,
and no runtime calling convention or candidate hook was validated in-game.
