PARAM($solutionDirectory)

IF (-NOT $solutionDirectory)
{
	$solutionDirectory = $MyInvocation.MyCommand.Path
	$solutionDirectory = Split-Path (Split-Path $solutionDirectory)
	Write-Host "[WARN] Solution Directory not specified so using $solutionDirectory" -ForegroundColor "Yellow"
}

$buildDirectory = Join-Path $solutionDirectory "build"
$installSource = "https://raw.githubusercontent.com/aspnet/Home/master/kvminstall.ps1"
$installTarget = Join-Path $buildDirectory (Split-Path $installSource -LEAF)

$web = New-Object System.Net.WebClient
Write-Host "[INFO] Downloading $installSource to $installTarget" -ForegroundColor "Gray"
$web.DownloadFile($installSource, $installTarget)

& $installTarget