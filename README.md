# 🌐 Octra Wallet Generator — Public Testnet

Welcome to the Octra Public Testnet!  
Generate your wallet in seconds and get started with our decentralized ecosystem.

---

## 📌 Supported Platforms

- ✅ VPS (Ubuntu Linux)
- ✅ Windows WSL (Ubuntu via WSL)
- ✅ Windows (PowerShell) — *manual steps required*

---

## 🚀 One-Click Install (VPS / WSL)

### Step 1: Download and Run Installer

```bash
sudo apt-get -qq update && sudo apt-get upgrade -y
sudo apt -qq install curl -y
```
```bash
curl -s https://raw.githubusercontent.com/codedialect/octra-wallet/main/octra_wallet.sh | sudo
```

- Choose:
  - `1` for VPS (Linux)
  - `2` for WSL (Ubuntu on Windows)

### What it does:

- Installs Node.js, Yarn, Git (if missing)
- Clones the wallet generator
- Starts the wallet UI on port `8888`
- (VPS only) Exposes the UI via **LocalTunnel**

---

## 🪟 Windows (PowerShell) Setup

> Manual Node.js installation required

### Step 1: Install Node.js  
Download & install Node.js v22 from:  
[https://nodejs.org/en/download/current](https://nodejs.org/en/download/current)

### Step 2: Clone Wallet Generator

```powershell
git clone https://github.com/octra-labs/wallet-gen.git
cd wallet-gen
```

### Step 3: Start the UI

```powershell
start.bat
```

### Access Wallet UI  
Open: [http://localhost:8888](http://localhost:8888)

---

## Generate Your Wallet

1. Open the Wallet Generator in your browser  
2. Click **"Generate New Wallet"**  
3. Save all keys and details safely

---

## Get Test Tokens

Claim testnet tokens using your wallet address:

— [https://faucet.octra.network/](https://faucet.octra.network/)

---

## Stay Updated

Join octra community:  
— [https://discord.gg/octra](https://discord.gg/octra)

Join us:

— [Nodehunterz](https://t.me/nodehunterz)
---

## Troubleshooting

If you face any issues:
- Ensure ports aren't blocked (especially port `8888`)
- If running on VPS, make sure `lt` tunnel is exposed
- Use a modern browser to access the wallet page

---
