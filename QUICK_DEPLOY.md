# Quick Deploy Commands (Copy-Paste)

## In GitHub Codespaces Terminal:

```bash
# 1. Install DFX
sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"
export PATH="$HOME/.local/share/dfx/bin:$PATH"

# 2. Create Identity
dfx identity new mainnet-deployer
dfx identity use mainnet-deployer

# 3. Get Account ID (send ICP here)
dfx ledger account-id

# 4. After funding, create wallet
dfx ledger --network ic create-canister $(dfx identity get-principal) --amount 1.5

# 5. Deploy wallet
dfx identity --network ic deploy-wallet $(dfx ledger show-subnet-types | head -1)

# 6. Run deployment script
chmod +x scripts/deploy_mainnet.sh
./scripts/deploy_mainnet.sh

# 7. Build frontend
cd frontend
npm install
npm run build
```

## Update Frontend Files:

**frontend/src/services/icp.ts:**
```typescript
export const REGISTRY_CANISTER_ID = "PASTE_YOUR_CANISTER_ID_HERE";
const host = "https://ic0.app";
```

**frontend/src/contexts/AuthContext.tsx:**
```typescript
identityProvider: "https://identity.ic0.app"
```

## Commit & Deploy:

```bash
git add .
git commit -m "Mainnet deployment"
git push origin main
```

Then drag `frontend/dist` to https://app.netlify.com/drop
