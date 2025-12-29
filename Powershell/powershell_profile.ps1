# Import the module
Import-Module Catppuccin

# Set a flavor for easy access
$Flavor = $Catppuccin['Mocha']
Import-Module -Name Microsoft.WinGet.CommandNotFound
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String ) })

# The following colors are used by PowerShell's formatting
# Again PS 7.2+ only
$PSStyle.Formatting.Debug = $Flavor.Sky.Foreground()
$PSStyle.Formatting.Error = $Flavor.Red.Foreground()
$PSStyle.Formatting.ErrorAccent = $Flavor.Blue.Foreground()
$PSStyle.Formatting.FormatAccent = $Flavor.Teal.Foreground()
$PSStyle.Formatting.TableHeader = $Flavor.Rosewater.Foreground()
$PSStyle.Formatting.Verbose = $Flavor.Yellow.Foreground()
$PSStyle.Formatting.Warning = $Flavor.Peach.Foreground()

# Modified from the official Catppuccin fzf configuration at: https://github.com/catppuccin/fzf/
$ENV:FZF_DEFAULT_OPTS = @"
--color=bg+:$($Flavor.Surface0),bg:$($Flavor.Base),spinner:$($Flavor.Rosewater)
--color=hl:$($Flavor.Red),fg:$($Flavor.Text),header:$($Flavor.Red)
--color=info:$($Flavor.Mauve),pointer:$($Flavor.Rosewater),marker:$($Flavor.Rosewater)
--color=fg+:$($Flavor.Text),prompt:$($Flavor.Mauve),hl+:$($Flavor.Red)
--color=border:$($Flavor.Surface2)
"@

$ENV:HOME="C:\Users\nigel"
$ENV:EDITOR="nvim"
set-alias -Name emacs -Value 'runemacs.exe -nw'
Set-PSReadlineOption -Colors $Colors 
$ENV:YAZI_FILE_ONE = 'C:\Program Files\Git\usr\bin\file.exe'
function y ()
{
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if ( -not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path)
    {
        Set-Location -LiteralPath ([System.IO.Path]::GetFullPath($cwd))
    }

    Remove-Item -Path $tmp
}

function Watch
{
    param (
        [ScriptBlock]$Function,
        [int]$Time = 2
    )

    while ($true)
    {
        Clear-Host
        & $Function
        Start-Sleep -Seconds $Time
    }
}

function prompt
{ 
    # Get IP info
    $ipv4=Get-CimInstance -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=$true | Select-Object -ExpandProperty IPAddress | Select-String 192.*
    $ipv4 = ($ipv4 | ForEach-Object { $_.ToString().Trim() }) -join ','
    $ipv4Label = ''
    if (-not $ipv4)
    {
        $ipv4Label= "IP N/A"
    } else
    {
        $ipv4Label= "IP $ipv4"

    }

    # Get Git branch if available 
    $gitBranch = ''
    if (git rev-parse --is-inside-work-tree 2>$null)
    {
        $currentBranch = git rev-parse --abbrev-ref HEAD
        $gitBranch = "GIT: $currentBranch"
    }

    $currentLocation=$executionContext.SessionState.Path.CurrentLocation

    # default prompt
    "[$ipv4Label $gitBranch ]`n$currentLocation@$Env:COMPUTERNAME $('(PS [>_])$' * ($nestedPromptLevel + 1)) ";
}

set-alias -Name lg -Value lazygit



podman completion powershell | Out-string  | Invoke-Expression
