# AI Passport — Product Roadmap
**Version:** 1.1  
**Date:** November 30, 2025

---

## Current State (v0.2 MVP)

### Implemented Features
- ✅ User authentication (DFX local identity)
- ✅ Profile management (nickname, avatar, bio, tags)
- ✅ Memory CRUD (create, read, delete)
- ✅ Visibility controls (Public, Private, AuthorizedOnly)
- ✅ Advanced filtering (search, visibility, date sorting)
- ✅ Tag management with suggestions
- ✅ Public manifest API (`get_manifest`)
- ✅ Developer tools (Principal validation, JSON preview)
- ✅ Modern UI (skeleton loaders, toast notifications, error boundary)

### Technical Stack
- **Backend**: Motoko (Internet Computer)
- **Architecture**: Single-canister registry (scalable to 10K users)
- **Frontend**: React 18 + Vite + Tailwind CSS
- **State**: Context API + localStorage persistence
- **Deployment**: Local (DFX) — ready for IC mainnet

---

## Q1 2025: Foundation

**Goal:** Production-ready infrastructure for 10K+ users.

### Backend
- [ ] **Canister-per-User Migration**
  - Implement spawning logic in registry
  - Data migration script for existing users
  - Load testing (1K concurrent users)
  - Estimated: 3 weeks

- [ ] **Internet Identity Integration**
  - Replace DFX identity with II
  - Session management (30-day expiry)
  - Multi-device support
  - Estimated: 2 weeks

- [ ] **End-to-End Encryption (vetkd)**
  - Private memories encrypted client-side
  - Key derivation from Principal ID
  - Backward compatibility for existing data
  - Estimated: 2 weeks

### Frontend
- [ ] **Onboarding Flow**
  - Interactive tutorial (3 steps)
  - Sample memories pre-populated
  - Progress tracker
  - Estimated: 1 week

- [ ] **Export/Import**
  - JSON export (all memories)
  - CSV export (for spreadsheets)
  - Import from file
  - Estimated: 1 week

### Infrastructure
- [ ] **Mainnet Deployment**
  - Cycles management (auto-topup)
  - Monitoring (Grafana + Prometheus)
  - Backup strategy (daily snapshots)
  - Estimated: 1 week

**Total Effort:** 10 weeks (2.5 months)  
**Launch Target:** March 31, 2025

---

## Q2 2025: Monetization

**Goal:** $10K MRR from subscriptions.

### Billing
- [ ] **Stripe Integration**
  - Checkout flow (Pro/Enterprise)
  - Webhook handling (payment success/failure)
  - Subscription management dashboard
  - Estimated: 2 weeks

- [ ] **ICP Ledger Integration**
  - Accept ICP payments
  - Auto-conversion to cycles
  - Transaction history
  - Estimated: 2 weeks

### Features (Pro Tier)
- [ ] **Semantic Search**
  - Embedding generation (OpenAI API)
  - Vector similarity search
  - Hybrid search (keyword + semantic)
  - Estimated: 3 weeks

- [ ] **Analytics Dashboard**
  - Memory creation timeline
  - Tag frequency chart
  - API usage stats
  - Estimated: 2 weeks

- [ ] **Automated Backup**
  - Daily email with JSON export
  - Cloud storage integration (S3-compatible)
  - Restore from backup UI
  - Estimated: 1 week

### Marketplace MVP
- [ ] **Memory Pack Upload**
  - UI for creating packs (title, description, price)
  - Preview before purchase
  - Escrow system (7-day hold)
  - Estimated: 3 weeks

- [ ] **Discovery & Reviews**
  - Browse packs by category
  - 5-star rating system
  - Comment section
  - Estimated: 2 weeks

**Total Effort:** 15 weeks (3.75 months)  
**Launch Target:** June 30, 2025

---

## Q3 2025: Ecosystem

**Goal:** 50 dApps integrated, 5K users.

### Integrations
- [ ] **ChatGPT Plugin**
  - Custom GPT action (save conversation)
  - OAuth flow
  - Auto-tagging based on topic
  - Estimated: 2 weeks

- [ ] **Claude MCP Server**
  - Bidirectional sync (Claude ↔ AI Passport)
  - Context injection (load memories into prompt)
  - Estimated: 2 weeks

- [ ] **API v2**
  - RESTful endpoints (`/api/v2/...`)
  - Rate limiting (tier-based)
  - OpenAPI documentation
  - SDK (TypeScript, Python)
  - Estimated: 3 weeks

### Developer Tools
- [ ] **Webhook System**
  - Event types (memory.created, profile.updated)
  - Retry logic (exponential backoff)
  - Dead letter queue
  - Estimated: 2 weeks

- [ ] **Reputation Score v1**
  - Algorithm: `score = (public_memories * 0.5) + (upvotes * 2) - (downvotes * 1)`
  - API endpoint `/api/v2/reputation/:principal`
  - Leaderboard UI
  - Estimated: 2 weeks

### Community
- [ ] **Discord Bot**
  - `/passport` command (show profile)
  - Notifications for new followers
  - Estimated: 1 week

**Total Effort:** 12 weeks (3 months)  
**Launch Target:** September 30, 2025

---

## Q4 2025: Scale

**Goal:** 20K users, $50K MRR.

### Advanced Features
- [ ] **AI-to-AI Messaging**
  - Dedicated canister for messages
  - E2E encryption (vetkd)
  - Chat UI (similar to Telegram)
  - Estimated: 4 weeks

- [ ] **Collaborative Workspaces**
  - Shared memory pool (up to 5 AI)
  - Granular permissions (read/write/admin)
  - Activity log
  - Estimated: 3 weeks

- [ ] **Smart Memory Suggestions**
  - ML model suggests tags based on content
  - Auto-categorization (work, personal, learning)
  - Duplicate detection
  - Estimated: 3 weeks

### Enterprise Features
- [ ] **SSO (SAML/OAuth)**
  - Google Workspace integration
  - Azure AD support
  - Estimated: 2 weeks

- [ ] **Audit Logs**
  - Track all actions (who, what, when)
  - Exportable reports (CSV)
  - Estimated: 1 week

- [ ] **Custom Branding**
  - White-label manifest (custom domain)
  - Logo upload
  - Color scheme customization
  - Estimated: 2 weeks

### Optional (if market demands)
- [ ] **NFT Passport**
  - Mint profile as ICRC-7 NFT
  - Marketplace integration
  - Royalty system (5% on resale)
  - Estimated: 4 weeks

**Total Effort:** 15-19 weeks (4-5 months)  
**Launch Target:** December 31, 2025

---

## Feature Prioritization Framework

We use **RICE scoring** (Reach × Impact × Confidence / Effort):

| Feature | Reach | Impact | Confidence | Effort | RICE Score | Priority |
|---------|-------|--------|------------|--------|------------|----------|
| Internet Identity | 10K | 3 | 100% | 2w | 1500 | **P0** |
| Stripe Billing | 1K | 3 | 90% | 2w | 135 | **P0** |
| Semantic Search | 500 | 2 | 70% | 3w | 23 | **P1** |
| ChatGPT Plugin | 2K | 3 | 80% | 2w | 240 | **P0** |
| AI Messaging | 5K | 2 | 60% | 4w | 150 | **P1** |
| NFT Passport | 1K | 1 | 40% | 4w | 10 | **P2** |

**Legend:**
- **P0**: Must-have (blocking revenue or scale)
- **P1**: Should-have (high impact, reasonable effort)
- **P2**: Nice-to-have (low priority, evaluate later)

---

## Release Strategy

### Beta (Months 1-3)
- Invite-only (100 users)
- Weekly feedback sessions
- Rapid iteration (ship daily)

### Public Launch (Month 4)
- Product Hunt launch
- Press release
- Free tier open to all

### Continuous Deployment
- Feature flags (gradual rollout)
- A/B testing (conversion optimization)
- Hotfix SLA: < 4 hours

---

**Next:** See [ROADMAP_PART3_METRICS.md](./ROADMAP_PART3_METRICS.md) for KPIs and user journey.
