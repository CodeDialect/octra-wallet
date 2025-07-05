#!/bin/bash
set -e
ENV_FILE=".octra_env"

echo "📦 Installing system dependencies..."
sudo apt update
sudo apt install -y python3 python3-pip python3-venv nodejs npm git curl ufw screen

# === Wallet setup ===
if [ -f "$ENV_FILE" ]; then
  echo "✅ Using existing wallet config from $ENV_FILE"
  source "$ENV_FILE"
else
  echo "🔐 Wallet Setup"
  read -p "Enter base64 PRIVATE_KEY: " PRIVATE_KEY
  read -p "Enter OCTRA_ADDRESS (starts with 'oct'): " OCTRA_ADDRESS

  echo "Saving to $ENV_FILE..."
  {
    echo "priv=${PRIVATE_KEY}"
    echo "addr=${OCTRA_ADDRESS}"
    echo "rpc=https://octra.network"
  } > "$ENV_FILE"
  chmod 600 "$ENV_FILE"
fi

echo ""
echo "🌐 Choose deployment mode:"
echo "1) Terminal CLI (interactive menu via cli.py)"
echo "2) Web UI (React + Express + Screen)"
read -p "Enter choice (1 or 2): " mode

if [[ "$mode" == "1" ]]; then
  echo "🧪 Setting up Terminal CLI..."
  sudo apt install -y zenity

  cat > octra_terminal.sh <<'EOS'
#!/bin/bash
ENV_FILE=".octra_env"
if [ ! -f "$ENV_FILE" ]; then
  echo "❌ Wallet config not found. Run oct.sh first."
  exit 1
fi

set -a
source "$ENV_FILE"
set +a

rm -rf octra_pre_client
git clone https://github.com/octra-labs/octra_pre_client.git
cd octra_pre_client

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

cat > wallet.json <<WALLET
{
  "priv": "$priv",
  "addr": "$addr",
  "rpc": "$rpc"
}
WALLET

python3 cli.py
EOS

  chmod +x octra_terminal.sh
  echo "✅ Terminal CLI ready. Run: ./octra_terminal.sh"
  exit 0

elif [[ "$mode" == "2" ]]; then

 echo "🛡️ Configuring UFW firewall..."
 sudo ufw allow 22/tcp
 sudo ufw allow 80/tcp
 sudo ufw allow 443/tcp
 sudo ufw allow 4000/tcp
 sudo ufw allow 5000/tcp

 sudo ufw --force enable
  echo "🌐 Setting up Web UI (Backend + Frontend using screen)..."
  
  rm -rf octra-wallet
  git clone https://github.com/CodeDialect/octra-wallet.git

  cd octra-wallet/octra-app

  echo "🔗 Copying wallet config to .env"
  cp ../../.octra_env .env

  echo "🐍 Setting up Python backend"
  cd server
  python3 -m venv venv
  source venv/bin/activate
  pip install -r requirements.txt || pip install aiohttp pynacl python-dotenv
  cd ..

  echo "📦 Installing backend deps"
  cd server && npm install && cd ..

  echo "💻 Installing frontend deps (port 5000)"
  cd frontend
  npm install
  echo "PORT=5000" > .env
  cd ..

  echo "🪟 Starting backend in screen session 'octra-backend'"
  screen -dmS octra-backend bash -c "cd $(pwd)/server && npm start"

  echo "🪟 Starting frontend in screen session 'octra-frontend'"
  screen -dmS octra-frontend bash -c "cd $(pwd)/frontend && npm start"

  echo ""
  echo "✅ Backend running:  http://$(curl -s https://api.ipify.org):4000"
  echo "✅ Frontend running: http://$(curl -s https://api.ipify.org):5000"
  echo "🖥️ Use: screen -r octra-backend or screen -r octra-frontend"
else
  echo "❌ Invalid mode. Please run the script again and choose 1 or 2."
  exit 1
fi
