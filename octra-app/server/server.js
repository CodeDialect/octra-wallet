const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');
// Load .env from project root
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });
const app = express();
app.use(cors());
app.use(bodyParser.json());
// === Load Wallet ===
const wallet = (() => {
  if (fs.existsSync('./wallet.json')) {
    const data = JSON.parse(fs.readFileSync('./wallet.json', 'utf-8'));
    return {
      priv: data.priv,
      addr: data.addr,
      rpc: data.rpc || 'https://octra.network',
    };
  }
  return {
    priv: process.env.PRIVATE_KEY,
    addr: process.env.OCTRA_ADDRESS,
    rpc: process.env.RPC || 'https://octra.network',
  };
})();
if (!wallet.priv || !wallet.addr) {
  console.error('❌  Missing wallet credentials in .env or wallet.json');
  process.exit(1);
}
// Save wallet to pass to Python
fs.writeFileSync(path.join(__dirname, 'wallet.json'), JSON.stringify(wallet, null, 2));
// === Transaction Endpoint ===
app.post('/send-tx', (req, res) => {
  const { to, amount, message } = req.body;
  if (!to || !amount) {
    return res.status(400).json({ success: false, error: 'Missing "to" or "amount"' });
  }
  const cmd = `python3 send_tx.py '${to}' ${amount} "${message || ''}"`;
  exec(cmd, (err, stdout, stderr) => {
    if (err) {
      return res.status(500).json({ success: false, error: stderr || err.message });
    }
    try {
      const result = JSON.parse(stdout);
      res.json(result);
    } catch (e) {
      res.status(500).json({ success: false, error: 'Invalid response from Python script' });
    }
  });
});
// === Serve React Frontend (production only) ===
const frontendPath = path.join(__dirname, 'frontend', 'build');
if (fs.existsSync(frontendPath)) {
  app.use(express.static(frontendPath));
  app.get('*', (_, res) => {
    res.sendFile(path.join(frontendPath, 'index.html'));
  });
}
const PORT = process.env.PORT || 4000;
app.listen(PORT, () => {
  console.log(`✅  Backend running at http://localhost:${PORT}`);
});
