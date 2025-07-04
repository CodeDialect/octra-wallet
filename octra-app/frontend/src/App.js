import { useState } from 'react';

function App() {
  const [form, setForm] = useState({ to: '', amount: '1', message: '' });
  const [response, setResponse] = useState('');
  const backendUrl = `${window.location.hostname}:4000`;
  const sendTx = async (e) => {
    e.preventDefault();
    setResponse('⏳ Sending transaction...');

    try {
      const res = await fetch("http://${backendUrl}/send-tx", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(form),
      });
      const data = await res.json();
      setResponse(JSON.stringify(data, null, 2));
    } catch (err) {
      setResponse("❌ " + err.message);
    }
  };

  return (
    <div style={{ padding: "2rem", fontFamily: "Arial", maxWidth: 600, margin: "auto" }}>
      <h2>Octra Wallet TX</h2>
      <form onSubmit={sendTx} style={{ display: "flex", flexDirection: "column", gap: "10px" }}>
        <input placeholder="Recipient Address" value={form.to} onChange={(e) => setForm({ ...form, to: e.target.value })} required />
        <input placeholder="Amount" type="number" value={form.amount} onChange={(e) => setForm({ ...form, amount: e.target.value })} required />
        <input placeholder="Message (optional)" value={form.message} onChange={(e) => setForm({ ...form, message: e.target.value })} />
        <button type="submit">Send</button>
      </form>
      <pre>{response}</pre>
    </div>
  );
}

export default App;

