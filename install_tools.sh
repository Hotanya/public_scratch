#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
CHECK_MARK="${GREEN}✅${NC}"
CROSS_MARK="${RED}❌${NC}"

# Tool list with their identifying command
declare -A TOOLS
TOOLS=(
  ["git"]="git"
  ["net-tools"]="netstat"
  ["python3"]="python3"
  ["python3-pip"]="pip3"
  ["cowsay"]="cowsay"
  ["tmux"]="tmux"
  ["neofetch"]="neofetch"
  ["jq"]="jq"
  ["ohmytmux"]="ohmytmux"
  ["qemu-guest-agent"]="qemu-ga"
)

# Track status and errors
declare -A TOOL_STATUS
declare -A TOOL_ERRORS

#add /usr/games to path
export PATH=$PATH:/usr/games

# Function to check if a tool is installed
is_installed() {
  command -v "$1" >/dev/null 2>&1
}

# Initialize tool statuses
for tool in "${!TOOLS[@]}"; do
  if [ "$tool" == "ohmytmux" ]; then
    [[ -d "$HOME/.tmux" ]] && TOOL_STATUS[$tool]="installed" || TOOL_STATUS[$tool]="missing"
  else
    is_installed "${TOOLS[$tool]}" && TOOL_STATUS[$tool]="installed" || TOOL_STATUS[$tool]="missing"
  fi
done

# Function to render tool list with errors
print_tool_list() {
  clear
  echo -e "${BLUE}Tool Installation Status:${NC}"
  for tool in "${!TOOLS[@]}"; do
    if [[ "${TOOL_STATUS[$tool]}" == "installed" ]]; then
      echo -e "  ${CHECK_MARK} $tool"
    else
      echo -e "  ${CROSS_MARK} $tool"
    fi
  done

  # Display error messages if any
  echo ""
  for tool in "${!TOOL_ERRORS[@]}"; do
    echo -e "${RED}⚠️  Error installing ${tool}:${NC} ${TOOL_ERRORS[$tool]}"
  done
  echo ""
}

# Display initial list
print_tool_list

# Update package list
echo -e "${BLUE}Updating package list...${NC}"
sudo apt-get update -qq

# Try to install missing tools
for tool in "${!TOOLS[@]}"; do
  if [[ "${TOOL_STATUS[$tool]}" == "missing" ]]; then
    echo -e "${YELLOW}Installing $tool...${NC}"
    if [[ "$tool" == "ohmytmux" ]]; then
      if git clone -q https://github.com/gpakosz/.tmux.git "$HOME/.tmux"; then
        ln -sf "$HOME/.tmux/.tmux.conf" "$HOME/.tmux.conf"
        [ ! -f "$HOME/.tmux.conf.local" ] && cp "$HOME/.tmux/.tmux.conf.local" "$HOME/.tmux.conf.local"
        TOOL_STATUS[$tool]="installed"
      else
        TOOL_ERRORS[$tool]="Failed to clone ohmytmux repository."
      fi
    else
      # Capture stderr while installing
      ERROR_MSG=$(sudo apt-get install -y -qq "$tool" 2>&1)
      if is_installed "${TOOLS[$tool]}"; then
        TOOL_STATUS[$tool]="installed"
      else
        TOOL_ERRORS[$tool]="$ERROR_MSG"
      fi
    fi
    print_tool_list
  fi
done

# Enable qemu-guest-agent if installed
if [[ "${TOOL_STATUS["qemu-guest-agent"]}" == "installed" ]]; then
  sudo systemctl enable -q qemu-guest-agent || \
  TOOL_ERRORS["qemu-guest-agent"]="Installed, but failed to enable qemu-guest-agent in systemctl."
fi

# Final message
if [[ ${#TOOL_ERRORS[@]} -eq 0 ]]; then
  echo -e "${GREEN}All tools installed successfully!${NC}"
else
  echo -e "${RED}Some tools failed to install. See above for details.${NC}"
fi
