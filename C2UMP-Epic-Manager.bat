@echo off
set BINPATH=%cd%\TBL\Binaries\Win64
set PLUGINSPATH=%cd%\Plugins
set MODSPATH=%cd%\TBL\Content\Mods
set STARTDIRECTORY=%cd%
set "TAB=	"
setlocal enabledelayedexpansion

echo Welcome to the C2UMP manager for the epic launcher developed by BK-Foot_lettuce/DrLong! You can find
echo me in the 300 discord or in the Unofficial Modding discord.
echo.
echo This script is not expressly condoned by or associated with the creators of the C2UMP.
echo I've taken care to prevent damaging of your game install, but give no garuntees that it won't happen,
echo so use at your own risk! (If this does happen, contact me so I can fix the bug. A reinstall will fix everything)
echo.
echo IF YOU ARE ON STEAM, THIS IS NOT THE CORRECT MANAGER. DOWNLOAD THE STEAM VERSION!

:menu
cd "%STARTDIRECTORY%"
echo.
echo Menu options:
echo 1: install or disable the plugin loader. The correct action (install/disable) will be detected automatically.
echo 2: uninstall the plugin loader. Doing this and then re-installing is the upgrade process
echo 3: install plugins
echo 4: install mods
echo 5: check installation status
echo 6: exit
choice /n /c 123456 /m "Select an option: "
set CHOICE=%ERRORLEVEL%
cls
if %CHOICE% equ 1 goto installDisable
if %CHOICE% equ 2 goto uninstall
if %CHOICE% equ 3 goto pluginMenu
if %CHOICE% equ 4 goto modMenu
if %CHOICE% equ 5 goto evaluateStatus
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

if not exist Chivalry2Launcher.exe (
	echo No chivalry launcher detected!
	if exist Chivalry2Launcher-ORIGINAL.exe (
		rename Chivalry2Launcher-ORIGINAL.exe Chivalry2Launcher.exe
		echo found the original and renamed it. The situation has been resolved.
	) else (
		echo Could not find a suitable launcher. Your game install may be damaged. 
		echo If you find your original launcher, please rename it to Chivalry2Launcher.exe
	)
) else (
	if exist Chivalry2Launcher-ORIGINAL.exe (
		set MLSTATUS=installed
	) else (
		if exist Chivalry2Launcher-MODDED.exe (
			set MLSTATUS=disabled
		) else (
			set MLSTATUS=not installed
		)
	)
)
echo The plugin launcher is %MLSTATUS%
call :listPlugins
goto menu

:uninstall
if exist Chivalry2Launcher-UNINSTALLED.exe del Chivalry2Launcher-UNINSTALLED.exe
if exist "%BINPATH%\XAPOFX1_5.dll" (
	echo Deleting the plugin loader...
	del "%BINPATH%\XAPOFX1_5.dll"
	echo "Deleting the modded launcher... (If you want this back, it has been renamed to Chivalry2Launcher-UNINSTALLED.exe)"
	rename Chivalry2Launcher.exe Chivalry2Launcher-UNINSTALLED.exe
	rename Chivalry2Launcher-ORIGINAL.exe Chivalry2Launcher.exe
) else (
	echo deleting the plugin loader...
	if exist "%BINPATH%\XAPOFX1_5-MODDED.dll" del "%BINPATH%\XAPOFX1_5-MODDED.dll"
	echo "Deleting the modded launcher... (If you want this back, it has been renamed to Chivalry2Launcher-UNINSTALLED.exe)"
	if exist Chivalry2Launcher-MODDED.exe rename Chivalry2Launcher-MODDED.exe Chivalry2Launcher-UNINSTALLED.exe
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
rename Chivalry2Launcher.exe Chivalry2Launcher-ORIGINAL.exe

echo inserting modded launcher...
if not exist Chivalry2Launcher-MODDED.exe (
	echo Could not find the modded launcher. Downloading latest version from the official github now.
	curl -Lo Chivalry2Launcher-MODDED.exe "https://github.com/C2UMP/C2Loader/releases/latest/download/Chivalry2Launcher.exe"
	if %ERRORLEVEL% neq 0 (
		echo ERROR: Failed to download. This is curl's fault...
		goto menu
	)
)
rename Chivalry2Launcher-MODDED.exe Chivalry2Launcher.exe

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
if not exist Chivalry2Launcher.exe (
	echo There is no launcher installed! Please rename your modded launcher to "Chivalry2Launcher.exe" before continuing!
	echo You can also download this file from the unofficial github repo.
	goto menu
)
if not exist Chivalry2Launcher-ORIGINAL.exe (
	echo Original chivalry launcher not found! Please rename your original launcher to "Chivalry2Launcher.exe"
	echo Your original launcher might be named "Chivalry2Launcher2.exe". In any case, it's the exe with the chivalry logo in the game directory.
	goto menu
)
echo disabling...
echo renaming modded launcher...
rename Chivalry2Launcher.exe Chivalry2Launcher-MODDED.exe

echo replacing original launcher...
rename Chivalry2Launcher-ORIGINAL.exe Chivalry2Launcher.exe

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

:pluginMenu
cls
if not exist "%PLUGINSPATH%" (
	echo made plugins folder
	mkdir "%PLUGINSPATH%"
)
call :listPlugins
echo.
echo Pick plugins to install:
echo %TAB%[1] Server plugin (used to join or host private servers)
echo %TAB%[2] Asset loader (used to load mods)
echo.
echo q: go back to the main menu
echo o: open the plugins folder
echo You can uninstall plugins by opening the plugins folder and deleting the .dll file with the plugin's name
echo.
choice /n /c qo12 /m "Press a number to install that plugin, or letter key: "
set CHOICE=%ERRORLEVEL%
cls
if %CHOICE% equ 1 goto menu
if %CHOICE% equ 2 (
	start explorer.exe "%PLUGINSPATH%"
	goto pluginMenu
)
if %CHOICE% equ 3 call :installc2server
if %CHOICE% equ 4 call :installAssetLoader
goto pluginMenu

:modMenu
if not exist %MODSPATH% mkdir %MODSPATH%
cls
call :listMods
echo.
echo NOTE: If the asset loader and server plugins are not installed, they will be installed automatically when you install a mod.
echo Pick mods to install:
::echo %TAB%Maps:
::echo %TAB%%TAB%[1] ExampleMap
::echo %TAB%%TAB%[2] FFA_TownSquare
::echo %TAB%UI:
::echo %TAB%%TAB%[3] ZainDebugMenu
echo %TAB%[1] All of Zain's mods (individual selection not yet supported):
echo %TAB%%TAB%ExampleMap
echo %TAB%%TAB%FFA_TownSquare
echo %TAB%%TAB%ZainDebugMenu

echo.
echo q: go back to the main menu
echo o: open the mods folder
echo.
choice /n /c qo1 /m "Press a number to install that mod, or letter key: "
set CHOICE=%ERRORLEVEL%
cls
if %CHOICE% gtr 2 (
	call :installAssetLoader
	call :installc2server
)
if %CHOICE% equ 1 goto menu
if %CHOICE% equ 2 (
	start explorer.exe "%MODSPATH%"
	goto modMenu
)
if %CHOICE% equ 3 call :installZainMods
goto modMenu

::prevent fall-through to subroutines
exit

:listPlugins
if exist "%PLUGINSPATH%" (
	echo Installed plugins:
	cd "%PLUGINSPATH%"
	for %%F in (*.dll) do (
		echo %TAB%%%~nF
	)
	goto :EOF
) else (
	echo There are no installed plugins.
	goto :EOF
)

:listMods
if exist "%MODSPATH%\Maps" (
	echo Installed maps:
	cd %MODSPATH%\Maps
	for %%F in (*.umap) do (
		echo %TAB%%%~nF
	)
)

if exist "%MODSPATH%\UI" (
	echo Installed UI mods:
	cd %MODSPATH%\UI
	for %%F in (*.uasset) do (
		echo %TAB%%%~nF
	)
)
goto :EOF

:installc2server
cd "%PLUGINSPATH%"
if not exist C2ServerPlugin.dll (
	echo Downloading the latest C2ServerPlugin.dll version from github...
	curl -Lo C2ServerPlugin.dll "https://github.com/C2UMP/C2ServerPlugin/releases/latest/download/C2ServerPlugin.dll"
	if %ERRORLEVEL% neq 0 echo ERROR: Failed to download. This is curl's fault...
) else (
	echo The C2ServerPlugin already seems to be installed, so nothing will be done.
)
goto :EOF

:installAssetLoader
cd "%PLUGINSPATH%"
if not exist C2AssetLoaderPlugin.dll (
	echo Downloading the latest C2AssetLoaderPlugin.dll version from github...
	curl -Lo C2AssetLoaderPlugin.dll "https://github.com/C2UMP/C2AssetLoaderPlugin/releases/latest/download/C2AssetLoaderPlugin.dll"
	if %ERRORLEVEL% neq 0 echo ERROR: Failed to download. This is curl's fault...
) else (
	echo The C2AssetLoaderPlugin already seems to be installed, so nothing will be done.
)
goto :EOF

:installZainMods
cd "%MODSSPATH%"
if exist "%TMP%\ZainMods" rmdir /S /Q "%TMP%\ZainMods"
mkdir "%TMP%\ZainMods"
echo Downloading the mods from github...
curl -Lo "%TMP%\ZainMods\ZainMods.zip" "https://github.com/C2UMP/C2Mods/archive/refs/heads/main.zip"
if %ERRORLEVEL% neq 0 (
	echo ERROR: Failed to download. This is curl's fault...
	pause
	goto :EOF
)
echo extracting...
cd /d "%TMP%\ZainMods"
tar -xf ZainMods.zip
echo copying...
robocopy C2Mods-main\Mods "%MODSPATH%" /E /IS /MOV
echo Zain's mods are now installed!
cd /d "%STARTDIRECTORY%"
goto :EOF