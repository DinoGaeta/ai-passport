# 🐙 GitHub Setup Guide

Use this content to populate your GitHub repository features.

## 📦 Release v0.1.0

**Tag:** `v0.1.0`
**Title:** Initial MVP Launch 🚀
**Description:**
The first public release of AI Passport.
- **Core**: Registry Canister & Passport Logic (Motoko).
- **UI**: React Dashboard with Internet Identity Auth.
- **Features**: Mint passport, Edit Profile, Add/Delete Memories.
- **Status**: Local Development Ready.

---

## 📋 Project Board: "Roadmap Q1"

**Columns:**
1.  **To Do**
2.  **In Progress**
3.  **Done**

---

## 🐛 Initial Issues (Copy & Paste)

### Issue 1: Deploy to Mainnet
**Title:** [Ops] Deploy Canisters to ICP Mainnet
**Labels:** `ops`, `high-priority`
**Body:**
Currently running on local replica. Need to:
1. Convert ICP to Cycles.
2. Deploy `registry` to mainnet.
3. Update frontend `icp.ts` with production Canister ID.

### Issue 2: Mobile Responsiveness
**Title:** [UI] Improve Mobile Layout for Dashboard
**Labels:** `ui`, `enhancement`
**Body:**
The dashboard tables break on small screens. Need to implement a card-based view for mobile devices in `MemoriesPage.tsx`.

### Issue 3: Memory Encryption
**Title:** [Security] Encrypt Private Memories
**Labels:** `security`, `feature`
**Body:**
Private memories are currently stored as plain text in the canister. Implement client-side encryption (AES) before sending to backend.

### Issue 4: Export Data
**Title:** [Feature] Export Passport Data to JSON
**Labels:** `feature`, `good-first-issue`
**Body:**
Add a button in the Settings page to download full passport state (Profile + Memories) as a `.json` file.

### Issue 5: Dark Mode Toggle
**Title:** [UI] Add Light/Dark Mode Toggle
**Labels:** `ui`, `good-first-issue`
**Body:**
Currently defaults to Dark Mode. Add a toggle in the navbar to switch themes using Tailwind classes.
