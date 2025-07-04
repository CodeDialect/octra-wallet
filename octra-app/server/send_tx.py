import json, base64, hashlib, time, sys, nacl.signing, aiohttp, asyncio

μ = 1_000_000

def load_wallet(path="wallet.json"):
    with open(path, 'r') as f:
        data = json.load(f)
    priv = data['priv']
    addr = data['addr']
    rpc = data.get('rpc', 'https://octra.network')
    sk = nacl.signing.SigningKey(base64.b64decode(priv))
    pub = base64.b64encode(sk.verify_key.encode()).decode()
    return addr, sk, pub, rpc

def create_tx(addr, to, amount, nonce, pub, sk, message=None):
    tx = {
        "from": addr,
        "to_": to,
        "amount": str(int(float(amount) * μ)),
        "nonce": nonce,
        "ou": "1" if float(amount) < 1000 else "3",
        "timestamp": time.time()
    }
    if message:
        tx["message"] = message
    bl = json.dumps({k: v for k, v in tx.items() if k != "message"}, separators=(",", ":"))
    sig = base64.b64encode(sk.sign(bl.encode()).signature).decode()
    tx.update(signature=sig, public_key=pub)
    return tx

async def get_nonce(addr, rpc):
    async with aiohttp.ClientSession() as session:
        async with session.get(f"{rpc}/balance/{addr}") as resp:
            text = await resp.text()
            if resp.status == 200:
                try:
                    return int(json.loads(text).get("nonce", 0))
                except json.JSONDecodeError:
                    return int(text.strip())
            elif resp.status == 404:
                return 0
            raise Exception(f"Unexpected response from balance endpoint: {text}")

async def send_tx(tx, rpc):
    async with aiohttp.ClientSession() as session:
        async with session.post(f"{rpc}/send-tx", json=tx) as resp:
            text = await resp.text()
            try:
                return json.loads(text)
            except json.JSONDecodeError:
                return {"raw_response": text.strip(), "status": resp.status}

async def main():
    if len(sys.argv) < 3:
        print(json.dumps({"success": False, "error": "Usage: send_tx.py <to> <amount> [message]"}))
        return

    to = sys.argv[1]
    amount = sys.argv[2]
    message = sys.argv[3] if len(sys.argv) > 3 else None

    try:
        addr, sk, pub, rpc = load_wallet()
        nonce = await get_nonce(addr, rpc)
        tx = create_tx(addr, to, amount, nonce + 1, pub, sk, message)
        result = await send_tx(tx, rpc)
        print(json.dumps({"success": True, "tx_hash": result.get("tx_hash"), "result": result}))
    except Exception as e:
        print(json.dumps({"success": False, "error": str(e)}))

if __name__ == "__main__":
    asyncio.run(main())

