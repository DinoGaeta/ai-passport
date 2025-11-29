#!/bin/bash
set -e

echo "🚀 AI Passport - Mainnet Deployment Script"
echo "==========================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if dfx is installed
if ! command -v dfx &> /dev/null; then
    echo -e "${RED}❌ dfx not found. Installing...${NC}"
    sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"
    export PATH="$HOME/.local/share/dfx/bin:$PATH"
fi

echo -e "${GREEN}✓ dfx version: $(dfx --version)${NC}"

# Check identity
echo -e "${BLUE}📋 Checking identity...${NC}"
if ! dfx identity list | grep -q "mainnet-deployer"; then
    echo "Creating mainnet-deployer identity..."
    dfx identity new mainnet-deployer
fi

dfx identity use mainnet-deployer
PRINCIPAL=$(dfx identity get-principal)
echo -e "${GREEN}✓ Using identity: $PRINCIPAL${NC}"

# Get account for funding
ACCOUNT_ID=$(dfx ledger account-id)
echo -e "${BLUE}💰 Account ID for funding: $ACCOUNT_ID${NC}"
echo "Send ICP to this address from your exchange, then press Enter to continue..."
read -p ""

# Check cycles balance
echo -e "${BLUE}🔄 Checking cycles balance...${NC}"
CYCLES=$(dfx wallet --network ic balance 2>/dev/null || echo "0")
echo "Current cycles: $CYCLES"

if [[ "$CYCLES" == "0" ]] || [[ -z "$CYCLES" ]]; then
    echo "Converting ICP to Cycles..."
    dfx ledger --network ic top-up --amount 1.0 $(dfx identity --network ic get-wallet) || {
        echo "Creating wallet canister..."
        dfx ledger --network ic create-canister $(dfx identity get-principal) --amount 1.0
        dfx identity --network ic deploy-wallet $(dfx ledger account-id)
    }
fi

# Build canisters
echo -e "${BLUE}🔨 Building canisters...${NC}"
dfx build --network ic

# Deploy Registry
echo -e "${BLUE}🚀 Deploying Registry canister...${NC}"
dfx deploy registry --network ic

# Get canister IDs
REGISTRY_ID=$(dfx canister --network ic id registry)
echo -e "${GREEN}✓ Registry deployed: $REGISTRY_ID${NC}"

# Save IDs to file
cat > canister_ids_mainnet.txt <<EOF
Registry Canister ID: $REGISTRY_ID
Internet Identity: https://identity.ic0.app
Network: IC Mainnet
Deployed: $(date)
EOF

echo -e "${GREEN}✅ Deployment complete!${NC}"
echo -e "${BLUE}📄 Canister IDs saved to: canister_ids_mainnet.txt${NC}"
echo ""
echo "Next steps:"
echo "1. Update frontend/src/services/icp.ts with REGISTRY_CANISTER_ID: $REGISTRY_ID"
echo "2. Update frontend/src/contexts/AuthContext.tsx with identityProvider: https://identity.ic0.app"
echo "3. Run: cd frontend && npm run build"
echo "4. Deploy frontend/dist to Netlify"
