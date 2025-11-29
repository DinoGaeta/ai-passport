# Security & Scaling Strategy

## 🛡 Threat Model

### 1. Unauthorized Access
- **Risk:** Malicious actor tries to read private memories or modify profile.
- **Mitigation (Current):** `isOwner` check on all write methods. Private memories are filtered out in `get_manifest`.
- **Mitigation (Future):** Access Control List (ACL) to allow specific Principals (apps) to read specific data.

### 2. DoS via Cycles Draining
- **Risk:** Attacker spams `get_manifest` to drain the canister's cycles.
- **Mitigation:**
  - Implement rate limiting (e.g., max 10 calls/minute per IP/Principal).
  - Use `inspect_message` to reject invalid calls before they consume cycles.
  - **Auto-Top-Up:** Configure a "Cycles Wallet" service to monitor and refill canisters.

### 3. Frontend Hijacking
- **Risk:** DNS hijacking of the frontend domain.
- **Mitigation:** Use ICP's **Asset Canister** for frontend hosting (fully on-chain), ensuring the code served is verified by the subnet.

## 🔐 Access Control (Design for v1.1)

We will introduce a `permissions` map:

```motoko
type Permission = { #ReadProfile; #ReadMemories; #WriteMemory };
private let permissions = HashMap.HashMap<Principal, [Permission]>(...);

public shared(msg) func request_access(perms : [Permission]) {
  // Stores a pending request, frontend prompts user to approve
};

public shared(msg) func grant_access(app : Principal, perms : [Permission]) {
  if (not isOwner(msg.caller)) return;
  permissions.put(app, perms);
};
```

## 🔑 LLM API Key Management

**NEVER store OpenAI/Anthropic API keys in the canister state in plain text.** The state is replicated across nodes and could theoretically be inspected by node providers (though difficult).

**Strategy A (Client-Side - MVP):**
- User enters API Key in the Frontend (stored in browser `sessionStorage`).
- Frontend sends Key + Context to the LLM directly.
- **Pros:** Zero risk for the canister. **Cons:** UX friction.

**Strategy B (Threshold ECDSA - Advanced):**
- Canister holds an encrypted key.
- Decryption happens only within the secure enclave during execution (using upcoming SEV-SNP features or Threshold Key Derivation).
- Canister makes HTTPS outcall to LLM.

## 📈 Scaling

### Registry Bottleneck
- **Issue:** A single Registry actor can handle ~1000 updates/sec, but storage is limited (4GB heap, more stable).
- **Solution:** **Sharding**.
  - `Registry_A` handles users starting with 0-7.
  - `Registry_B` handles users starting with 8-F.
  - Frontend hashes the user Principal to decide which Registry to call.

### Backup & Restore
- **Export:** `get_full_state()` already returns the full JSON-compatible structure.
- **Import:** Create a `restore_state(dump : FullState)` method (Owner only) to repopulate a new canister if the old one is lost/deleted.
