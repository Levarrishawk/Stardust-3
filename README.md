# Stardust 3.X

Stardust 3.X is a custom [SWGEmu Core3](https://github.com/swgemu/Core3) server emulator for *Star Wars Galaxies*. It was forked from the Core3 main branch on June 1, 2026 and serves as the foundation for a new generation of the Stardust project.

The project retains the established Core3 architecture while extending its server code, gameplay scripts, content, and tooling. Development is ongoing, and features, configuration, and data may change as the project evolves.

## Technology

Stardust is primarily built with:

- C++14 for the server and engine-facing systems
- Lua for gameplay content and screenplays
- IDL for generated object interfaces
- SQL for persistent game data
- XML and object-template configuration
- [Engine3](https://github.com/swgemu/engine3) as a Git submodule

The server uses CMake and Make and depends on Lua 5.3, MySQL or MariaDB, Berkeley DB, Java, OpenSSL, and zlib. A 64-bit build target is required.

## Repository layout

```text
Stardust-3/
|-- MMOCoreORB/     Core3 server source, scripts, configuration, and SQL
|-- docker/         Container bootstrap and runtime support
|-- linux/          Debian bootstrap tooling
|-- wsl2/           Windows Subsystem for Linux setup tooling
|-- tools/          Project maintenance and analysis utilities
`-- README.md       Project overview
```

Most development takes place in `MMOCoreORB`:

- `src/` contains the C++, IDL, templates, terrain, and test sources.
- `bin/scripts/` contains Lua gameplay scripts and screenplays.
- `bin/conf/` contains runtime configuration.
- `sql/` contains database initialization data.
- `utils/engine3/` contains the Engine3 submodule.

## Getting started

### Prerequisites

- A 64-bit Debian Linux environment (the authoritative build and runtime platform)
- Git with submodule support
- A supported C++ compiler and CMake
- Lua 5.3, MySQL/MariaDB, Berkeley DB, Java, OpenSSL, and zlib development packages
- Legally obtained SWG client data files required by Core3

Clone the repository and initialize its submodules:

```bash
git clone --recurse-submodules <repository-url> Stardust-3
cd Stardust-3
```

For an existing clone:

```bash
git submodule update --init --recursive
```

Platform bootstrap helpers are documented in [`linux/README.md`](linux/README.md) and [`wsl2/README.md`](wsl2/README.md). Review those scripts before running them and adapt their upstream Core3 paths or defaults for this fork where necessary.

### Build

From the Core3 source directory:

```bash
cd MMOCoreORB
make -j$(nproc)
```

The default Make target configures CMake, generates the IDL sources, and builds the server. CMake also exposes optional sanitizer, test, REST server, and developer-mode settings; see `MMOCoreORB/CMakeLists.txt` and `MMOCoreORB/Makefile` for the supported targets and flags.

### Configure and run

Before starting the server:

1. Create the required MySQL/MariaDB database using the SQL under `MMOCoreORB/sql`.
2. Configure local database and server settings under `MMOCoreORB/bin/conf`.
3. Place the required client data in the server's configured TRE directory.
4. Start the server from `MMOCoreORB/bin` using the appropriate Core3 launcher for your build.

Do not commit passwords, local configuration, databases, logs, build output, crash dumps, or proprietary game assets.

## Development notes

Stardust follows Core3 conventions. Changes should reuse existing managers, tasks, screenplays, engine pointer types, and synchronization patterns whenever possible. Gameplay systems often cross C++, Lua, IDL, SQL, and client-data boundaries, so declarations, generated interfaces, persistence, and runtime behavior should be verified together.

A successful compile is only the first validation step. Gameplay changes should also be tested in a running server, including relevant login, logout, zone-transfer, persistence, and repeated-interaction cases.

## Client assets

This repository does not distribute the original *Star Wars Galaxies* client or its proprietary data files. You must supply any required TRE or other client assets from a legally obtained installation. Some server-side changes may require corresponding client assets or configuration that are outside this repository.

## Project status

Stardust 3.X is under active development and is not presented as a production-ready release. Expect incomplete systems and breaking changes while the project's direction and feature set are established.

## License and attribution

The repository is derived from SWGEmu Core3 and includes work from the SWGEmu contributors. Unless a file states otherwise, the project is distributed under the GNU Affero General Public License version 3; see [`COPYING`](COPYING) for the full license text.

*Star Wars Galaxies*, Star Wars, and related names and marks are properties of their respective owners. Stardust is an unofficial fan project and is not affiliated with or endorsed by Lucasfilm, Disney, or Daybreak Game Company.
