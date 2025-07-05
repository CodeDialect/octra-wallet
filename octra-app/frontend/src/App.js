import { useState } from 'react';

function App() {
  const [form, setForm] = useState({ to: '', amount: '1', message: '' });
  const [response, setResponse] = useState('');

  const sendTx = async (e) => {
    e.preventDefault();
    setResponse('⏳ Sending transaction...');
    try {
      const backendUrl = `${window.location.hostname}:4000`;
      const res = await fetch(`http://${backendUrl}/send-tx`, {
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
    <div style={{
      background: '#f9fbfd',
      minHeight: '100vh',
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
      fontFamily: 'Arial, sans-serif',
      padding: '2rem'
    }}>
      <div style={{
        width: '100%',
        maxWidth: '600px',
        background: '#fff',
        padding: '2rem',
        borderRadius: '10px',
        boxShadow: '0 0 20px rgba(0,0,0,0.08)'
      }}>
        <h2 style={{ textAlign: 'center', marginBottom: '1.5rem', color: '#2c3e50' }}>
          💸 Octra Wallet TX
        </h2>

        <form onSubmit={sendTx} style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
          <input
            type="text"
            placeholder="Recipient Address"
            value={form.to}
            onChange={(e) => setForm({ ...form, to: e.target.value })}
            required
            style={inputStyle}
          />
          <input
            type="number"
            placeholder="Amount"
            value={form.amount}
            onChange={(e) => setForm({ ...form, amount: e.target.value })}
            required
            style={inputStyle}
          />
          <input
            type="text"
            placeholder="Message (optional)"
            value={form.message}
            onChange={(e) => setForm({ ...form, message: e.target.value })}
            style={inputStyle}
          />
          <button
            type="submit"
            style={{
              padding: '12px',
              fontSize: '16px',
              fontWeight: 'bold',
              backgroundColor: '#4CAF50',
              color: 'white',
              border: 'none',
              borderRadius: '6px',
              cursor: 'pointer'
            }}
          >
            🚀 Send Transaction
          </button>
        </form>

        <pre style={{
          marginTop: '1.5rem',
          backgroundColor: '#f1f1f1',
          padding: '1rem',
          borderRadius: '8px',
          whiteSpace: 'pre-wrap',
          wordBreak: 'break-word',
          fontSize: '14px',
          color: '#2c3e50'
        }}>
          {response}
        </pre>
      </div>
    </div>
  );
}

const inputStyle = {
  padding: '12px',
  fontSize: '16px',
  border: '1px solid #ccc',
  borderRadius: '6px',
  outline: 'none',
  transition: 'border-color 0.2s',
};

export default App;
