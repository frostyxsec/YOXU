# Yoxu - IoT ADB Exploitation Tool

<img src="https://raw.githubusercontent.com/frostyxsec/YOXU/refs/heads/main/logo.jpg">

## Overview

Yoxu is a specialized bash script designed for testing ADB (Android Debug Bridge) connections to IoT devices. It automates the process of establishing connections to potentially vulnerable devices and provides a comprehensive set of tools for information gathering and exploitation.

## Features

- **Easy Connection Testing**: Quickly connect to IoT devices via ADB using simple IP:port syntax
- **System Information Gathering**: Collects critical system information using various fallback methods
- **Root Access Detection**: Checks for root/privileged access using multiple verification approaches
- **Interactive Shell**: Provides optional interactive shell access to connected devices
- **Custom Command Execution**: Allows execution of arbitrary commands on the target device

## Screenshots

### System Exploration
Exploring the filesystem and process list of a connected device:

<img src="https://raw.githubusercontent.com/frostyxsec/YOXU/refs/heads/main/1.png">

### Command Execution
Executing custom commands on a compromised device:

<img src="https://raw.githubusercontent.com/frostyxsec/YOXU/refs/heads/main/2.png">

## Installation

1. Clone this repository or download `yoxu.sh`
2. Make the script executable:
   ```bash
   chmod +x yoxu.sh
   ```
3. Ensure you have ADB installed on your system:
   ```bash
   # For Debian/Ubuntu
   sudo apt install adb
   
   # For Fedora
   sudo dnf install android-tools
   
   # For Arch
   sudo pacman -S android-tools
   ```

## Usage

### Basic Connection Testing
```bash
./yoxu.sh <ip:port>
```

Example:
```bash
./yoxu.sh 192.168.1.100:5555
```

## Security Notice

This tool is provided for educational and security research purposes only. Always ensure you have proper authorization before connecting to any device. Unauthorized access to computer systems may be illegal in your jurisdiction.

## Technical Details

Yoxu uses a variety of techniques to maximize compatibility across different IoT devices:

- Multiple command fallbacks for system information gathering
- OS detection via filesystem structure analysis
- Efficient connection handling with timeout controls

## Limitations

- Requires ADB to be installed on the testing machine
- Target devices must have ADB enabled and accessible
- Some commands may not work on all IoT firmware variants

## License

This project is released under the MIT License.

## Author

Yoxu Security Research Team
