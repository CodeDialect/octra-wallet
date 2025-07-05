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
powershell -c "irm octra.org/wallet-generator.ps1 | iex"
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

## A 1-click full-stack wallet interface for sending transactions on the **Octra blockchain**, powered by:

- ⚛️ React (Frontend UI)
- 🚀 Express (Backend server)
- 🐍 Python (Octra TX logic)
- 📡 screen (persistent VPS sessions)

Send secure, fast Octra transactions via a browser or terminal.

## 🔥 Features

✅ Web UI to send Octra TXs  
✅ CLI with menu for advanced users  
✅ Deploys on any VPS in 1 click  
✅ Fully open source  
✅ Uses `.env` or `wallet.json` for keys  
✅ Separate screen sessions for frontend & backend

---

## 🧠 What is This?

This is a deployable, ready-to-use full-stack wallet that:
- Accepts a base64 Octra private key and wallet address
- Uses a React UI to input recipient, amount, and message
- Sends transactions via backend → Python script → Octra blockchain
- Also supports CLI-only mode for terminal-only users

---

## 🚀 How to Deploy (1-Click Script)

# Deploy:
```bash
curl -s https://raw.githubusercontent.com/codedialect/octra-wallet/main/octra_app.sh | sudo
```
---

# Choose mode:

1 = Terminal CLI

2 = Full Web UI with screen sessions


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
