#!/bin/bash
set -e

# === Colors ===
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

# === Common Function ===
function clone_wallet_repo() {
  if [ ! -d "wallet-gen" ]; then
    echo -e "${YELLOW}📁 Cloning Octra wallet-gen repo...${NC}"
    git clone https://github.com/octra-labs/wallet-gen.git
  else
    echo -e "${GREEN}✔ wallet-gen already exists, skipping clone${NC}"
  fi
  cd wallet-gen
}

# === VPS Function ===
function install_for_vps() {
  echo -e "${YELLOW}🔧 Updating and installing packages for VPS...${NC}"
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y curl git ufw screen

  if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Node.js v22...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt install -y nodejs
  else
    echo -e "${GREEN}✔ Node.js installed (v$(node -v))${NC}"
  fi

  if ! command -v yarn &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Yarn...${NC}"
    npm install -g yarn
  else
    echo -e "${GREEN}✔ Yarn installed (v$(yarn -v))${NC}"
  fi

  echo -e "${YELLOW}🛡️ Configuring firewall (ufw)...${NC}"
  sudo ufw allow 22
  sudo ufw allow 8888
  sudo ufw --force enable

  clone_wallet_repo
  chmod +x ./wallet-generator.sh

  echo -e "${YELLOW}🚀 Launching wallet generator (3h) in screen session 'wallet-gen'...${NC}"
  screen -dmS wallet-gen bash -c "timeout 3h ./wallet-generator.sh"
  sleep 2
  screen -S wallet-gen -X stuff $'\n'

  VPS_IP=$(curl -s https://api.ipify.org)

  echo -e "${GREEN}✅ Wallet server running (3h max).${NC}"
  echo -e "${CYAN}🌐 Open in browser: http://${VPS_IP}:8888${NC}"
  echo -e "${CYAN}📄 View logs with: screen -r wallet-gen${NC}"
  echo -e "${YELLOW}💧 Faucet: https://faucet.octra.network/${NC}"
}

# === WSL Function ===
function install_for_wsl() {
  echo -e "${YELLOW}🔧 Setting up for WSL...${NC}"
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y curl git screen

  if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Node.js v22...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt install -y nodejs
  else
    echo -e "${GREEN}✔ Node.js installed (v$(node -v))${NC}"
  fi

  if ! command -v yarn &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Yarn...${NC}"
    npm install -g yarn
  else
    echo -e "${GREEN}✔ Yarn installed (v$(yarn -v))${NC}"
  fi

  clone_wallet_repo
  chmod +x ./wallet-generator.sh
  echo -e "${YELLOW}🚀 Starting wallet server...${NC}"
  ./wallet-generator.sh &

  echo -e "${CYAN}🌐 Open in browser: http://localhost:8888${NC}"
  echo -e "${CYAN}📄 View logs with: screen -r wallet-gen${NC}"
  echo -e "${YELLOW}💧 Faucet: https://faucet.octra.network/${NC}"
}

# === Prompt User ===
echo -e "${YELLOW}Select your environment:${NC}"
echo "1) VPS (Linux server)"
echo "2) WSL (Linux on Windows)"
read -p "Enter 1 or 2: " CHOICE

case $CHOICE in
  1) install_for_vps ;;
  2) install_for_wsl ;;
  *) echo -e "${RED}❌ Invalid choice. Exiting.${NC}"; exit 1 ;;
esac
