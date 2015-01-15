PARAM($solutionDirectory)

IF (-NOT $solutionDirectory)
{
	$solutionDirectory = $MyInvocation.MyCommand.Path
	$solutionDirectory = Split-Path (Split-Path $solutionDirectory)
	Write-Host "[WARN] Solution Directory not specified so using $solutionDirectory" -ForegroundColor "Yellow"
}

# Install KVM
Write-Host "[INFO] Installing KVM"  -ForegroundColor "Gray"
$buildDirectory = Join-Path $solutionDirectory "build"
$installSource = "https://raw.githubusercontent.com/aspnet/Home/master/kvminstall.ps1"
$installTarget = Join-Path $buildDirectory (Split-Path $installSource -LEAF)

$web = New-Object System.Net.WebClient
Write-Host "[INFO] Downloading $installSource to $installTarget" -ForegroundColor "Gray"
$web.DownloadFile($installSource, $installTarget)

& $installTarget
Remove-Item $installTarget

# Install .Net if required
$dotNetInstalled = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |
Get-ItemProperty -name Version -EA 0 |
Where { $_.PSChildName -match '^[Client|Full]' -and $_.Version -match '^4.5(.\d+)' }
#IF ($dotNetInstalled) { EXIT }
Write-Host "[INFO] Installing .Net 4.5" -ForegroundColor "Gray"

# There is probably a better url to use here, feel free to change (let me know for my own installs please!)
$installSource = "http://go.microsoft.com/fwlink/?LinkId=225702"
$installTarget = Join-Path $buildDirectory "NDP452-KB2901907-x86-x64-AllOS-ENU.exe"
Write-Host "[INFO] Downloading $installSource to $installTarget" -ForegroundColor "Gray"
$web.DownloadFile($installSource, $installTarget)

Start-Process -FilePath $installTarget -ArgumentList "/q /norestart" -Wait -Verb RunAs

Remove-Item $installTarget