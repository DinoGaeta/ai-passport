# AI Passport — Metrics & User Journey
**Version:** 1.1  
**Date:** November 30, 2025

---

## Key Performance Indicators (KPIs)

### North Star Metric
**Active AI Agents with ≥10 Memories**

This metric captures both user engagement and product value. An AI with 10+ memories is actively using the platform and deriving utility.

**Target Trajectory:**
- Month 3: 100 active agents
- Month 6: 500 active agents
- Month 12: 2,000 active agents
- Month 24: 10,000 active agents

---

## Acquisition Metrics

### Signups
- **Definition**: Users who complete registration (II authentication).
- **Target Growth**: 20% MoM.
- **Channels**:
  - Organic: 60% (Product Hunt, Reddit, Twitter)
  - Paid: 30% (Google Ads, sponsorships)
  - Referral: 10% (invite program)

### Activation Rate
- **Definition**: % of signups who create ≥1 memory within 24 hours.
- **Target**: 70% (industry benchmark: 40-50%).
- **Tactics**:
  - Onboarding tutorial with pre-filled example.
  - Email reminder at 12 hours if no action.

### Time to First Memory
- **Target**: < 2 minutes (median).
- **Measurement**: Track from signup to first `add_memory` call.

---

## Engagement Metrics

### Daily Active Users (DAU)
- **Target**: 30% of total users (Month 12).
- **Measurement**: Users who view dashboard or add/edit memory.

### Weekly Active Users (WAU)
- **Target**: 60% of total users.

### Monthly Active Users (MAU)
- **Target**: 80% of total users.

### Stickiness (DAU/MAU)
- **Target**: 40% (healthy SaaS benchmark: 20-30%).

### Memories per User (Avg)
- **Target**: 50 memories/user by Month 12.
- **Segmentation**:
  - Free: 20 memories (capped at 100).
  - Pro: 150 memories (unlimited).

### Session Duration
- **Target**: 5 minutes (median).
- **Measurement**: Time from login to last action.

---

## Retention Metrics

### Cohort Retention
Track % of users still active after N months:

| Cohort | Month 1 | Month 3 | Month 6 | Month 12 |
|--------|---------|---------|---------|----------|
| **Target** | 60% | 45% | 35% | 25% |
| **Benchmark** | 40% | 25% | 15% | 10% |

### Churn Rate (Pro)
- **Definition**: % of Pro users who cancel in a given month.
- **Target**: < 3%/month (36% annual churn).
- **Acceptable**: < 5%/month (industry avg).

### Resurrection Rate
- **Definition**: % of churned users who return within 90 days.
- **Target**: 15%.
- **Tactic**: Win-back email with 50% discount.

---

## Revenue Metrics

### Monthly Recurring Revenue (MRR)
- **Target Milestones**:
  - Month 6: $5K
  - Month 12: $15K
  - Month 18: $50K
  - Month 24: $120K

### Average Revenue Per User (ARPU)
- **Free**: $0
- **Pro**: $9.99/mo
- **Enterprise**: $99/mo
- **Blended ARPU Target**: $2.50 (Month 12, assuming 10% Pro conversion).

### Customer Lifetime Value (CLTV)
- **Pro**: $199.80 (20 months × $9.99)
- **Enterprise**: $1,188 (12 months × $99)

### CLTV:CAC Ratio
- **Target**: > 3:1 (healthy SaaS).
- **Current Projection**: 13:1 (LTV $199 / CAC $15).

### Payback Period
- **Target**: < 12 months.
- **Current Projection**: 1.5 months ($15 CAC / $9.99 MRR).

---

## Product Metrics

### Feature Adoption
Track % of users who use each feature at least once:

| Feature | Target Adoption | Measurement Window |
|---------|-----------------|-------------------|
| Profile Edit | 80% | 7 days |
| Memory Creation | 90% | 7 days |
| Tag Usage | 60% | 30 days |
| Search | 40% | 30 days |
| Manifest Query (Dev) | 10% | 90 days |

### API Usage (External)
- **Target**: 1M `get_manifest` calls/month by Month 18.
- **Indicates**: Network effect (dApps integrating).

### Marketplace GMV (Gross Merchandise Value)
- **Target**: $50K/month by Month 18.
- **Commission**: 20% → $10K MRR.

---

## User Journey Map

### Persona: "Alex the AI Enthusiast"
**Background**: Indie developer building a personal AI assistant.  
**Goal**: Give their AI persistent memory across sessions.

---

### Stage 1: Awareness
**Touchpoint**: Sees AI Passport on Product Hunt.  
**Action**: Clicks "Visit Website."  
**Emotion**: 😊 Curious  
**Metric**: Click-through rate (CTR) from PH → Landing page.

---

### Stage 2: Consideration
**Touchpoint**: Lands on homepage, watches 2-min demo video.  
**Action**: Reads "How it works" section.  
**Emotion**: 🤔 Intrigued but skeptical  
**Metric**: Time on page (target: > 1 min).

---

### Stage 3: Signup
**Touchpoint**: Clicks "Get Started Free."  
**Action**: Authenticates with Internet Identity.  
**Emotion**: 😐 Neutral (friction point)  
**Metric**: Signup completion rate (target: 70%).

**Pain Point**: "What is Internet Identity?"  
**Solution**: Tooltip + 30-sec explainer video.

---

### Stage 4: Onboarding
**Touchpoint**: Interactive tutorial (3 steps).  
**Actions**:
1. Create first memory ("Remember: My favorite color is blue").
2. Add tags ("personal", "preferences").
3. View public manifest.

**Emotion**: 😃 Delighted (aha moment)  
**Metric**: Tutorial completion rate (target: 80%).

---

### Stage 5: Activation
**Touchpoint**: Dashboard shows first memory.  
**Action**: Adds 5 more memories over 3 days.  
**Emotion**: 😍 Engaged  
**Metric**: % users with ≥5 memories in first week (target: 50%).

---

### Stage 6: Habit Formation
**Touchpoint**: Weekly email: "You have 12 memories. Add 3 more to unlock Pro trial."  
**Action**: Returns to app, adds memories.  
**Emotion**: 🎯 Motivated  
**Metric**: WAU (target: 60%).

---

### Stage 7: Monetization
**Touchpoint**: Hits 100-memory limit (Free tier).  
**Action**: Sees upgrade prompt: "Unlock unlimited memories for $9.99/mo."  
**Emotion**: 💳 Ready to pay (if value proven)  
**Metric**: Free → Pro conversion (target: 10%).

**Pain Point**: "Is it worth $10/mo?"  
**Solution**: Show ROI: "You've saved 50 hours of context re-entry."

---

### Stage 8: Retention
**Touchpoint**: Uses app 3x/week for 6 months.  
**Action**: Integrates ChatGPT plugin, shares manifest with friends.  
**Emotion**: 🤝 Loyal advocate  
**Metric**: NPS (Net Promoter Score) > 50.

---

### Stage 9: Expansion
**Touchpoint**: Builds a dApp that queries AI Passport manifests.  
**Action**: Upgrades to Enterprise for API credits.  
**Emotion**: 🚀 Power user  
**Metric**: Pro → Enterprise upgrade rate (target: 5%).

---

### Stage 10: Advocacy
**Touchpoint**: Tweets: "AI Passport changed how I build AI agents."  
**Action**: Refers 10 friends (referral program).  
**Emotion**: 🌟 Evangelist  
**Metric**: Viral coefficient (K-factor) > 0.5.

---

## Churn Analysis

### Why Users Churn (Hypotheses)

| Reason | % of Churn | Mitigation |
|--------|------------|------------|
| "Too expensive" | 30% | Annual plan (20% discount) |
| "Not using it enough" | 25% | Email re-engagement campaign |
| "Missing features" | 20% | Prioritize top requests (RICE) |
| "Found competitor" | 15% | Competitive analysis, unique features |
| "Technical issues" | 10% | Improve uptime, faster support |

### Churn Prevention Tactics
1. **Usage Alerts**: Email if no activity for 14 days.
2. **Exit Survey**: Ask why they're leaving (offer discount to stay).
3. **Pause Subscription**: Allow 3-month pause instead of cancel.

---

## Experimentation Framework

### A/B Testing Roadmap

| Test | Hypothesis | Metric | Target Lift |
|------|-----------|--------|-------------|
| Onboarding: 3 steps vs 5 steps | Shorter = higher completion | Activation rate | +10% |
| Pricing: $9.99 vs $14.99 | Higher price = lower conversion but higher LTV | CLTV | +20% |
| CTA: "Start Free" vs "Try Now" | "Try Now" = higher urgency | Signup rate | +5% |
| Email: Daily digest vs Weekly | Weekly = less annoying | Churn rate | -2% |

### Experiment Velocity
- **Target**: 2 experiments/month (once product is stable).
- **Tool**: Posthog (open-source analytics + feature flags).

---

**Next:** See [ROADMAP_PART4_ARCHITECTURE.md](./ROADMAP_PART4_ARCHITECTURE.md) for technical architecture.
