@Echo off

:: 1. Choose your KRE Version
SET KRE_VERSION=1.0.0-beta1
SET KRE_ARCH=x86
SET KRE_CLR=CLR
SET PROJECT_PATH=src\Devbot.Net.Identity

:: 2. Install KVM
Start /w PowerShell -NoProfile -NoLogo -ExecutionPolicy unrestricted -Command "[System.Threading.Thread]::CurrentThread.CurrentCulture = ''; [System.Threading.Thread]::CurrentThread.CurrentUICulture = '';& '%~dp0build\build.ps1' '%~dp0'"

:: 3. Install KRE
SET KRE_HOME=%USERPROFILE%\.kre
CALL %KRE_HOME%\bin\kvm install %KRE_VERSION% -%KRE_ARCH% -r %KRE_CLR%

:: 4. Build Solution
SET KRE_CHOSEN=KRE-%KRE_CLR%-%KRE_ARCH%.%KRE_VERSION%
SET KPM_PATH=%KRE_HOME%\packages\%KRE_CHOSEN%
CALL %KPM_PATH%\bin\kpm build "%~dp0%PROJECT_PATH%"

GOTO end

:error
ECHO An error has occurred during build
call :exitSetErrorLevel
call :exitFromFunction 2>nul

:exitSetErrorLevel
exit /b 1
 
:exitFromFunction
()

:end
echo Finished successfully.