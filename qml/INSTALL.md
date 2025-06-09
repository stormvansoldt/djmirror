# How to install DjMirror

This installation guide will walk you through the process of setting up DjMirror for Traktor Pro. The process consists of four main steps: First, you'll need to configure environment variables to allow file access (different steps for Windows and macOS). Second, download and extract the latest MOD file from the official announcement. Third, set up the QML files by replacing the existing directories in your Traktor installation. For macOS users, there's an additional step to create a desktop shortcut for proper environment variable loading. Finally, configure the Traktor S8 controller in Traktor's preferences, which will create two DjMirror windows that you can position on your touch screens. After completing these steps, restart Traktor Pro to apply all changes.

## **A) Environment Variables Setup:**

This step allows you to configure the system environment so that the MOD can save the configuration files correctly.

To access local files, you need to set the following environment variables:

QML_XHR_ALLOW_FILE_READ=1
QML_XHR_ALLOW_FILE_WRITE=1



------------------------------------------------------------------------------------------------------------------

### **On Windows:**

**Option 1 - Using System GUI (Windows 11):**
1. Press `Windows + I` to open Settings
2. Click on **System** in the left sidebar
3. Scroll down and click on **About**
4. Click on **Advanced system settings** under "Related settings"
5. In the System Properties window, click on **Environment Variables**
6. Under "System variables", click **New** and add:
   - Variable name: `QML_XHR_ALLOW_FILE_READ`
   - Variable value: `1`
7. Click **New** again and add:
   - Variable name: `QML_XHR_ALLOW_FILE_WRITE`
   - Variable value: `1`
8. Click **OK** on all windows to save changes
9. Restart your computer for changes to take effect

**Option 2 - Using PowerShell (Alternative method):**
1. Open PowerShell as Administrator
2. Copy and paste these commands:
```powershell
[System.Environment]::SetEnvironmentVariable('QML_XHR_ALLOW_FILE_READ', '1', 'Machine')
[System.Environment]::SetEnvironmentVariable('QML_XHR_ALLOW_FILE_WRITE', '1', 'Machine')
```
3. Restart your computer


------------------------------------------------------------------------------------------------------------------

### **Environment Variables Setup - macOS**

**Option 1 - Using Terminal (Recommended):**
1. Open Terminal
2. For zsh (default shell in modern macOS):

```bash
echo 'export QML_XHR_ALLOW_FILE_READ=1' >> ~/.zshrc
echo 'export QML_XHR_ALLOW_FILE_WRITE=1' >> ~/.zshrc
source ~/.zshrc
```


------------------------------------------------------------------------------------------------------------------

## **B) Download MOD file:**

This step allows you to download the MOD in its latest version (only if you have the subscription).

  - Access to the official announcement of the latest version
  - Click **Download ZIP MOD file v1.x.x** (for mac o win)
  - Unzip the download in a temporary folder

**Note:** After setting the environment variables, restart Traktor for the changes to take effect.

------------------------------------------------------------------------------------------------------------------

## **C) Setup QML Files**

This step allows you to add the new functionality to your Traktor installation.

**Windows:**
  - Quit Traktor
  - Navigate to **C:\Program Files\Native Instruments\Traktor Pro X\Resources64\**
  - Make a backup copy of the **qml** directory. For example, copy it to **qmlBackup**
  - Create a new directory named **qml**
  - Copy the contents of the unzipped repo into the **qml** directory, replacing the **CSI**, **Defines**, and **Screens** directories
  - Start Traktor Pro
  
**macOS:**
  - Quit Traktor
  - Navigate to **/Applications/Native Instruments/Traktor Pro X**
  - Right-click **Traktor**, then select **Show Package Contents**
  - Navigate to **Contents/Resources/**
  - Make a backup copy of the **qml** folder. For example, copy it to **qmlBackup**
  - Copy the contents of the unzipped repo into the **qml** folder, replacing the **CSI**, **Defines**, and **Screens** folders
  - Not start Traktor Pro


------------------------------------------------------------------------------------------------------------------


## **D) Create Desktop Shortcut - macOS only**

This step allows you to add an icon that runs Traktor correctly (loading the two QML environment variables).

### **Opening Terminal and Setting Privacy Permissions:**

1. **Open Terminal:**
   - Click on the Spotlight search icon (magnifying glass) in the top-right corner of your screen
   - Type "Terminal" and press Enter, or
   - Go to Applications > Utilities > Terminal

2. **Grant Terminal Full Disk Access:**
   - Click the Apple menu () > System Settings
   - Select Privacy & Security > Full Disk Access
   - Click the lock icon in the bottom-left corner and enter your password
   - Click the "+" button to add an application
   - Navigate to Applications > Utilities
   - Select Terminal and click "Open"
   - Ensure the checkbox next to Terminal is checked
   - Close System Settings

3. **Run the following commands in Terminal:**
```bash

cd /Applications/Native Instruments/Traktor Pro 4/Traktor Pro 4.app/Contents/Resources/qml/

sudo chmod +x /Applications/Native Instruments/Traktor Pro 4/Traktor Pro 4.app/Contents/Resources/qml/start_traktor.sh
sudo chmod +x /Applications/Native Instruments/Traktor Pro 4/Traktor Pro 4.app/Contents/Resources/qml/create_desktop_launcher.sh

```

4. **When prompted for your password:**
   - Enter your Mac user password (it will not be visible as you type)
   - Press Enter

5. **Run the desktop shortcut creation script:**

```bash
./create_desktop_launcher.sh
```

This will create a `Start Traktor.command` file on your desktop that you can double-click to launch Traktor with the environment variables properly configured.

**Note:** If you receive a "permission denied" error when trying to run the script, you may need to modify the file paths according to your specific Traktor installation location.


------------------------------------------------------------------------------------------------------------------

## **Configure Traktor S8 Controller**
This step allows you to create the two necessary windows that give access to the main functionality of the product.

1. Launch Traktor Pro
2. Go to **Preferences** (⌘, on macOS or Ctrl+, on Windows)
3. In the preferences window:
   - Select the **Controller Manager** tab
   - Click **Add** > **Pre-Mapped** >  **Traktor Kontrol** > **S8**
4. Two new DjMirror windows have to appear on the screen
5. Restart Traktor Pro

**Note:** If two DjMirror windows is not automatically review installation

6. Move and anchor Windows on your Touch Screens
