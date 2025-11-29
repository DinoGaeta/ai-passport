# AI Passport

A decentralized identity and memory protocol for AI agents built on the Internet Computer.

## Current Architecture

This repository is currently a **single-canister MVP** with backend and frontend components.

### Backend

- **Registry Canister**: Stores all user passport data (profile, config, memories) in a single canister
- **Per-user Canister Architecture**: Prototype exists in `src/passport/main.mo` but is NOT deployed in this MVP
- **Authentication**: Uses default DFX identity for local development (Internet Identity integration is planned)

### Frontend

- **Tech Stack**: React + Vite + TypeScript + Tailwind CSS
- **Design**: Apple-inspired minimal aesthetics
- **Communication**: Talks exclusively to the registry canister

## Local Development

### Prerequisites

- [DFX SDK](https://internetcomputer.org/docs/current/developer-docs/setup/install/) (v0.15+)
- Node.js (v18+)
- npm

### Setup Instructions

1. **Start Local Replica**
   ```bash
   dfx start --clean --background
   ```

2. **Deploy Registry Canister**
   ```bash
   dfx deploy registry
   ```

3. **Get Registry Canister ID**
   ```bash
   dfx canister id registry
   ```
   Copy the output (e.g., `bkyz2-fmaaa-aaaaa-qaaaq-cai`)

4. **Configure Frontend**
   - Open `frontend/src/services/icp.ts`
   - Update `REGISTRY_CANISTER_ID` with the value from step 3

5. **Install Frontend Dependencies**
   ```bash
   cd frontend
   npm install
   ```

6. **Run Frontend**
   ```bash
   npm run dev
   ```

7. **Open in Browser**
   - Navigate to `http://localhost:5173`
   - The app will auto-connect and provision your passport

## Example CLI Usage

Test the backend directly using DFX:

```bash
# Get your principal ID
dfx identity get-principal

# Provision a passport (idempotent)
dfx canister call registry provision_passport

# Update your profile
dfx canister call registry update_profile '(record {
  nickname = "CLI User";
  avatarUrl = "";
  bio = "Testing from CLI";
  tags = vec { "cli"; "mvp" }
})'

# Add a public memory
dfx canister call registry add_memory '("This is my first public memory", variant { Public })'

# Get your full state
dfx canister call registry get_full_state '(null)'

# Get public manifest (replace with your principal)
dfx canister call registry get_manifest '(principal "YOUR_PRINCIPAL_HERE")'
```

## Project Structure

```
ai_passport/
├── src/
│   ├── types.mo              # Shared type definitions
│   ├── registry/
│   │   └── main.mo           # Active MVP: single-canister implementation
│   └── passport/
│       └── main.mo           # Future: per-user canister prototype (NOT deployed)
├── frontend/
│   ├── src/
│   │   ├── components/       # UI components
│   │   ├── contexts/         # React contexts (PassportContext)
│   │   ├── pages/            # Page components
│   │   ├── services/         # ICP integration (icp.ts, registryApi.ts, idls.ts)
│   │   └── types.ts          # TypeScript types
│   └── ...
└── dfx.json                  # DFX configuration
```

## Features

- **Dashboard**: View passport summary with profile and memory stats
- **Profile Management**: Edit nickname, bio, avatar URL, and tags
- **Memory Bank**: Add, view, and delete memories with visibility controls (Public/Private/Authorized)
- **Developers**: Inspect public manifests by Principal ID

## API Reference

### Registry Canister Methods

- `provision_passport()` - Create or retrieve passport (idempotent)
- `update_profile(profile: Profile)` - Update user profile
- `update_config(config: SystemConfig)` - Update AI configuration
- `add_memory(content: Text, visibility: Visibility)` - Add new memory
- `delete_memory(id: Nat)` - Delete memory by ID
- `get_full_state(user: ?Principal)` - Get complete state (profile + config + all memories)
- `get_manifest(user: Principal)` - Get public manifest (profile + public memories only)

## Future Work

- **Per-User Canister Architecture**: Implement the actor class pattern from `src/passport/main.mo`
- **Internet Identity Integration**: Add proper authentication flow
- **Encrypted Memories**: Support for private, encrypted storage
- **Access Control Lists**: Fine-grained permission management
- **Marketplace**: Module ecosystem for AI capabilities
- **Mainnet Deployment**: Production-ready deployment with cycles management

## Security Model

- Passport data isolation per user principal
- Public manifest exposes only public memories
- Owner-only write access to profile and memories
- Query calls for read-only operations

## Limitations (Current MVP)

- Single canister stores all user data (not scalable for production)
- No Internet Identity integration (uses default DFX identity)
- No encrypted storage
- No access control lists
- Local development only

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - see [LICENSE](LICENSE) for details.
