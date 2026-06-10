# Dotfiles

function Toggle-Host {
    & "$HOME\Scripts\ToggleHost.ps1"
}

function Edit-UserSecrets {
    [CmdletBinding()]
    param()

    $proj = Get-ChildItem -Filter *.csproj -File | Select-Object -First 1
    if (-not $proj) {
        Write-Warning "No .csproj in the current directory - not in a project. Cancelled."
        return
    }

    [xml]$xml = Get-Content $proj.FullName -Raw
    $secretsId = $xml.Project.PropertyGroup.UserSecretsId |
        Where-Object { $_ } | Select-Object -First 1

    if (-not $secretsId) {
        Write-Warning "$($proj.Name) has no <UserSecretsId>. Run 'dotnet user-secrets init' first."
        return
    }

    $secretsPath = Join-Path $env:APPDATA "Microsoft\UserSecrets\$secretsId\secrets.json"

    if (-not (Test-Path $secretsPath)) {
        New-Item -ItemType File -Path $secretsPath -Force | Out-Null
        '{}' | Set-Content -Path $secretsPath
    }

    nvim $secretsPath
}

Set-Alias -Name secrets -Value Edit-UserSecrets

Import-Module posh-git

Set-Alias -Name p -Value pnpm

# Create the 'g' shortcut function
function g { & git @args }

# Force PowerShell to forward git's tab-completion to your new 'g' function
if (Get-Command Register-ArgumentCompleter -ErrorAction SilentlyContinue) {
    Register-ArgumentCompleter -Native -CommandName g -ScriptBlock {
        param($wordToComplete, $commandAst, $cursorPosition)
        # Queries the underlying git system for completions
        [System.Management.Automation.CommandCompletion]::CompleteInput(
            $commandAst.ToString().Remove(0,1).Insert(0,"git"),
            $cursorPosition,
            $null
        ).CompletionMatches
    }
}
