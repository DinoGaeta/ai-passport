#!/bin/bash
# AI Passport - GitHub Milestones & Issues Setup (API version)
# Compatible with older gh CLI versions

set -e

echo "🚀 AI Passport Q1 2025 - GitHub Setup"
echo "======================================"
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) not found!"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "🔐 Not authenticated. Running 'gh auth login'..."
    gh auth login
fi

echo "✅ GitHub CLI ready"
echo ""

REPO="DinoGaeta/ai-passport"

echo "📌 Creating Milestones via API..."

# Milestone 1
gh api repos/$REPO/milestones -f title="Week 1-2: Manifest Versioning + Push Model" -f due_on="2025-01-14T23:59:59Z" -f description="Implement Manifest type with incremental versioning. See docs/Q1_EXECUTION_PLAN_PARTA.md"

# Milestone 2
gh api repos/$REPO/milestones -f title="Week 3: vetKD Key Derivation (Base)" -f due_on="2025-01-21T23:59:59Z" -f description="Integrate vetKD to derive encryption keys. See docs/Q1_EXECUTION_PLAN_PARTA.md Section 5.2"

# Milestone 3
gh api repos/$REPO/milestones -f title="Week 4: Private Memory Encryption Pipeline" -f due_on="2025-01-28T23:59:59Z" -f description="Integrate client-side encryption for private memories. See docs/Q1_EXECUTION_PLAN_PARTA.md Section 5.2.2"

# Milestone 4
gh api repos/$REPO/milestones -f title="Week 5: AES-GCM Fallback + Reliability Tests" -f due_on="2025-02-04T23:59:59Z" -f description="Implement AES-GCM fallback. See docs/Q1_EXECUTION_PLAN_PARTB.md Section 7.2"

# Milestone 5
gh api repos/$REPO/milestones -f title="Week 6: REST Gateway (http_request Base)" -f due_on="2025-02-11T23:59:59Z" -f description="Implement http_request in registry. See docs/Q1_EXECUTION_PLAN_PARTA.md Section 5.3"

# Milestone 6
gh api repos/$REPO/milestones -f title="Week 7: REST Gateway (JSON + Rate Limiting)" -f due_on="2025-02-18T23:59:59Z" -f description="Refine JSON serialization and rate limiting. See docs/Q1_EXECUTION_PLAN_PARTA.md Section 5.3.3"

# Milestone 7
gh api repos/$REPO/milestones -f title="Week 8: Load Testing & Optimization" -f due_on="2025-02-25T23:59:59Z" -f description="Run load tests. See docs/Q1_EXECUTION_PLAN_PARTB.md Section 7.3"

# Milestone 8
gh api repos/$REPO/milestones -f title="Week 9: OpenAI Embeddings Integration" -f due_on="2025-03-04T23:59:59Z" -f description="Integrate OpenAI Embeddings. See docs/Q1_EXECUTION_PLAN_PARTA.md Section 5.4"

# Milestone 9
gh api repos/$REPO/milestones -f title="Week 10: Semantic Search MVP + UI" -f due_on="2025-03-11T23:59:59Z" -f description="Implement semantic search. See docs/Q1_EXECUTION_PLAN_PARTA.md Section 5.4.3"

# Milestone 10
gh api repos/$REPO/milestones -f title="Q1 Wrap-up: Docs, Cleanup, Retro" -f due_on="2025-03-18T23:59:59Z" -f description="Code cleanup and Q1 retrospective. See docs/Q1_EXECUTION_PLAN_PARTB.md Section 11"

echo "✅ Created 10 milestones"
echo ""

echo "📝 Creating Issues for Week 1-2..."

# Get milestone number for "Week 1-2"
MILESTONE_NUM=$(gh api repos/$REPO/milestones | jq '.[] | select(.title=="Week 1-2: Manifest Versioning + Push Model") | .number')

# Issue 1
gh issue create \
  --repo $REPO \
  --title "Define Manifest type and versioning in types.mo" \
  --body "Update src/types.mo to introduce Manifest type.

Tasks:
- [ ] Add Manifest type to types.mo
- [ ] Export Manifest type
- [ ] Update registry to use HashMap<Principal, Manifest>

Docs: docs/Q1_EXECUTION_PLAN_PARTA.md Section 5.1.1" \
  --milestone $MILESTONE_NUM \
  --label "Q1,backend,high-priority"

# Issue 2
gh issue create \
  --repo $REPO \
  --title "Implement update_manifest with version control" \
  --body "Implement update_manifest(m: Manifest) in src/registry/main.mo.

Tasks:
- [ ] Implement update_manifest function
- [ ] Add conflict resolution
- [ ] Handle first-time manifest creation

Docs: docs/Q1_EXECUTION_PLAN_PARTA.md Section 5.1.2" \
  --milestone $MILESTONE_NUM \
  --label "Q1,backend,high-priority"

# Issue 3
gh issue create \
  --repo $REPO \
  --title "Write concurrency tests for update_manifest" \
  --body "Write tests to validate update_manifest behavior under concurrent load.

Test Scenarios:
1. 50 simultaneous updates from different principals
2. 10 updates to same principal with increasing versions
3. Stale version submission → rejected
4. Race condition handling

Docs: docs/Q1_EXECUTION_PLAN_PARTB.md Section 7.1" \
  --milestone $MILESTONE_NUM \
  --label "Q1,backend,testing,high-priority"

echo "✅ Created 3 issues for Week 1-2"
echo ""

echo "🎉 Setup complete!"
echo ""
echo "View milestones: https://github.com/$REPO/milestones"
echo "View issues: https://github.com/$REPO/issues"
