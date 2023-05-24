@echo off
set BINPATH=%cd%\TBL\Binaries\Win64
set PLUGINSPATH=%cd%\TBL\Binaries\Win64\Plugins

echo Welcome to the C2UMP manager for the epic launcher developed by BK-Foot_lettuce/DrLong! You can find
echo me in the 300 discord or in the Unofficial Modding discord.
echo.
echo This script is not expressly condoned by or associated with the creators of the C2UMP.
echo I've taken care to prevent damaging of your game install, but give no garuntees that it won't happen,
echo so use at your own risk! (If this does happen, contact me so I can fix the bug. A reinstall will fix everything)
echo.
echo IF YOU ARE ON EPIC, THIS IS NOT THE CORRECT MANAGER. DOWNLOAD THE EPIC VERSION!
set STARTDIRECTORY=%cd%

:menu
cd "%STARTDIRECTORY%"
echo.
echo Menu options:
echo 1: install or disable the plugin loader. The correct action (install/disable) will be detected automatically.
echo 2: uninstall the plugin loader. Doing this and then re-installing is the upgrade process
echo 3: install plugin(s)
echo 4: check installation status
echo 5: launch modded chivalry
echo 6: exit
choice /c 123456 /m "Select an option "
set CHOICE=%ERRORLEVEL%
cls
if %CHOICE% equ 1 goto installDisable
if %CHOICE% equ 2 goto uninstall
if %CHOICE% equ 3 goto pluginInstall
if %CHOICE% equ 4 goto evaluateStatus
if %CHOICE% equ 5 (
	cd "%BINPATH%"
	start Chivalry2-Win64-Shipping.exe
	exit
)
if %CHOICE% equ 6 exit

:evaluateStatus
if exist "%BINPATH%\XAPOFX1_5.dll" (
	set PLSTATUS=installed
) else (
	if exist "%BINPATH%\XAPOFX1_5-MODDED.dll" (
		set PLSTATUS=disabled
	) else (
		set PLSTATUS=not installed
	)
)
echo The plugin loader is %PLSTATUS%

if exist "%PLUGINSPATH%" (
	echo The plugins currently installed are:
	dir "%PLUGINSPATH%" /b
)
goto menu

:uninstall
echo Deleting the plugin loader...
if exist "%BINPATH%\XAPOFX1_5.dll" (
	del "%BINPATH%\XAPOFX1_5.dll"
) else (
	if exist "%BINPATH%\XAPOFX1_5-MODDED.dll" (
		del "%BINPATH%\XAPOFX1_5-MODDED.dll"
	) else (
		echo Could not find the plugin loader, so it's already uninstalled!
	)
)
goto menu

:installDisable
if exist "%BINPATH%\XAPOFX1_5.dll" (
	goto disable
) else (
    goto install
)


:install
echo installing...
echo renaming original launcher...
if not exist Chivalry2Launcher.exe (
	echo Warning: The original launcher was not found. This may indicate a broken chivalry install. 
	echo "(this script hasn't touched anything yet, so it's not my fault!) As it is now, your game cannot be launched."
	echo The modded launcher will instead be used, but you will not be able to uninstall the mods without the original launcher!
)

echo inserting plugin loader dll...
cd "%BINPATH%"
if not exist XAPOFX1_5-MODDED.dll (
	echo Could not find the plugin loader. Downloading latest version from the official github now.
	curl -Lo XAPOFX1_5-MODDED.dll "https://github.com/C2UMP/C2PluginLoader/releases/latest/download/XAPOFX1_5.dll"
	if %ERRORLEVEL% neq 0 (
		echo ERROR: Failed to download. This is curl's fault...
		goto menu
	)
)
rename "XAPOFX1_5-MODDED.dll" "XAPOFX1_5.dll"
echo the unofficial chivalry mod loader is now installed!
goto menu

:disable
echo disabling...

echo renaming plugin loader dll...
cd "%BINPATH%"
if exist XAPOFX1_5-MODDED.dll (
	echo XAPOFX1_5-MODDED.dll already exists. This might be the result of some confusion, but it's not an issue
	echo This file will now be replaced with the plugin loader that is being used now.
	echo "You can get this file back from the github. (This script will do that for you if it's needed.)"
	del XAPOFX1_5-MODDED.dll
)
rename "XAPOFX1_5.dll" "XAPOFX1_5-MODDED.dll"
echo the unofficial chivalry mod loader is now disabled!
echo note: the plugins you had have not been removed, but their presence shouldn't affect your game.
goto menu

:pluginInstall
choice /c yn /m "Would you like to install the c2server plugin (required for hosting/joining private servers) now "
if %ERRORLEVEL% equ 1 ( 
	if not exist "%PLUGINSPATH%" (
		mkdir "%PLUGINSPATH%"
		echo Created Plugins folder
	)
	goto installc2server 
) else ( 
	goto menu
)

:installc2server
cd "%PLUGINSPATH%"
if not exist C2ServerPlugin.dll (
	echo Downloading the latest C2ServerPlugin.dll version from github...
	curl -Lo C2ServerPlugin.dll "https://github.com/C2UMP/C2ServerPlugin/releases/latest/download/C2ServerPlugin.dll"
	if %ERRORLEVEL% neq 0 echo ERROR: Failed to download. This is curl's fault...
) else (
	echo The C2ServerPlugin already seems to be installed, so nothing will be done.
)
goto menu