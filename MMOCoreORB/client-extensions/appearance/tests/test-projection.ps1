param(
    [Parameter(Mandatory=$true)][string]$Compiler,
    [string]$OutputDirectory = (Join-Path $env:TEMP ("stardust-appearance-test-" + [guid]::NewGuid()))
)
$ErrorActionPreference = 'Stop'
$coreRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path
$shimRoot = Join-Path $OutputDirectory 'include'
New-Item -ItemType Directory -Path $shimRoot -Force | Out-Null
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'fixture.h') -Destination (Join-Path $shimRoot 'fixture.h') -Force
$headers = @('engine/engine.h', 'engine/util/json_utils.h',
    'server/zone/objects/scene/variables/DeltaVector.h',
    'server/zone/objects/tangible/TangibleObject.h',
    'server/zone/objects/tangible/wearables/ArmorObject.h',
    'templates/tangible/ArmorObjectTemplate.h')
foreach ($header in $headers) {
    $target = Join-Path $shimRoot $header
    New-Item -ItemType Directory -Path (Split-Path $target) -Force | Out-Null
    Set-Content -LiteralPath $target -Value '#include "fixture.h"' -Encoding ascii
}
$testExe = Join-Path $OutputDirectory 'projection-test.exe'
& $Compiler -static -std=c++17 -Wall -Wextra -Werror -I $shimRoot -I (Join-Path $coreRoot 'src') (Join-Path $PSScriptRoot 'projection_test.cpp') -o $testExe
if ($LASTEXITCODE -ne 0) { throw 'Projection test compilation failed.' }
& $testExe
if ($LASTEXITCODE -ne 0) { throw 'Projection test failed.' }
