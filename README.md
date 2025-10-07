## Scripts for changing monitor inputs.

These scripts are for switching monitor inputs between DisplayPort and HDMI using the NVIDIA API.

# Notes

This was built for my personal setup and not intended as a general solution.

* In my case I have a desktop computer and a laptop with docking station sharing a pair of monitors.
* The desktop is using DisplayPort and the laptop is using HDMI.
* The Desktop has an NVIDIA Video Card, which is needed for this to work.
* The scripts switch inputs between HDMI and DisplayPort.
* I invoke the scripts in two ways:
  * Using a StreamDeck connected to the desktop to switch monitor inputs only.
  * or from a Logitech MX Master 4 mouse using the actions ring to switch both the mouse / keyboard connection and the monitor inputs.
* The PowerShell scripts can be run by themselves with the StreamDeck and don't require the .bat files.
* THe .bat files are required to use the Logitech options Run Action.
* I found the NVIDIA API solution after I couldn't get DDC/CI signaling to change the monitor inputs on an LG 27GN800-B. If your monitors support input switching via DDC/CI that would be a better way to do this.
* The scripts must be run on the desktop. For the Logitech Run Action to work from a computer that doesn't have an NVIDIA card (the laptop in my case), the script is launched on the desktop computer via SSH and PsExec
* If your respective computers use different inputs. i.e., your NVIDIA Desktop is on HDMI and the other computer is on DisplayPort or both on HDMI or whatever you'll need to modify the scripts accordingly.
* If both of your computers have NVIDIA cards I guess you could avoid using SSH / PsExec. I'll leave that to you.


# Requirements
* NVIDIA video card on one of the computers.
* SSHD Server setup and running on the Desktop (the computer with the NVIDIA card).
* The computers are on the same network and can communicate via SSH.


# Files
* DisplayPort.png and hdmi.png: Icons for the Logitech MX Master 4 Actions Ring.
* config.bat.template: Contains placeholders for path and host information needed by switch_displayport.bat. Edit and rename (see Setup below).
* keepalive.ps1: My desktop computer goes to sleep soon after the inputs are changed to HDMI. I've tried various power saving and other settings but it still goes to sleep. This script keeps it awake.
* stop_keepalive.ps1: Stops the keepalive script allowing the computer to sleep.
* writeValueToDisplay.exe: used by the PowerShell scripts to switch inputs via the NVIDIA API.
* PsExec.exe used by switch_displayport.bat which switches inputs to the computer with the NVIDIA card. This is needed to establish the remote terminal as a graphical session useable by the NVIDIA API and not headless as would typically be invoked by ssh alone.
* switch_displayport.bat: Invokes switch_displayport.ps1 via SSH and PsExec. Used by the Logitech Options + Action Wheel Run Action.
* switch_hdmi.bat: Invokes switch_hdmi.ps1. Used by the Logitech Options + Action Wheel Run Action.
* switch_displayport.ps1: Switches the monitor inputs to DisplayPort.
* switch_hdmi.ps1: Switches the monitor inputs to HDMI.


# Setup
* These instructions assume the scripts are installed in a OneDrive folder. If you're not using a shared location like OneDrive, modify the paths in the various scripts for your locations. In this case the only file that needs to be on the non-NVIDIA computer is the batch file corresponding to the monitor inputs used by the NVIDIA computer.
* If only one of the computers has an NVIDIA video card, setting up an SSH server on the computer with the NVIDIA card is required.
* Setting up an SSH Server is beyond the scope of these instructions but the basics are:
  * On the computer with the NVIDIA card install the server in Admin Terminal PowerShell with: Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
  * Generate SSH keys on the other computer using ssh-keygen
  * Put the public key on the server in .ssh/autorized_keys
  * If your client computer user is an administrator you may need to put the public key in C:\ProgramData\ssh\administrators_authorized_keys
  * Make sure the key entry in authorized_keys is on one line only without breaks in the key and encoded as UTF-8.
  * Edit C:\ProgramData\ssh\sshd_config and uncomment or add the lines:
    * PubkeyAuthentication yes
    * HostkeyAlgorithms +ssh-rsa
    * PubkeyAcceptedAlgorithms +ssh-rsa
  * Restart the server using Restart-Service sshd
  * Try to connect from the client: ssh -i C:\Users\[username]\.ssh\id_rsa_windows wawza@[server_ip_address or host name]
  * If ssh won't connect use the -v flag for output you can use to troubleshoot.
* Download PsExec.exe from here: https://learn.microsoft.com/en-us/sysinternals/downloads/psexec and place it in the folder with the scripts.
* Clone this repo (or download the files) into a OneDrive folder. As mentioned above. you don't have to use OneDrive you could use another cloud provider or clone to a folder that isn't shared. In the latter case you will need to modify the script paths and the switch_displayport.bat file will need to be stored locally on the computer that doesn't have the NVIDIA card.
* Copy config.bat.template to config.bat and edit the file to include the full path to the scripts and the hostname of your ssh server computer. See comments in the file for details.
* To use with a Logitech MX Master 4 mouse Actions Ring. On each computer assign a Multi-action and add an Easy-Switch 2 devices action for the keboard and mouse to the other computer channel then ADD ACTION + Create Custom Action / Run and point it to the batch file for the inputs used by the other computer. Change to the icons provided in the repo if you wish.
  
  
  
## If writeValueTo_display isn't working for your monitor setup see readme below.
## readme.md for writeValueToDisplay.exe from https://github.com/kaleb422/NVapi-write-value-to-monitor

## NVapi-write-value-to-monitor
Send commands to monitor over i2c using NVapi. <br>
This can be used to issue VCP commands or other manufacturer specific commands


This program relies on the NVIDIA API (NVAPI), to compile it you will need to download the api which can be found here: <br> https://developer.nvidia.com/rtx/path-tracing/nvapi/get-started

### History 
This program was created after discovering that my display does not work with <b>ControlMyMonitor</b> to change inputs using VCP commands. Searching for an antlernative lead me to this thread https://github.com/rockowitz/ddcutil/issues/100 where other users had found a way to switch the inputs of their LG monitors using a linux program, I needed a windows solution. That lead to the NVIDIA API, this program is an adaptation of the i2c example code provided in the API

## Usage

### Syntax
```
writeValueToDisplay.exe <display_index> <input_value> <command_code> [register_address]
```

| Argument | Description |
| -------- | ----------- |
| display_index | Index assigned to monitor by OS (Typically 0 for first screen, try running "mstsc.exe /l" in command prompt to see how windows has indexed your display(s)) |
| input_value   | value to write to screen |
| command_code  | VCP code or other|
| register_address | Address to write to, default 0x51 for VCP codes |



## Example Usage
Change display 0 brightness to 50% using VCP code 0x10
```
writeValueToDisplay.exe 0 0x32 0x10 
```
<br>

Change display 0 input to HDMI 1 using VCP code 0x60 on supported displays
```
writeValueToDisplay.exe 0 0x11 0x60 
```

### Change input on some displays
Some displays do not support using VCP codes to change inputs. I have tested this using values from this thread https://github.com/rockowitz/ddcutil/issues/100 with my LG Ultragear 27GP850-B. Your milage may vary with other monitors, <b>use at your own risk!</b>

#### Change input to HDMI 1 on LG Ultragear 27GP850-B
NOTE: LG Ultragear 27GP850-B is display 0 for me
```
writeValueToDisplay.exe 0 0x90 0xF4 0x50
```

#### Change input to Displayport on LG Ultragear 27GP850-B
NOTE: LG Ultragear 27GP850-B is display 0 for me
```
writeValueToDisplay.exe 0 0xD0 0xF4 0x50
```
