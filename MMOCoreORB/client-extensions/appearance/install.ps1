param(
    [ValidateSet('Install', 'Restore')][string]$Mode = 'Install',
    [string[]]$ClientDirectories = @('C:\Stardust-DEV'),
    [string]$ProbeDll,
    [string]$BackupRoot
)
$ErrorActionPreference = 'Stop'
$originalHash = '7ED32D3EEF4AF5D48710478030E37949A376D002188EFDCB6CD26C2844A0A876'
$executableHash = 'E782BF1C49B3DA730F66B54BC558947C46493F7133F672EED1D8E0C56A6B6150'
$previousProbeHash = 'BB8962822970F2EE349CCF225BAABFA0ACC53F9273D38F619E0D1796F1219B4C'
$secondProbeHash = 'DF0DD0C798D5E1B9118F43605270322BBBA356651A35C06C0A206EE28FF67409'
$thirdProbeHash = 'B2FAB709D5C58E64A6A4CB23834502E08E0CCA9A12DDB1E307F0577B8490A69E'
$fourthProbeHash = '88B2AE8B94414D80370CE08424FC5F82CD452BAB18564FF93B22C4F31BCEC5E9'
$fifthProbeHash = 'CD5BA68677646EA73769E570C75E9AAB749AE20CF10A7B6814CE2CC0A8615F6D'
$sixthProbeHash = '56E3A04443FA11917781528969E36C8EA58BC4BEF10E1105DB1F3A84724C9299'
$seventhProbeHash = '85F0E8AB18BA71F8972E07B8617C2F612A93F7B5B0C39DE536F6A4AA64E6EF02'
$eighthProbeHash = 'F120E847275E1C7657D443D603937FDD70563B8E2D299F5B3709E3D87956E403'
$ninthProbeHash = 'CA94D80303688D9E1C7D5B24D6BE8E442FC1D27A1751EE3C41AD03FA796763B8'
$tenthProbeHash = 'CF843206F23B2BE3DFE235BA0B5B18E4F0C6B1110432C51A634E38FFA9908BF4'
$probeHash = 'B496567357228A649F2D553ED9C181C935E25394C14898AEA0A01DE791421B0D'
if (-not $BackupRoot) {
    $repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
    $BackupRoot = Join-Path $repositoryRoot 'client-tools\deployment-backups'
}
function Assert-Hash([string]$Path, [string]$Expected) {
    if ((Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash -ne $Expected) {
        throw "File identity differs: $Path"
    }
}
if (Get-Process -Name Stardust, SwgClient_r -ErrorAction SilentlyContinue) {
    throw 'Close all Stardust clients before installing or restoring the probe.'
}
if ($Mode -eq 'Install') {
    if (-not $ProbeDll) { throw 'Specify the built diagnostic DLL with -ProbeDll.' }
    Assert-Hash $ProbeDll $probeHash
}
$plans = foreach ($directory in $ClientDirectories) {
    $root = (Resolve-Path -LiteralPath $directory).Path
    if ($root -eq 'C:\Stardust') { throw 'The public-release client is protected; use C:\Stardust-DEV.' }
    $active = Join-Path $root 'd3d9.dll'
    $base = Join-Path $root 'd3d9-appearance-base.dll'
    $backup = Join-Path $BackupRoot (Split-Path $root -Leaf)
    $saved = Join-Path $backup 'd3d9.dll'
    $config = Join-Path $root 'd3d9-postfx.ini'
    Assert-Hash (Join-Path $root 'Stardust.exe') $executableHash
    if ($Mode -eq 'Install') {
        $activeHash = (Get-FileHash -LiteralPath $active -Algorithm SHA256).Hash
        if ($activeHash -notin @($originalHash, $previousProbeHash, $secondProbeHash, $thirdProbeHash, $fourthProbeHash, $fifthProbeHash, $sixthProbeHash, $seventhProbeHash, $eighthProbeHash, $ninthProbeHash, $tenthProbeHash, $probeHash)) {
            throw "Unexpected active DLL: $active"
        }
        if ($activeHash -in @($previousProbeHash, $secondProbeHash, $thirdProbeHash, $fourthProbeHash, $fifthProbeHash, $sixthProbeHash, $seventhProbeHash, $eighthProbeHash, $ninthProbeHash, $tenthProbeHash, $probeHash)) {
            Assert-Hash $saved $originalHash
            Assert-Hash $base $originalHash
        }
        if (Test-Path -LiteralPath $base) { Assert-Hash $base $originalHash }
        if (Test-Path -LiteralPath $saved) { Assert-Hash $saved $originalHash }
    } else {
        Assert-Hash $saved $originalHash
        if ((Get-FileHash -LiteralPath $active -Algorithm SHA256).Hash -notin @($previousProbeHash, $secondProbeHash, $thirdProbeHash, $fourthProbeHash, $fifthProbeHash, $sixthProbeHash, $seventhProbeHash, $eighthProbeHash, $ninthProbeHash, $tenthProbeHash, $probeHash)) {
            throw "Unexpected active DLL: $active"
        }
    }
    [pscustomobject]@{Root=$root; Active=$active; Base=$base; Backup=$backup;
        Saved=$saved; Config=$config;
        ConfigHash=(Get-FileHash -LiteralPath $config -Algorithm SHA256).Hash}
}
$changed = @()
try {
    foreach ($plan in $plans) {
        if ($Mode -eq 'Install') {
            New-Item -ItemType Directory -Path $plan.Backup -Force | Out-Null
            if (-not (Test-Path -LiteralPath $plan.Saved)) {
                Copy-Item -LiteralPath $plan.Active -Destination $plan.Saved
                Copy-Item -LiteralPath $plan.Config -Destination (Join-Path $plan.Backup 'd3d9-postfx.ini')
            }
            Assert-Hash $plan.Saved $originalHash
            Copy-Item -LiteralPath $plan.Saved -Destination $plan.Base -Force
            Assert-Hash $plan.Base $originalHash
            $changed += $plan
            Copy-Item -LiteralPath $ProbeDll -Destination $plan.Active -Force
            Assert-Hash $plan.Active $probeHash
        } else {
            Copy-Item -LiteralPath $plan.Saved -Destination $plan.Active -Force
            Assert-Hash $plan.Active $originalHash
        }
        Assert-Hash $plan.Config $plan.ConfigHash
        Write-Output "$Mode complete: $($plan.Root); original DLL and post-processing settings verified."
    }
} catch {
    if ($Mode -eq 'Install') {
        foreach ($plan in $changed) {
            Copy-Item -LiteralPath $plan.Saved -Destination $plan.Active -Force
            Assert-Hash $plan.Active $originalHash
        }
    }
    throw
}
