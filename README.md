# C2UMP-manager
Auto-installer/uninstaller for the Chivalry 2 Unofficial Modding Project

# Instructions:
  Drag and drop the .bat file into your chivalry 2 install folder (where the Chivalry2Launcher.exe is located) and then double click it. Follow the menu instructions from there.
  
# actions:
  
 **Install**: To install means to add the plugin loader to your game. This will allow you tu use mods for chivalry 2. When the plugin loader is installed, you cannot join official servers. This will look for a disabled installation, but if that isn't found, it will download the latest version from the official C2UMP github.
 
 **Disable**: Disabling the plugin loader sets your game install back to vanilla, allowing you to join official servers again. Mod-related files are put to the side so that they won't affect your game, but can be easily found if you want to re-install.
 
 **uninstall**: Same as disable, but actually deletes the plugin loader files.
 
 **check installation status**: Does about what you would expect. Analyzes your game files to report whether or not the plugin loader is installed, if there is a disabled installation, and lists any plugins that are currently installed.
 
 **install plugins**: Allows the automatic installation of certain mods. Currently, only the c2server mod is available here. There is no automatic way to remove these mods, but it's as simple as deleting them from the Plugins folder (or the Plugins folder itself)
 
**Q:** How to upgrade your C2 plugin loader to the latest version?
**A:** run uninstall and then install. This will download the latest files.
