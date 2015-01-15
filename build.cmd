@Echo off

:: 1. Choose your KRE Version
SET KRE_VERSION=1.0.0-beta1
SET KRE_ARCH=x86
SET KRE_CLR=CLR
SET PROJECT_PATH=src\Devbot.Net.Identity

@echo off
cd %~dp0

SETLOCAL
SET CACHED_NUGET=%LocalAppData%\NuGet\NuGet.exe

:: 2. Install Nuget to Cache
IF EXIST %CACHED_NUGET% GOTO copyNuget
echo Downloading latest version of NuGet.exe...
IF NOT EXIST %LocalAppData%\NuGet md %LocalAppData%\NuGet
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest 'https://www.nuget.org/nuget.exe' -OutFile '%CACHED_NUGET%'"

:: 3. Copy Nuget from Cache to Local
:copyNuget
IF EXIST .nuget\nuget.exe goto kvmInstall
md .nuget
copy %CACHED_NUGET% .nuget\nuget.exe > nul

:: 4. Install KVM
:kvmInstall
Start /w PowerShell -NoProfile -NoLogo -ExecutionPolicy unrestricted -Command "[System.Threading.Thread]::CurrentThread.CurrentCulture = ''; [System.Threading.Thread]::CurrentThread.CurrentUICulture = '';& '%~dp0build\build.ps1' '%~dp0'"

:: 5. Restore Build Components
IF EXIST packages\KoreBuild goto runBuild
.nuget\NuGet.exe install KoreBuild -version 0.2.1-rc1-10068 -ExcludeVersion -o packages -nocache -pre
.nuget\NuGet.exe install Sake -version 0.2 -o packages -ExcludeVersion

:: 6. Install KRE
SET KRE_HOME=%USERPROFILE%\.kre
CALL %KRE_HOME%\bin\kvm install %KRE_VERSION% -%KRE_ARCH% -r %KRE_CLR%

:: 7. Create Root Nodejs Directory
:runBuild
IF NOT EXIST bin mkdir bin
IF NOT EXIST bin\nodejs mkdir bin\nodejs

:: 8. Run Build
CALL %KRE_HOME%\bin\kvm use  %KRE_VERSION% -%KRE_ARCH% -r %KRE_CLR%
packages\Sake\tools\Sake.exe -I packages\KoreBuild\build -f build\makefile.shade %*