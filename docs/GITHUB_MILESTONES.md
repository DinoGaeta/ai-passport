# GitHub Milestones & Issues - Q1 2025

**Repository:** https://github.com/DinoGaeta/ai-passport  
**Created by:** AntiGravity (Gemini)  
**Date:** November 30, 2025

---

## How to Use This File

### Option 1: GitHub CLI (Recommended)
```bash
# Create milestones
gh milestone create "Week 1-2: Manifest Versioning + Push Model" --due-date 2025-01-14 --description "..."

# Create issues
gh issue create --title "..." --body "..." --milestone "Week 1-2: Manifest Versioning + Push Model" --label "Q1,backend,high-priority"
```

### Option 2: Manual (GitHub Web UI)
1. Go to https://github.com/DinoGaeta/ai-passport/milestones
2. Click "New Milestone"
3. Copy/paste title and description from below
4. Set due date
5. Repeat for all 10 milestones

---

## Milestone 1: Week 1-2 — Manifest Versioning + Push Model

**Due Date:** January 14, 2025  
**Description:**

Implement `Manifest` type with incremental versioning (`version: Nat`, `schema_version: Nat`) in registry.

Implement `update_manifest` with version control and "latest wins" conflict resolution.

Introduce push model: future passport canisters will push updated manifests to registry.

Write concurrency tests (≥50 simultaneous updates) and conflict resolution validation.

**Deliverables:**
- ✅ `types.mo` updated with `Manifest` type
- ✅ `registry.mo` with `update_manifest` API
- ✅ Unit tests for conflict resolution
- ✅ Documentation updated

**Docs:** See `docs/Q1_EXECUTION_PLAN_PARTA.md` (Section 5.1) and `docs/Q1_EXECUTION_PLAN_PARTB.md` (Section 6, Week 1-2) for technical details.

---

## Milestone 2: Week 3 — vetKD Key Derivation (Base)

**Due Date:** January 21, 2025  
**Description:**

Integrate vetKD to derive encryption keys from Principal ID.

Expose client-side `deriveKey()` function using vetKD.

Do not yet connect full pipeline (memory → encryption). Focus on key derivation only.

**Deliverables:**
- ✅ vetKD integration in frontend
- ✅ `deriveKey(principal, context)` function working
- ✅ Test with 100 users, log success rate

**Docs:** See `docs/Q1_EXECUTION_PLAN_PARTA.md` (Section 5.2) and `docs/ROADMAP_PART5A_SECURITY.md` for encryption architecture.

---

## Milestone 3: Week 4 — Private Memory Encryption Pipeline

**Due Date:** January 28, 2025  
**Description:**

Integrate client-side encryption for private memories using vetKD-derived keys.

Define encrypted payload format and metadata in registry canister.

Update `add_memory` to accept encrypted content.

**Deliverables:**
- ✅ Encrypted memories stored in canister
- ✅ `MemoryEntry.encrypted: Bool` field
- ✅ Zero plaintext for private memories

**Docs:** See `docs/Q1_EXECUTION_PLAN_PARTA.md` (Section 5.2.2) for storage format.

---

## Milestone 4: Week 5 — AES-GCM Fallback + Reliability Tests

**Due Date:** February 4, 2025  
**Description:**

Implement AES-GCM fallback with local key (localStorage) if vetKD unavailable.

Add future migration path from AES → vetKD.

Test both paths (vetKD working / vetKD down) without data loss.

**Deliverables:**
- ✅ `getOrCreateLocalKey()` function
- ✅ Automatic fallback on vetKD failure
- ✅ 95% vetKD / 5% AES split confirmed

**Docs:** See `docs/Q1_EXECUTION_PLAN_PARTB.md` (Section 7.2) for acceptance criteria.

---

## Milestone 5: Week 6 — REST Gateway (http_request Base)

**Due Date:** February 11, 2025  
**Description:**

Implement `http_request` in registry to expose `/api/v1/manifest/:principal`.

Return valid JSON with `Content-Type: application/json`.

Handle 404 for unknown principals.

**Deliverables:**
- ✅ `http_request` function in `registry.mo`
- ✅ JSON encoding for `Manifest`
- ✅ Test with `curl`

**Docs:** See `docs/Q1_EXECUTION_PLAN_PARTA.md` (Section 5.3) and `docs/ROADMAP_PART4_ARCHITECTURE.md` for REST API design.

---

## Milestone 6: Week 7 — REST Gateway (JSON + Rate Limiting)

**Due Date:** February 18, 2025  
**Description:**

Refine JSON serialization for manifest.

Add basic rate limiting (100 requests/day/IP for free tier).

Prepare foundation for custom domain in Q2 (`api.aipassport.io`).

**Deliverables:**
- ✅ Rate limiting active (429 after 100 requests)
- ✅ CORS headers configured
- ✅ Documentation for API endpoints

**Docs:** See `docs/Q1_EXECUTION_PLAN_PARTA.md` (Section 5.3.3) for rate limit implementation.

---

## Milestone 7: Week 8 — Load Testing & Optimization

**Due Date:** February 25, 2025  
**Description:**

Run load tests on `get_manifest` via HTTP for ≥10K requests/day.

Optimize hot paths (caching, data structure layout).

Validate P95 latency < 100ms.

**Deliverables:**
- ✅ Load test results (10K requests)
- ✅ Performance report
- ✅ Optimizations implemented

**Docs:** See `docs/Q1_EXECUTION_PLAN_PARTB.md` (Section 7.3) for acceptance criteria.

---

## Milestone 8: Week 9 — OpenAI Embeddings Integration

**Due Date:** March 4, 2025  
**Description:**

Integrate OpenAI Embeddings API calls in frontend.

Extend `MemoryEntry` with optional `embedding: ?[Float]` field.

Store embeddings in registry (Q1 MVP).

**Deliverables:**
- ✅ OpenAI SDK integrated
- ✅ Embeddings generated on memory creation
- ✅ `add_memory_with_embedding` API

**Docs:** See `docs/Q1_EXECUTION_PLAN_PARTA.md` (Section 5.4) for embedding storage strategy.

---

## Milestone 9: Week 10 — Semantic Search MVP + UI

**Due Date:** March 11, 2025  
**Description:**

Implement cosine similarity search on memories.

Add "Search by meaning" field in UI.

Validate semantic queries (e.g., "AI ethics" finds "machine learning morality").

**Deliverables:**
- ✅ Cosine similarity function
- ✅ Search UI component
- ✅ Latency < 500ms (including OpenAI call)

**Docs:** See `docs/Q1_EXECUTION_PLAN_PARTA.md` (Section 5.4.3) for search algorithm.

---

## Milestone 10: Q1 Wrap-up — Docs, Cleanup, Retro

**Due Date:** March 18, 2025  
**Description:**

Code cleanup (backend + frontend) based on Q1 learnings.

Update documentation in `docs/` (ARCHITECTURE + Q1_EXECUTION_PLAN).

Write brief Q1 retrospective and prepare foundation for Q2.

**Deliverables:**
- ✅ Code refactored, tech debt addressed
- ✅ Documentation updated
- ✅ Q1 retrospective document

**Docs:** See `docs/Q1_EXECUTION_PLAN_PARTB.md` (Section 11) for next steps.

---

## Issues for Milestone 1 (Week 1-2)

### Issue #1: Define `Manifest` type and versioning in `types.mo`

**Labels:** `Q1`, `backend`, `high-priority`  
**Milestone:** Week 1-2: Manifest Versioning + Push Model  
**Assignee:** Jarvis

**Description:**

Update `src/types.mo` to introduce the `Manifest` type:

```motoko
type Manifest = {
    version : Nat;          // Incremental counter
    schema_version : Nat;   // Schema version (1 for current)
    profile : Profile;
    public_memories : [MemoryEntry];
    updated_at : Nat64;     // Timestamp in nanoseconds
};
```

**Tasks:**
- [ ] Add `Manifest` type to `types.mo`
- [ ] Export `Manifest` type
- [ ] Update registry to use `HashMap<Principal, Manifest>`
- [ ] Add migration path for existing data (if any)

**Acceptance Criteria:**
- ✅ `Manifest` type compiles without errors
- ✅ All fields properly typed
- ✅ Exported and usable in `registry.mo`

**Docs:** `docs/Q1_EXECUTION_PLAN_PARTA.md` Section 5.1.1

---

### Issue #2: Implement `update_manifest` with version control

**Labels:** `Q1`, `backend`, `high-priority`  
**Milestone:** Week 1-2: Manifest Versioning + Push Model  
**Assignee:** Jarvis

**Description:**

Implement `update_manifest(m: Manifest)` in `src/registry/main.mo`:

```motoko
public shared ({caller}) func update_manifest(m : Manifest) : async Result<(), Error> {
    let current = manifests.get(caller);

    switch (current) {
        case (?existing) {
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

**Tasks:**
- [ ] Implement `update_manifest` function
- [ ] Add conflict resolution (reject stale versions)
- [ ] Handle first-time manifest creation
- [ ] Add error handling for invalid input

**Acceptance Criteria:**
- ✅ Function rejects `m.version <= existing.version`
- ✅ Latest version always wins
- ✅ Returns `#ok(())` on success
- ✅ Returns `#err(#Conflict)` on version conflict

**Docs:** `docs/Q1_EXECUTION_PLAN_PARTA.md` Section 5.1.2

---

### Issue #3: Write concurrency tests for `update_manifest`

**Labels:** `Q1`, `backend`, `testing`, `high-priority`  
**Milestone:** Week 1-2: Manifest Versioning + Push Model  
**Assignee:** Jarvis

**Description:**

Write tests to validate `update_manifest` behavior under concurrent load.

**Test Scenarios:**
1. **50 simultaneous updates** from different principals → all succeed
2. **10 updates to same principal** with increasing versions → all succeed in order
3. **Stale version submission** → rejected with `#Conflict`
4. **Race condition** (2 updates with same version) → one wins, one rejected

**Tasks:**
- [ ] Create test file `tests/registry_concurrency.test.mo`
- [ ] Implement test scenarios 1-4
- [ ] Run tests with `moc --test`
- [ ] Document results

**Acceptance Criteria:**
- ✅ All tests pass
- ✅ No data corruption under concurrent load
- ✅ Conflict resolution works correctly

**Docs:** `docs/Q1_EXECUTION_PLAN_PARTB.md` Section 7.1

---

## GitHub CLI Commands (Quick Reference)

```bash
# Navigate to repo
cd ~/ai_passport

# Create Milestone 1
gh milestone create "Week 1-2: Manifest Versioning + Push Model" \
  --due-date 2025-01-14 \
  --description "Implement Manifest type with versioning. See docs/Q1_EXECUTION_PLAN_PARTA.md"

# Create Issue #1
gh issue create \
  --title "Define Manifest type and versioning in types.mo" \
  --body "Update src/types.mo to introduce Manifest type. See full description in GITHUB_MILESTONES.md" \
  --milestone "Week 1-2: Manifest Versioning + Push Model" \
  --label "Q1,backend,high-priority" \
  --assignee DinoGaeta

# Repeat for all milestones and issues...
```

---

## PR Template for Week 1-2

When ready to submit the first PR:

**Title:**
```
Q1 Week 1-2 — Manifest Versioning + Push Model (Registry)
```

**Description:**
```markdown
## Summary
Implements Milestone 1 deliverables:
- ✅ `Manifest` type with versioning
- ✅ `update_manifest` API with conflict resolution
- ✅ Concurrency tests (50 simultaneous updates)

## Changes
- `src/types.mo`: Added `Manifest` type
- `src/registry/main.mo`: Implemented `update_manifest`
- `tests/registry_concurrency.test.mo`: Added concurrency tests

## Testing
- [x] Unit tests pass
- [x] Concurrency tests pass (50 updates)
- [x] Manual testing with `dfx canister call`

## Docs
See `docs/Q1_EXECUTION_PLAN_PARTA.md` Section 5.1

## Review Requests
- @DinoGaeta (product review)
- @AntiGravity (architecture review)

Closes #1, #2, #3
```

---

**End of GitHub Milestones & Issues Document**

**Next Steps:**
1. Create milestones using GitHub CLI or web UI
2. Create issues for Milestone 1
3. Start implementation (Week 1-2)
4. Submit PR when ready
