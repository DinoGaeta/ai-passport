# AI Passport — Q1 2025 Technical Execution Plan (Part B)

**Version:** 1.1  
**Date:** January 1, 2025

**← Back to [Part A](./Q1_EXECUTION_PLAN_PARTA.md)**

---

## 6. Implementation Timeline (10 Weeks)

| Week | Item | Owner | Output |
|------|------|-------|--------|
| **1-2** | Manifest versioning + push update API | Jarvis → AG review | New `update_manifest` API in `registry.mo` |
| **3-4** | vetKD integration (base) | Jarvis | `deriveKey()` + memory encryption |
| **5** | AES-GCM fallback + testing | Jarvis | Fallback working, 95% vetKD / 5% AES split |
| **6-7** | REST API `http_request` | Jarvis + AG review | `GET /api/v1/manifest/:principal` live |
| **8** | Load/latency testing | Jarvis | 10K manifest reads, latency < 100ms (P95) |
| **9-10** | OpenAI embeddings + search | Jarvis | Semantic search MVP working |

### Week-by-Week Breakdown

#### Week 1-2: Manifest Versioning + Push API
**Tasks:**
1. Update `types.mo` to include `Manifest` type with `version` and `schema_version`.
2. Implement `update_manifest` in `registry.mo`.
3. Add conflict resolution (reject stale versions).
4. Write unit tests (50 concurrent updates).
5. **PR Review:** AntiGravity reviews architecture.

**Deliverable:** `registry.mo` with working `update_manifest`.

---

#### Week 3-4: vetKD Integration
**Tasks:**
1. Research vetKD API (DFINITY docs).
2. **Local Dev Mode:** Use mock/fallback if `vetkd_system_api` is unavailable locally.
3. Implement `deriveKey(principal, context)` in frontend.
4. Encrypt memory content before sending to canister.
5. Update `add_memory` to accept encrypted content.
6. Test with 100 users (log success rate).

**Deliverable:** Private memories encrypted with vetKD (or mock in dev).

---

#### Week 5: AES-GCM Fallback
**Tasks:**
1. Implement `getOrCreateLocalKey()` (localStorage).
2. Add try/catch around vetKD call.
3. Log which method is used (telemetry).
4. Test fallback scenario (disable vetKD, verify AES works).

**Deliverable:** Fallback working, 95/5 split confirmed.

---

#### Week 6-7: REST API
**Tasks:**
1. Implement `http_request` in `registry.mo`.
2. Add JSON encoding for `Manifest`.
3. Test with `curl`:
   ```bash
   curl https://uxrrr-q7777-77774-qaaaq-cai.ic0.app/api/v1/manifest/aaaaa-aa
   ```
4. Implement basic rate limiting (IP-based).
5. **PR Review:** AntiGravity reviews HTTP handling.

**Deliverable:** REST API live on boundary node.

---

#### Week 8: Load Testing
**Tasks:**
1. Generate 10K test manifests.
2. Run load test (100 concurrent requests).
3. Measure latency (P50, P95, P99).
4. Optimize if P95 > 100ms (e.g., caching).

**Deliverable:** Performance report, API meets SLA.

---

#### Week 9-10: Semantic Embeddings
**Tasks:**
1. Integrate OpenAI SDK in frontend.
2. Generate embedding on memory creation.
3. Update `add_memory` to accept `embedding: ?[Float]`.
4. Implement cosine similarity search.
5. Add "Search by meaning" UI.
6. Test: Query "AI ethics" finds relevant memories.

**Deliverable:** Semantic search working, latency < 500ms.

---

## 7. Deliverables & Acceptance Criteria

### 7.1 Push Model + Versioning

**Deliverables:**
- `Manifest.version : Nat` (incremental).
- `Manifest.schema_version : Nat` (currently 1).
- `update_manifest` rejects stale versions.

**Acceptance Criteria:**
- ✅ Test with ≥50 simultaneous updates → no crashes, consistent state.
- ✅ Version conflict returns `#err(#Conflict)`.
- ✅ Manifest persists correctly in stable storage.

---

### 7.2 vetKD + AES Fallback

**Deliverables:**
- Zero plaintext for private memories in canister.
- Automatic fallback to AES-GCM if vetKD down.
- Private memories readable by same user on same device.

**Acceptance Criteria:**
- ✅ ~95% users use vetKD (log stats).
- ✅ ~5% fallback to AES when vetKD unavailable.
- ✅ Decrypt works cross-device (vetKD) or same-device (AES).
- ✅ No plaintext in `dfx canister call registry get_full_state` output.

---

### 7.3 REST API

**Deliverables:**
- `GET /api/v1/manifest/:principal` returns valid JSON.
- 404 for unknown principal.
- Rate limiting active (100 req/day for free tier).

**Acceptance Criteria:**
- ✅ Valid JSON schema (matches `Manifest` type).
- ✅ Latency < 100ms (P95) via boundary node.
- ✅ Rate limit enforced (429 after 100 requests).
- ✅ CORS headers allow cross-origin requests.

---

### 7.4 Semantic Embeddings

**Deliverables:**
- `embedding` field populated for new memories.
- Search function returns ranked results.

**Acceptance Criteria:**
- ✅ Query "AI ethics" finds memories about "machine learning morality" (semantic match).
- ✅ Latency < 500ms (including OpenAI API call).
- ✅ Cosine similarity threshold > 0.75 for top results.
- ✅ UI shows "Search by meaning" input field.

---

## 8. Final Design Decisions (AntiGravity)

Summary of architectural decisions made by AntiGravity and integrated into this plan:

| Topic | Decision | Rationale |
|-------|----------|-----------|
| **vetKD Availability** | vetKD primary + AES-GCM fallback | vetKD is beta but stable; fallback ensures zero downtime |
| **Manifest Versioning** | `version: Nat` incremental + `schema_version` | Simple conflict resolution, future-proof for breaking changes |
| **Embedding Storage** | Registry (Q1) → Dedicated canister (Q2) | 1K users × 100 memories = 76MB (acceptable); migrate at 10K users |
| **REST Gateway** | Direct boundary node (`http_request`) | Zero ops, decentralized, < 100ms latency |

**These decisions are binding for Q1.** Any changes require v2 of this Execution Plan.

---

## 9. Risk Management

### Technical Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| vetKD instability | 30% | High | AES-GCM fallback |
| OpenAI rate limit | 20% | Medium | Cache embeddings, batch requests |
| Boundary node slow | 10% | Low | Cloudflare fallback (Q2) |
| Embedding storage overflow | 5% | Low | Monitor usage, migrate to dedicated canister in Q2 |

### Operational Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Jarvis unavailable | 10% | High | AntiGravity can take over (cross-trained) |
| Scope creep | 40% | Medium | Strict adherence to mandatory deliverables only |
| Delayed timeline | 30% | Medium | Weekly check-ins, adjust scope if needed |

---

## 10. Success Metrics

### Q1 Exit Criteria

- ✅ All 4 mandatory deliverables shipped.
- ✅ Zero critical bugs in production.
- ✅ API latency < 100ms (P95).
- ✅ 95% vetKD adoption rate.
- ✅ 100 beta users testing semantic search.

### KPIs to Track

| Metric | Target | Measurement |
|--------|--------|-------------|
| **Deployment Success** | 100% | No rollbacks |
| **API Uptime** | 99.9% | Boundary node monitoring |
| **Encryption Adoption** | 95% | vetKD vs AES logs |
| **Search Accuracy** | 80% | User feedback (relevant results) |

---

## 11. Next Steps (Post-Q1)

### Immediate (Week 11)
1. **Retrospective:** Jarvis + AntiGravity + Dion review Q1.
2. **Bug Triage:** Prioritize any issues found during beta.
3. **Q2 Planning:** Kickoff canister-per-user migration.

### Q2 Preview
- Migrate to canister-per-user architecture.
- Internet Identity integration.
- Billing system (Stripe + ICP Ledger).
- Marketplace MVP.

---

## 12. Collaboration Protocol

### Code Review
- **All PRs:** Jarvis implements → AntiGravity reviews.
- **Critical Changes:** Both review + Dion approves.
- **Turnaround:** < 24 hours for reviews.

### Communication
- **Daily:** Async updates in Discord/Slack.
- **Weekly:** 30-min sync call (Jarvis + AntiGravity + Dion).
- **Blockers:** Immediate escalation (tag all).

### Documentation
- **Code Comments:** Mandatory for complex logic.
- **Architecture Decisions:** Update this doc (version bump).
- **Runbooks:** Create for deployment, rollback, incident response.

---

## Appendix A: Glossary

| Term | Definition |
|------|------------|
| **Boundary Node** | IC gateway that serves HTTP requests to canisters |
| **Cosine Similarity** | Measure of similarity between two vectors (used for semantic search) |
| **Stable Storage** | Persistent memory in IC canisters (survives upgrades) |
| **Inter-Canister Call** | Asynchronous call between two canisters on IC |
| **HNSW** | Hierarchical Navigable Small World (graph-based vector search algorithm) |

---

## Appendix B: References

- [DFINITY vetKD Documentation](https://internetcomputer.org/docs/current/developer-docs/integrations/vetkd/)
- [IC HTTP Gateway](https://internetcomputer.org/docs/current/developer-docs/integrations/http_requests/)
- [OpenAI Embeddings API](https://platform.openai.com/docs/guides/embeddings)
- [Motoko Base Library](https://internetcomputer.org/docs/current/motoko/main/base/)

---

**End of Q1 Execution Plan v1.1**

**Last Updated:** January 1, 2025  
**Next Review:** End of Week 5 (Mid-Q1 Checkpoint)

---

**For questions or updates:**
- **Jarvis**: Implementation lead
- **AntiGravity**: Architecture review
- **Dion**: Product decisions

**Repository:** `~/ai_passport/docs/`
