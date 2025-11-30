# AI Passport — Q1 2025 Technical Execution Plan (Part A)

**Version:** 1.1  
**Date:** January 1, 2025  
**Owners:**
- **Jarvis (GPT)**: Implementation, testing, integration
- **AntiGravity (Gemini)**: Architecture, review, DX, security
- **Dion**: Product owner, roadmap authority

---

## 0. Index

1. Scope
2. Definitions
3. System Overview
4. Q1 Objectives
5. Technical Specifications

**→ Continue to [Part B](./Q1_EXECUTION_PLAN_PARTB.md) for Timeline, Deliverables, and Final Decisions**

---

## 1. Scope

This document defines what will be implemented in Q1 2025 for AI Passport:

- **Registry Push Model**: Transition from direct state storage to manifest-based updates.
- **Canister-per-User Preparation**: Architecture ready for Q2 migration.
- **vetKD + AES Fallback**: End-to-end encryption for private memories.
- **REST Public API**: Expose manifests via boundary node HTTP gateway.
- **OpenAI Embeddings**: Semantic search MVP with embeddings stored in registry.

---

## 2. Definitions

| Term | Meaning |
|------|---------|
| **Registry** | Central canister maintaining `Principal → Passport` mapping (currently also stores state directly) |
| **Passport** | Per-user canister (future architecture, not yet implemented) |
| **Push Model** | User/passport sends manifest updates to registry |
| **vetKD** | Verifiable Encryption Toolkit by DFINITY |
| **Manifest** | Public snapshot of profile + public memories |
| **Embedding** | Numerical vector for semantic search (e.g., OpenAI `text-embedding-3-small`) |

---

## 3. System Overview

### 3.1 Current State (MVP Registry-Only)

- **Single Canister**: `registry` stores all user data directly.
- **Storage**: Profile + memories in `HashMap<Principal, PassportData>`.
- **Auth**: DFX local identity (no Internet Identity yet).
- **Encryption**: None (plaintext storage).
- **API**: Candid only (no REST).
- **Frontend**: React + Vite + Tailwind connected to registry.

### 3.2 Target State (End of Q1)

**Registry:**
- Manages full user state.
- Exposes `update_manifest` API for push updates.
- Implements `http_request` for REST API (`GET /api/v1/manifest/:principal`).

**Client:**
- Encrypts private memories with **vetKD** (primary) or **AES-GCM** (fallback).
- Generates embeddings via **OpenAI API**.
- Stores encrypted content + embeddings in registry.

**Architecture:**
- Ready to migrate to canister-per-user in Q2 (no breaking changes required).

---

## 4. Q1 Objectives

### 4.1 Mandatory Deliverables

#### 1. Push Registry Model
- Add `update_manifest` API to registry.
- Support manifest versioning (`version: Nat`).
- Prepare for transition from "registry-only state" to "per-user canister" without breaking current MVP.

#### 2. Private Memory Encryption (vetKD + AES Fallback)
- Derive encryption keys from Principal ID via vetKD.
- Automatic fallback to AES-GCM (client-side, localStorage) if vetKD unavailable.
- Zero plaintext storage in canister for private memories.

#### 3. REST Public API (Boundary Node)
- Implement `http_request` in registry canister.
- Expose `GET /api/v1/manifest/:principal` returning JSON.
- Basic rate limiting (100 req/day for free tier).

#### 4. Semantic Embedding MVP
- Use OpenAI embeddings API client-side.
- Store embeddings in `MemoryEntry.embedding` field.
- Implement cosine similarity search.

### 4.2 Stretch Goals (If Time Permits)

- Schema migration script (versioning support).
- Basic telemetry (logs + metrics).
- Minimal CI setup for Motoko (format + test).

---

## 5. Technical Specifications

### 5.1 Registry Push Model

**Decision:** Push from client/passport to registry.

#### 5.1.1 Data Model: Manifest

```motoko
type Manifest = {
    version : Nat;          // Incremental counter: 1, 2, 3...
    schema_version : Nat;   // 1 = current schema; 2+ for future breaking changes
    profile : Profile;
    public_memories : [MemoryEntry];
    updated_at : Nat64;     // Timestamp (nanoseconds)
};
```

**Registry Storage:**
```motoko
stable var manifests : HashMap.HashMap<Principal, Manifest> = HashMap.init();
```

#### 5.1.2 Update API (registry.mo)

```motoko
public shared ({caller}) func update_manifest(m : Manifest) : async Result<(), Error> {
    let current = manifests.get(caller);

    switch (current) {
        case (?existing) {
            // Reject stale versions
            if (m.version <= existing.version) {
                return #err(#Conflict("Stale version"));
            };
        };
        case null {};
    };

    manifests.put(caller, m);
    #ok(())
};
```

**Notes:**
- `caller` = Principal of user (or future passport canister).
- No inter-canister calls in Q1 (registry-only).
- Conflict resolution: latest version wins.

---

### 5.2 Encryption: vetKD + AES Fallback

**Decision:** vetKD primary, AES-GCM client-side fallback.

#### 5.2.1 Client Flow

```typescript
let encryptionKey: CryptoKey | Uint8Array;

try {
    // vetKD primary path
    encryptionKey = await vetkd.deriveKey(
        principal,
        "ai-passport:v1"
    );
} catch (e) {
    console.warn("vetKD unavailable, using AES-GCM fallback");
    encryptionKey = getOrCreateLocalKey(); // localStorage
}

const encryptedContent = encryptWithKey(memoryContent, encryptionKey);
```

**`getOrCreateLocalKey()`:**
- Checks `localStorage` for existing AES-GCM key.
- If not found, generates new key and persists it.
- **Risk:** Key loss if user clears browser data (acceptable for Q1 MVP).

#### 5.2.2 Storage (Registry)

**No plaintext for private memories:**

```motoko
type MemoryEntry = {
    id : Nat;
    content : Text;             // Encrypted ciphertext (base64/hex) if encrypted=true
    encrypted : Bool;           // true if content is encrypted
    visibility : Visibility;
    embedding : ?[Float];       // See 5.4
    timestamp : Nat64;
};
```

**For private memories:**
- `content` = ciphertext (base64 encoded).
- `encrypted` = `true`.
- Decryption always client-side.

#### 5.2.3 Acceptance Criteria

- ✅ ~95% of users use vetKD (log success rate).
- ✅ ~5% fallback to AES when vetKD unavailable.
- ✅ Zero plaintext in canister for `#Private` or `#AuthorizedOnly` memories.

---

### 5.3 REST Public API (Boundary Node Direct)

**Decision:** Use `http_request` on registry, exposed via IC boundary node.

#### 5.3.1 Implementation (registry.mo)

```motoko
import Http "mo:base/Http";

public query func http_request(req : Http.Request) : async Http.Response {
    let url = req.url; // e.g., "/api/v1/manifest/aaaaa-aa"

    if (Text.startsWith(url, #text "/api/v1/manifest/")) {
        let principalText = extractPrincipalFromUrl(url);
        let principal = Principal.fromText(principalText);

        switch (manifests.get(principal)) {
            case (?m) {
                let bodyJson = encodeManifestToJson(principal, m);
                return {
                    status_code = 200;
                    headers = [("Content-Type", "application/json")];
                    body = Text.encodeUtf8(bodyJson);
                };
            };
            case null {
                return {
                    status_code = 404;
                    headers = [];
                    body = Text.encodeUtf8("Not Found");
                };
            };
        };
    };

    {
        status_code = 404;
        headers = [];
        body = Text.encodeUtf8("Not Found");
    };
};
```

#### 5.3.2 URL Format

**Example:**
```
https://uxrrr-q7777-77774-qaaaq-cai.ic0.app/api/v1/manifest/aaaaa-aa
```

**Custom Domain (Q2):**
```
https://api.aipassport.io/v1/manifest/aaaaa-aa
```
*(CNAME to canister ID)*

#### 5.3.3 Rate Limiting (Basic)

**Q1 Implementation:**
- Simple counter per IP address.
- If > 100 requests in 24 hours → return `429 Too Many Requests`.
- Store in `HashMap<Text, RateLimitEntry>` (IP → count + window start).

**Future (Q2):**
- Tier-based limits (Free: 100/day, Pro: 1000/day, Enterprise: custom).
- Redis-like distributed rate limiting.

---

### 5.4 Semantic Embedding MVP (OpenAI + Registry)

**Decision:** Store embeddings in registry for Q1, migrate to dedicated canister in Q2 if > 10K users.

#### 5.4.1 Updated Data Model

```motoko
type MemoryEntry = {
    id : Nat;
    content : Text;
    encrypted : Bool;
    visibility : Visibility;
    embedding : ?[Float];   // 768 dimensions (OpenAI text-embedding-3-small)
    timestamp : Nat64;
};
```

#### 5.4.2 Client Flow (TypeScript)

```typescript
// 1) Generate embedding via OpenAI
const embeddingRes = await openai.embeddings.create({
    model: "text-embedding-3-small",
    input: memoryContent
});

const embedding = embeddingRes.data[0].embedding; // number[]

// 2) Send to registry
await registryActor.add_memory_with_embedding({
    content: encryptedContentOrPlaintext,
    encrypted: isEncrypted,
    visibility,
    embedding
});
```

#### 5.4.3 Search Implementation (Q1)

**Simple linear search:**
1. Retrieve all user memories.
2. Calculate cosine similarity between `query_embedding` and each `memory.embedding`.
3. Sort by score (descending).
4. Return top N results.

**Complexity:** O(N) per user (acceptable for Q1, < 1000 memories/user).

**Future (Q3):** HNSW index in dedicated canister for O(log N) search.

---

**→ Continue to [Part B](./Q1_EXECUTION_PLAN_PARTB.md) for Timeline, Deliverables, and Final Decisions**
