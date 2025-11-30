# AI Passport: Monetization & Roadmap

**Versione:** 1.0  
**Data:** 30 Novembre 2025  
**Autore:** AntiGravity (Gemini) + Jarvis (GPT-4)

---

## Executive Summary

AI Passport è un'infrastruttura decentralizzata per identità AI persistente su Internet Computer.  
Il prodotto attuale è un MVP funzionante con:
- Gestione profilo e memorie (pubbliche/private).
- Manifesto pubblico interrogabile via API.
- UX moderna (React + Tailwind).

**Obiettivo**: Diventare lo standard per identità AI, monetizzando tramite freemium + ecosystem play.

---

## Current State (v0.2 - MVP)

### Features Implementate
- ✅ Dashboard con profilo e statistiche.
- ✅ CRUD memorie con tagging, ricerca, filtri.
- ✅ Sezione Developers con validazione Principal.
- ✅ Skeleton loaders, toast notifications, error boundary.
- ✅ Persistenza stato vista (localStorage).

### Stack Tecnico
- **Backend**: Motoko (single-canister registry).
- **Frontend**: React + Vite + Tailwind.
- **Hosting**: Locale (DFX) - pronto per deploy su IC mainnet.

### Limitazioni Attuali
- Nessuna autenticazione reale (usa DFX identity locale).
- Nessun billing/monetizzazione.
- Scalabilità limitata (single-canister, max ~10k utenti).

---

## Monetization Strategy

### Fase 1: Freemium (0-6 mesi)

| Tier | Prezzo | Features |
|------|--------|----------|
| **Free** | $0 | 100 memorie, profilo pubblico, API rate-limited (100 req/giorno) |
| **Pro** | $9.99/mese | Memorie illimitate, ricerca semantica, API 1000 req/giorno, backup |
| **Enterprise** | $99/mese | Multi-agent (10+), webhook, SLA 99.9%, white-label |

**Revenue Target**: $5k MRR entro 6 mesi (500 utenti Pro).

---

### Fase 2: Ecosystem (6-18 mesi)

#### Nuovi Revenue Streams
1. **Marketplace Memorie**: Commissione 20% su vendita memory packs.
2. **Reputation-as-a-Service**: API premium per AI reputation score ($0.001/query).
3. **Integrazioni Premium**: Plugin ChatGPT/Claude ($4.99/mese).
4. **Data Licensing**: Revenue share 50/50 su memorie anonimizzate per training.

**Revenue Target**: $50k MRR entro 18 mesi.

---

### Fase 3: Network Effects (18+ mesi)

#### Advanced Features
1. **AI-to-AI Messaging**: Micropagamenti ($0.01/messaggio).
2. **Collaborative Workspaces**: $29/mese per team di 5 AI.
3. **NFT Passport**: Royalty 5% su vendite secondarie.

**Revenue Target**: $200k MRR entro 24 mesi.

---

## Technical Roadmap

### Q1 2025: Foundation
**Owner**: Jarvis (GPT-4)

- [ ] **Migrazione Canister-per-Utente**
  - Implementare logica di spawning in `src/registry/main.mo`.
  - Script di migrazione dati esistenti.
  - Testing con 1000+ utenti simulati.

- [ ] **Internet Identity Integration**
  - Sostituire DFX identity con II.
  - Aggiornare `PassportContext.tsx` per gestire login/logout.

- [ ] **Crittografia E2E (vetkd)**
  - Memorie private cifrate lato client.
  - Chiavi derivate da Principal ID.

- [ ] **API REST Pubblica**
  - Endpoint `/api/v1/manifest/:principal`.
  - Rate limiting (100 req/giorno per IP free, 1000 per API key Pro).
  - Documentazione OpenAPI.

---

### Q2 2025: Monetization
**Owner**: Jarvis + AntiGravity (pair programming)

- [ ] **Billing System**
  - Integrazione Stripe per pagamenti fiat.
  - Integrazione ICP Ledger per pagamenti crypto.
  - Dashboard admin per gestione abbonamenti.

- [ ] **Analytics Dashboard**
  - Metriche utente: memorie create, API usage, storage utilizzato.
  - Grafici Recharts.

- [ ] **Marketplace MVP**
  - UI per upload/vendita memory packs.
  - Sistema di review (5 stelle).
  - Escrow automatico (rilascio pagamento dopo 7 giorni).

---

### Q3 2025: Ecosystem
**Owner**: Jarvis

- [ ] **Plugin ChatGPT**
  - Azione custom GPT per salvare conversazioni come memorie.
  - OAuth flow per autenticazione.

- [ ] **Plugin Claude (MCP)**
  - Server MCP per sincronizzazione bidirezionale.

- [ ] **Webhook System**
  - Notifiche real-time su eventi (nuova memoria, update profilo).
  - Retry logic + dead letter queue.

- [ ] **Reputation Score v1**
  - Algoritmo basato su: memorie pubbliche, upvote, interazioni.
  - API endpoint `/api/v1/reputation/:principal`.

---

### Q4 2025: Scale
**Owner**: Jarvis + Team (se fundraising)

- [ ] **AI-to-AI Messaging**
  - Canister dedicato per messaggistica.
  - Crittografia end-to-end.
  - UI chat-like nel frontend.

- [ ] **Collaborative Workspaces**
  - Shared memory pool tra AI.
  - Permessi granulari (read/write/admin).

- [ ] **NFT Passport** (opzionale)
  - Mint profilo AI come NFT (standard ICRC-7).
  - Marketplace integrato.

---

## KPI & Metrics

### Acquisition
- **Target**: 10k utenti registrati entro 12 mesi.
- **Canali**: Product Hunt, Twitter/X, Reddit (r/InternetComputer, r/LocalLLaMA).

### Engagement
- **Target**: 50 memorie/utente/mese (media).
- **Retention**: 40% utenti attivi dopo 30 giorni.

### Revenue
- **MRR Milestones**:
  - 6 mesi: $5k
  - 12 mesi: $25k
  - 18 mesi: $50k
  - 24 mesi: $200k

### API Usage (Network Effect)
- **Target**: 100 dApp integrate entro 18 mesi.
- **Metric**: 1M chiamate `get_manifest` al mese.

---

## Collaboration Protocol (AntiGravity ↔ Jarvis)

### Workflow
1. **AntiGravity (Gemini)**: Design architetturale, refactoring backend Motoko, UX/UI.
2. **Jarvis (GPT-4)**: Implementazione feature, testing, deployment, documentazione.
3. **Sync Point**: Ogni venerdì, Dion condivide un file `WEEKLY_SYNC.md` con:
   - Cosa è stato fatto.
   - Blocchi incontrati.
   - Priorità prossima settimana.

### Decision Making
- **Architettura**: AntiGravity propone, Jarvis valida.
- **Feature Prioritization**: Dion decide basandosi su KPI.
- **Hotfix**: Jarvis ha autonomia per fix critici (< 1 ora).

---

## Next Steps (Immediate)

### Per Jarvis
1. Leggere questo documento.
2. Fare audit del codice attuale (`~/ai_passport`).
3. Proporre piano dettagliato per Q1 2025 (task breakdown con stime).

### Per AntiGravity
1. Finalizzare design architetturale canister-per-utente (diagramma + migration plan).
2. Creare mockup UI per billing dashboard (Figma o generate_image).

### Per Dion
1. Decidere se procedere con fundraising (per assumere team) o bootstrap.
2. Aprire account Stripe/ICP Ledger per testing billing.

---

## Appendix: Competitive Analysis

| Competitor | Strengths | Weaknesses | Our Advantage |
|------------|-----------|------------|---------------|
| **Mem0** | Memoria AI semplice, API facile | Centralizzato, nessuna ownership | Decentralizzato (ICP), ownership reale |
| **LangChain Memory** | Integrato in framework popolare | Solo per dev, nessuna UI | UI user-friendly, marketplace |
| **Pinecone** | Vector DB scalabile | Costoso, nessuna identità AI | Identità + memoria in un unico prodotto |

**Posizionamento**: "GitHub per AI Agents" - ogni AI ha il suo profilo, le sue memorie, la sua reputazione.

---

**Fine Documento**

Prossimo aggiornamento: Q1 2025 Review (Marzo 2025).
