# 🚀 AI Passport - Mainnet Deployment Guide

This guide walks you through deploying AI Passport to the Internet Computer Mainnet using **GitHub Codespaces**.

---

## 📋 Prerequisites

1. **GitHub Account** with access to the `ai-passport` repository
2. **ICP Tokens** (~2-5 ICP for initial deployment)
3. **Exchange Account** (Coinbase, Binance, etc.) to send ICP

---

## 🌐 Step 1: Open GitHub Codespaces

1. Go to https://github.com/DinoGaeta/ai-passport
2. Click the green **Code** button
3. Select **Codespaces** tab
4. Click **Create codespace on main**
5. Wait for the environment to load (~2 minutes)

---

## 🔧 Step 2: Install DFX SDK

In the Codespace terminal, run:

```bash
sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"
export PATH="$HOME/.local/share/dfx/bin:$PATH"
dfx --version
```

Expected output: `dfx 0.x.x`

---

## 🔑 Step 3: Create Mainnet Identity

```bash
dfx identity new mainnet-deployer
dfx identity use mainnet-deployer
dfx identity get-principal
```

**Save the Principal ID** - you'll need it later.

---

## 💰 Step 4: Fund Your Account

Get your account ID:

```bash
dfx ledger account-id
```

**Copy this address** and send **2-5 ICP** from your exchange.

⏳ Wait 5-10 minutes for confirmation, then verify:

```bash
dfx ledger --network ic balance
```

---

## 🔄 Step 5: Convert ICP to Cycles

Create a cycles wallet:

```bash
dfx ledger --network ic create-canister $(dfx identity get-principal) --amount 1.5
dfx identity --network ic deploy-wallet $(dfx ledger show-subnet-types | head -1)
```

Check cycles balance:

```bash
dfx wallet --network ic balance
```

You should see `~1.5 TC` (trillion cycles).

---

## 🚀 Step 6: Deploy to Mainnet

Make the script executable:

```bash
chmod +x scripts/deploy_mainnet.sh
```

Run the deployment:

```bash
./scripts/deploy_mainnet.sh
```

The script will:
1. Build the canisters
2. Deploy `registry` to mainnet
3. Output the **Canister IDs**

**Save the Registry Canister ID** - example: `rrkah-fqaaa-aaaaa-aaaaq-cai`

---

## 🎨 Step 7: Update Frontend Configuration

### 7.1 Update `frontend/src/services/icp.ts`

Replace:
```typescript
export const REGISTRY_CANISTER_ID = "uzt4z-lp777-77774-qaabq-cai"; // Local
const host = "http://127.0.0.1:4943"; // Local
```

With:
```typescript
export const REGISTRY_CANISTER_ID = "YOUR_MAINNET_REGISTRY_ID"; // From step 6
const host = "https://ic0.app"; // Mainnet
```

### 7.2 Update `frontend/src/contexts/AuthContext.tsx`

Replace:
```typescript
identityProvider: "http://uxrrr-q7777-77774-qaaaq-cai.localhost:4943"
```

With:
```typescript
identityProvider: "https://identity.ic0.app"
```

### 7.3 Commit Changes

```bash
git add frontend/src/services/icp.ts frontend/src/contexts/AuthContext.tsx
git commit -m "Configure frontend for ICP Mainnet"
git push origin main
```

---

## 🏗 Step 8: Build Frontend

```bash
cd frontend
npm install
npm run build
```

The production build will be in `frontend/dist/`.

---

## 🌍 Step 9: Deploy Frontend to Netlify

### Option A: Drag & Drop (Easiest)

1. Download the `dist` folder to your local machine:
   - In Codespaces: Right-click `frontend/dist` → Download
2. Go to https://app.netlify.com/drop
3. Drag the `dist` folder into the upload area
4. Wait for deployment (~30 seconds)
5. **Copy the live URL** (e.g., `https://ai-passport-xyz.netlify.app`)

### Option B: Netlify CLI

```bash
npm install -g netlify-cli
netlify login
netlify deploy --prod --dir=frontend/dist
```

---

## ✅ Step 10: Verify Deployment

1. Open your Netlify URL
2. Click **Connect with Internet Identity**
3. Create an anchor on https://identity.ic0.app
4. Mint your AI Passport
5. Test profile editing and memory management

---

## 📝 Final Checklist

- [ ] Registry canister deployed to mainnet
- [ ] Frontend configured with mainnet IDs
- [ ] Frontend built successfully
- [ ] Frontend deployed to Netlify
- [ ] Internet Identity login works
- [ ] Passport minting works
- [ ] Data persists after refresh

---

## 🐛 Troubleshooting

### "Insufficient cycles"
Run: `dfx ledger --network ic top-up --amount 0.5 $(dfx identity --network ic get-wallet)`

### "Canister not found"
Double-check the Registry ID in `icp.ts` matches the deployed canister.

### "Invalid signature"
Clear browser cache and cookies, then try again.

---

## 🎉 Success!

Your AI Passport is now live on ICP Mainnet!

**Share your deployment:**
- Tweet: "Just deployed my AI Passport to @dfinity Mainnet! 🚀 #ICP #DeAI"
- Update README with live URL
- Create a GitHub Release v1.0.0
