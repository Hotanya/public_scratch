#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Update the package list
echo -e "${BLUE}Updating package list...${NC}"
sudo apt-get update -y


# Install git
echo -e "${YELLOW}Installing git...${NC}"
sudo apt-get install git -y && echo -e "${GREEN}Git installed successfully.${NC}" || echo -e "${RED}Failed to install Git.${NC}"


# Install net-tools
echo -e "${YELLOW}Installing net-tools...${NC}"
sudo apt-get install net-tools -y && echo -e "${GREEN}net-tools installed successfully.${NC}" || echo -e "${RED}Failed to install net-tools.${NC}"


# Install Python 3
echo -e "${YELLOW}Installing Python 3...${NC}"
sudo apt-get install python3 -y && echo -e "${GREEN}Python 3 installed successfully.${NC}" || echo -e "${RED}Failed to install Python 3.${NC}"


# Install Python 3 pip
echo -e "${YELLOW}Installing Python 3 pip...${NC}"
sudo apt-get install python3-pip -y && echo -e "${GREEN}Python 3 pip installed successfully.${NC}" || echo -e "${RED}Failed to install Python 3 pip.${NC}"


# Install cowsay
echo -e "${YELLOW}Installing cowsay...${NC}"
sudo apt-get install cowsay -y && echo -e "${GREEN}Cowsay installed successfully.${NC}" || echo -e "${RED}Failed to install Cowsay.${NC}"


# Install tmux
echo -e "${YELLOW}Installing tmux...${NC}"
sudo apt-get install tmux -y && echo -e "${GREEN}Tmux installed successfully.${NC}" || echo -e "${RED}Failed to install Tmux.${NC}"


# Install neofetch
echo -e "${YELLOW}Installing neofetch...${NC}"
sudo apt-get install neofetch -y && echo -e "${GREEN}Neofetch installed successfully.${NC}" || echo -e "${RED}Failed to install Neofetch.${NC}"


# Install jq
echo -e "${YELLOW}Installing jq...${NC}"
sudo apt-get install jq -y && echo -e "${GREEN}Jq installed successfully.${NC}" || echo -e "${RED}Failed to install Jq.${NC}"


# Install ohmytmux settings
echo -e "${YELLOW}Installing ohmytmux settings...${NC}"
if [ ! -d "$HOME/.tmux" ]; then
   git clone https://github.com/gpakosz/.tmux.git "$HOME/.tmux" && echo -e "${GREEN}Oh My Tmux repository cloned successfully.${NC}" || echo -e "${RED}Failed to clone Oh My Tmux repository.${NC}"
fi


# Create a symbolic link for the tmux configuration file
ln -sf "$HOME/.tmux/.tmux.conf" "$HOME/.tmux.conf" && echo -e "${GREEN}Symbolic link for .tmux.conf created successfully.${NC}" || echo -e "${RED}Failed to create symbolic link for .tmux.conf.${NC}"


# Append or create the .tmux.conf.local file for personal customizations
if [ ! -f "$HOME/.tmux.conf.local" ]; then
  cp "$HOME/.tmux/.tmux.conf.local" "$HOME/.tmux.conf.local" && echo -e "${GREEN}.tmux.conf.local file created successfully.${NC}" || echo -e "${RED}Failed to create .tmux.conf.local file.${NC}"
fi


# Install qemu guest agent
echo -e "${YELLOW}Installing qemu guest agent...${NC}"
sudo apt-get install qemu-guest-agent -y && echo -e "${GREEN}qemu guest agent installed successfully.${NC}" || echo -e "${RED}Failed to install qemu guest agent.${NC}"


# Enabling in systemctl
echo -e "${YELLOW}Enabling in systemctl...${NC}"
sudo systemctl enable qemu-guest-agent


echo -e "${GREEN}All specified tools and ohmytmux settings have been installed successfully.${NC}"
