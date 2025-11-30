# AI Passport — Threat Model
**Version:** 1.1  
**Date:** November 30, 2025

---

## Threat Modeling Framework

We use **STRIDE** (Microsoft's threat classification):
- **S**poofing
- **T**ampering
- **R**epudiation
- **I**nformation Disclosure
- **D**enial of Service
- **E**levation of Privilege

---

## Attack Surface Analysis

### 1. Frontend (React App)

**Attack Vectors:**
- XSS (Cross-Site Scripting)
- CSRF (Cross-Site Request Forgery)
- Malicious dependencies (npm supply chain)
- Man-in-the-Middle (MITM)

**Mitigations:**
- **XSS**: React auto-escapes by default, CSP headers.
- **CSRF**: IC uses cryptographic signatures (no cookies).
- **Supply Chain**: `npm audit`, lock file, SRI hashes.
- **MITM**: HTTPS enforced by IC (TLS 1.3).

---

### 2. Backend (Canisters)

**Attack Vectors:**
- Unauthorized access (caller spoofing)
- Data tampering (modify others' memories)
- Reentrancy attacks (inter-canister calls)
- Cycles exhaustion (DoS)

**Mitigations:**
- **Caller Verification**: `shared({caller})` pattern.
- **Access Control**: Owner-only writes.
- **Reentrancy**: Motoko is single-threaded (no reentrancy).
- **Cycles**: Rate limiting, minimum balance alerts.

---

### 3. Internet Identity

**Attack Vectors:**
- Device theft (attacker gets physical access)
- Phishing (fake II login page)
- Session hijacking (stolen delegation)

**Mitigations:**
- **Device Theft**: Biometric unlock (Face ID, Touch ID).
- **Phishing**: Educate users (check URL: `identity.ic0.app`).
- **Session Hijacking**: Short-lived delegations (30 days max).

---

### 4. API (Public Manifest)

**Attack Vectors:**
- Scraping (mass data harvesting)
- DDoS (overwhelming requests)
- Enumeration (discover all users)

**Mitigations:**
- **Scraping**: Rate limiting (100 req/day for free).
- **DDoS**: IC's built-in rate limiting + Cloudflare.
- **Enumeration**: No public user list (must know Principal).

---

## Threat Scenarios

### Threat 1: Impersonation Attack

**Scenario:**
Attacker creates fake AI Passport with stolen profile data (nickname, avatar) to impersonate a legitimate user.

**Impact:** High (reputation damage, fraud).

**Likelihood:** Medium (easy to copy public data).

**Mitigation:**
1. **Verification Badges**: Blue checkmark for verified users (manual review).
2. **Unique Identifiers**: Display Principal ID alongside nickname.
3. **Reputation Score**: Hard to fake (requires history).

**Residual Risk:** Low (after mitigation).

---

### Threat 2: Data Exfiltration

**Scenario:**
Malicious canister controller exports all user data from stable storage.

**Impact:** Critical (privacy breach, GDPR violation).

**Likelihood:** Low (requires compromised controller key).

**Mitigation:**
1. **E2E Encryption (vetkd)**: Private memories encrypted client-side.
2. **Multi-Sig Control**: Require 2/3 signatures for canister upgrades.
3. **Transparency**: Publish canister controller list publicly.

**Residual Risk:** Low (after E2E encryption).

---

### Threat 3: Cycles Drain Attack

**Scenario:**
Attacker spams `add_memory` calls to exhaust canister cycles, causing service outage.

**Impact:** High (DoS, revenue loss).

**Likelihood:** Medium (easy to automate).

**Mitigation:**
1. **Rate Limiting**: 10 req/min for free tier.
2. **Cost per Call**: Charge 0.01 ICP per memory (refundable if deleted within 24h).
3. **Monitoring**: Alert if cycles drop below 1T.

**Residual Risk:** Low.

---

### Threat 4: SQL Injection (N/A for Motoko)

**Scenario:**
Attacker injects malicious code via memory content.

**Impact:** N/A (Motoko has no SQL).

**Likelihood:** N/A.

**Mitigation:** Not applicable (type-safe language).

**Residual Risk:** None.

---

### Threat 5: Replay Attack

**Scenario:**
Attacker intercepts and replays a valid `add_memory` request.

**Impact:** Low (duplicate memory created).

**Likelihood:** Low (IC uses nonces).

**Mitigation:**
- IC's ingress message expiry (5 min).
- Nonce validation (built into IC protocol).

**Residual Risk:** None.

---

### Threat 6: Insider Threat

**Scenario:**
Rogue employee (Jarvis or AntiGravity) abuses admin access to steal data or sabotage.

**Impact:** Critical.

**Likelihood:** Very Low (trusted team).

**Mitigation:**
1. **Audit Logs**: All admin actions logged immutably.
2. **Least Privilege**: Separate dev/prod environments.
3. **Background Checks**: For any future hires.

**Residual Risk:** Very Low.

---

### Threat 7: Smart Contract Bug

**Scenario:**
Bug in Motoko code allows unauthorized memory deletion or profile modification.

**Impact:** High (data loss, user trust).

**Likelihood:** Medium (code complexity).

**Mitigation:**
1. **Code Review**: All PRs reviewed by 2 engineers.
2. **Formal Verification**: Use Motoko's type system (prevents many bugs).
3. **Audit**: External security audit (Q4 2025).
4. **Bug Bounty**: Incentivize white-hat hackers.

**Residual Risk:** Low (after audit).

---

### Threat 8: Social Engineering

**Scenario:**
Attacker tricks user into revealing their II seed phrase or delegating access.

**Impact:** High (account takeover).

**Likelihood:** Medium (phishing is common).

**Mitigation:**
1. **User Education**: In-app warnings ("Never share your seed phrase").
2. **Phishing Detection**: Email filters, browser extensions.
3. **2FA (Future)**: Hardware key (YubiKey) as second factor.

**Residual Risk:** Medium (user behavior hard to control).

---

## Threat Matrix

| Threat | Impact | Likelihood | Risk Score | Mitigation Priority |
|--------|--------|------------|------------|---------------------|
| Impersonation | High | Medium | **High** | P0 |
| Data Exfiltration | Critical | Low | **High** | P0 |
| Cycles Drain | High | Medium | **High** | P0 |
| Replay Attack | Low | Low | Low | P2 |
| Insider Threat | Critical | Very Low | Medium | P1 |
| Smart Contract Bug | High | Medium | **High** | P0 |
| Social Engineering | High | Medium | **High** | P1 |

**Risk Score = Impact × Likelihood**

---

## Security Testing Plan

### Penetration Testing (Q4 2025)
- **Scope**: Frontend, backend, API.
- **Tools**: Burp Suite, OWASP ZAP.
- **Focus Areas**:
  - Authentication bypass
  - Injection attacks
  - Access control flaws

### Fuzzing (Ongoing)
- **Tool**: AFL (American Fuzzy Lop) for Motoko.
- **Target**: Input validation functions.

### Static Analysis (CI/CD)
- **Tool**: `moc --check` (Motoko compiler).
- **Checks**: Type safety, unused variables, dead code.

---

## Incident Examples (Hypothetical)

### Example 1: XSS in Memory Content

**Date**: 2025-08-15 (hypothetical)  
**Severity**: P1  
**Description**: User discovers they can inject `<script>` tags in memory content, executing arbitrary JS.

**Timeline:**
- 14:00: User reports via Discord.
- 14:15: Jarvis confirms bug (React's `dangerouslySetInnerHTML` used incorrectly).
- 14:30: Hotfix deployed (sanitize all user input).
- 15:00: Postmortem published.

**Root Cause**: Developer used `dangerouslySetInnerHTML` for markdown rendering without sanitization.

**Prevention**: Code review checklist updated to flag `dangerouslySetInnerHTML`.

---

### Example 2: Cycles Exhaustion

**Date**: 2025-10-20 (hypothetical)  
**Severity**: P0  
**Description**: Canister runs out of cycles, service down for 2 hours.

**Timeline:**
- 10:00: Monitoring alert (cycles < 100B).
- 10:05: On-call engineer (Jarvis) notified.
- 10:10: Manual topup (1T cycles).
- 12:00: Auto-topup script deployed.

**Root Cause**: Forgot to enable auto-topup after mainnet migration.

**Prevention**: Runbook updated, auto-topup tested in staging.

---

**Next:** See [ROADMAP_PART5C_RISKS.md](./ROADMAP_PART5C_RISKS.md) for comprehensive risk map and business continuity.
