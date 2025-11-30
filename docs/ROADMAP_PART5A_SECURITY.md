# AI Passport — Security Model
**Version:** 1.1  
**Date:** November 30, 2025

---

## Security Principles

### 1. Defense in Depth
Multiple layers of security controls to protect against single-point failures.

### 2. Least Privilege
Users and canisters have minimum permissions required for their function.

### 3. Zero Trust
Verify every request, even from authenticated users.

### 4. Privacy by Design
User data encrypted by default, minimal data collection.

---

## Authentication & Authorization

### Internet Identity (II)

**How it Works:**
1. User creates II anchor (one-time setup).
2. II generates cryptographic key pair.
3. Private key stored in device's secure enclave (TPM/Secure Enclave).
4. Public key registered on IC.

**Security Benefits:**
- No passwords (immune to phishing).
- No central database of credentials.
- Multi-device support via delegation.

**Implementation:**
```typescript
const authClient = await AuthClient.create();
await authClient.login({
  identityProvider: "https://identity.ic0.app",
  maxTimeToLive: BigInt(30 * 24 * 60 * 60 * 1_000_000_000), // 30 days
  onSuccess: () => {
    const identity = authClient.getIdentity();
    const principal = identity.getPrincipal();
    // User authenticated
  }
});
```

---

### Access Control (Canister-Level)

**Caller Verification:**
```motoko
public shared({caller}) func update_profile(p : Profile) : async Result<(), Error> {
    if (Principal.isAnonymous(caller)) {
        return #err(#Unauthorized);
    };
    
    let userCanister = getUserCanister(caller);
    switch (userCanister) {
        case (?canister) {
            // Only owner can update their profile
            if (canister.owner != caller) {
                return #err(#Unauthorized);
            };
            // Proceed with update
        };
        case null { #err(#NotFound) };
    };
};
```

**Role-Based Access (Future):**
```motoko
type Role = {
    #Owner;
    #Admin;
    #Viewer;
};

stable var permissions : HashMap<Principal, Role> = HashMap.init();
```

---

## Data Encryption

### Current State (v0.2)
- **In Transit**: HTTPS (IC enforces TLS 1.3).
- **At Rest**: Plaintext in stable storage.

**Risk:** Canister controller can read all data.

---

### Future State (v1.0): End-to-End Encryption

**vetkd (Vetted Key Derivation):**
- User-specific encryption keys derived from Principal ID.
- Keys never leave user's device.
- Canister stores encrypted blobs.

**Flow:**
```typescript
// Client-side
const encryptionKey = await deriveKey(principal);
const encryptedMemory = encrypt(memoryContent, encryptionKey);

// Send to canister
await passportActor.add_memory(encryptedMemory, visibility);

// Retrieve
const encrypted = await passportActor.get_memory(id);
const decrypted = decrypt(encrypted, encryptionKey);
```

**Motoko (Canister):**
```motoko
// Canister only stores ciphertext
stable var memories : [EncryptedMemory] = [];

type EncryptedMemory = {
    id : Nat;
    ciphertext : Blob;
    nonce : Blob;
    visibility : Visibility;
};
```

**Benefits:**
- Even canister controller cannot read private memories.
- GDPR-compliant (user controls decryption keys).

---

## Input Validation

### Frontend Validation
```typescript
const validateMemory = (content: string): boolean => {
    if (content.length === 0) return false;
    if (content.length > 10_000) return false; // 10KB max
    if (containsMaliciousScript(content)) return false;
    return true;
};
```

### Backend Validation
```motoko
func validateMemoryContent(content : Text) : Bool {
    let size = Text.size(content);
    size > 0 and size <= 10_000
};

public shared({caller}) func add_memory(content : Text, vis : Visibility) : async Result<Nat, Error> {
    if (not validateMemoryContent(content)) {
        return #err(#InvalidInput("Memory content invalid"));
    };
    // Proceed
};
```

---

## Rate Limiting

### API Rate Limits (by Tier)

| Tier | Requests/Minute | Requests/Day |
|------|-----------------|--------------|
| Free | 10 | 1,000 |
| Pro | 100 | 10,000 |
| Enterprise | 1,000 | 100,000 |

### Implementation (Canister)
```motoko
import Time "mo:base/Time";

stable var rateLimits : HashMap<Principal, RateLimit> = HashMap.init();

type RateLimit = {
    count : Nat;
    windowStart : Time.Time;
};

func checkRateLimit(caller : Principal, tier : Tier) : Bool {
    let now = Time.now();
    let limit = switch (tier) {
        case (#Free) 10;
        case (#Pro) 100;
        case (#Enterprise) 1000;
    };
    
    switch (rateLimits.get(caller)) {
        case (?rl) {
            let elapsed = now - rl.windowStart;
            if (elapsed > 60_000_000_000) { // 1 minute
                rateLimits.put(caller, { count = 1; windowStart = now });
                true
            } else if (rl.count < limit) {
                rateLimits.put(caller, { count = rl.count + 1; windowStart = rl.windowStart });
                true
            } else {
                false // Rate limit exceeded
            }
        };
        case null {
            rateLimits.put(caller, { count = 1; windowStart = now });
            true
        };
    };
};
```

---

## Secure Development Practices

### Code Review
- All PRs require 1 approval.
- Security-critical changes require 2 approvals.
- Automated checks (linting, type safety).

### Dependency Management
- Pin exact versions (`package-lock.json`).
- Weekly `npm audit` (auto-fix non-breaking).
- Monthly manual review of dependencies.

### Secrets Management
- No hardcoded secrets in code.
- Environment variables for API keys.
- IC Secrets (future: encrypted config in canister).

**Example:**
```bash
# .env.local (not committed)
VITE_OPENAI_API_KEY=sk-...
VITE_STRIPE_PUBLIC_KEY=pk_test_...
```

---

## Incident Response Plan

### Severity Levels

| Level | Definition | Response Time | Example |
|-------|-----------|---------------|---------|
| **P0** | Service down | < 1 hour | Canister out of cycles |
| **P1** | Data breach | < 4 hours | Private memories leaked |
| **P2** | Feature broken | < 24 hours | Search not working |
| **P3** | Minor bug | < 1 week | UI typo |

### Response Workflow
1. **Detect**: Monitoring alert or user report.
2. **Triage**: Assign severity, notify on-call engineer.
3. **Mitigate**: Stop the bleeding (e.g., disable feature).
4. **Fix**: Deploy patch.
5. **Postmortem**: Document root cause, preventive measures.

### Communication
- **P0/P1**: Status page update within 30 min.
- **P2**: Email to affected users within 24 hours.
- **P3**: Included in weekly changelog.

---

## Compliance

### GDPR (General Data Protection Regulation)

**User Rights:**
1. **Right to Access**: Export all data (JSON).
2. **Right to Erasure**: Delete account + all memories.
3. **Right to Portability**: Download data in machine-readable format.

**Implementation:**
```typescript
// Export
const exportData = async () => {
    const state = await passportActor.get_full_state();
    const json = JSON.stringify(state, null, 2);
    downloadFile('my-ai-passport.json', json);
};

// Delete
const deleteAccount = async () => {
    await passportActor.delete_all_data();
    await authClient.logout();
};
```

### CCPA (California Consumer Privacy Act)
- Same as GDPR (export, delete).
- "Do Not Sell My Data" → We don't sell data (opt-in licensing only).

### SOC 2 (Future, for Enterprise)
- Annual audit by third party.
- Controls for security, availability, confidentiality.

---

## Security Audits

### Timeline
- **Q2 2025**: Internal security review (Jarvis + AntiGravity).
- **Q4 2025**: External audit (e.g., Trail of Bits, if fundraising).
- **Ongoing**: Bug bounty program (HackerOne).

### Bug Bounty Tiers
| Severity | Payout |
|----------|--------|
| Critical (RCE, data breach) | $5,000 |
| High (auth bypass) | $1,000 |
| Medium (XSS, CSRF) | $500 |
| Low (info disclosure) | $100 |

---

## Backup & Disaster Recovery

### Backup Strategy
- **Frequency**: Daily snapshots (automated).
- **Retention**: 30 days rolling.
- **Storage**: IC stable storage + off-chain (S3-compatible).

### Recovery Scenarios

| Scenario | RTO (Recovery Time) | RPO (Data Loss) |
|----------|---------------------|-----------------|
| Canister crash | < 5 min | 0 (stable storage) |
| Accidental upgrade | < 30 min | 0 (rollback) |
| Data corruption | < 4 hours | < 24 hours (last snapshot) |
| IC network outage | N/A (wait for IC) | 0 |

### Disaster Recovery Plan
1. **Detect**: Monitoring alert.
2. **Assess**: Determine scope (single user vs all).
3. **Restore**: `dfx canister install --mode reinstall --wasm backup.wasm`.
4. **Verify**: Smoke test (login, view memories).
5. **Communicate**: Notify users of downtime.

---

**Next:** See [ROADMAP_PART5B_RISKS.md](./ROADMAP_PART5B_RISKS.md) for threat model and risk mitigation.
