# Install Mac ISO
[ref](https://adersaytech.com/tutorial/macos/how-to-create-monterey-12-iso.html)

## Install MacOS
1. Install MacOS in Appstore

2. Generat MacOS img
``` bash
hdiutil create -o "<file path>" -size 15g -layout GPTSPUD -fs HFS+J
hdiutil attach -noverify -mountpoint /Volumes/install_build "<file path>"
sudo "/Applications/Install\ macOS\ <OS version>.app/Contents/Resources/createinstallmedia" --volume /Volumes/install_build --nointeraction
hdiutil detach "/Volumes/Install macOS <OS version>"
```

3. Remove MacOS installer from Finder
