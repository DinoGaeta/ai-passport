AI Passport

A decentralized identity and memory protocol for AI agents.
AI Passport allows users to own a persistent, portable memory and personality profile for their AI across applications, games, and digital environments.
It is designed for sovereignty, interoperability, and long-term data ownership, and is fully built on the Internet Computer (ICP).

Table of Contents

Overview

Features

Architecture

Component Overview

Data Model

Registry API

Passport API

Local Development

Mainnet Deployment

Integration Guide for dApps

Security Model

Limitations

Roadmap

Contributing

License

Overview

AI Passport provides:

A personal canister storing user-owned AI data.

A portable identity an AI agent can use across any application.

A standard interface that external dApps can query.

Full data sovereignty: the user owns the compute and storage.

Features

User-owned identity and memory

Decentralized storage on ICP

Public/private memory segregation

Customizable AI SystemConfig

React-based management dashboard

Internet Identity authentication

Portable public manifest

Scalable Registry + User Canister architecture

Architecture

The system follows a "Registry + Personal Passport" pattern.

graph TD
    User((User)) -->|Authenticate| UI[Frontend Application]
    UI -->|Lookup / Provision| Registry[Registry Canister]
    Registry -->|Create / Retrieve| Passport[User Passport Canister]
    ExternalApp[External dApp] -.->|Read Public Manifest| Passport

    subgraph Internet Computer
        Registry
        Passport
    end

Component Overview

Registry Canister

Maps Principal → PassportCanisterId

Provisions new Passports

Write-protected except for provisioning

Passport Canister

Stores Profile, SystemConfig, Memories

Exposes public read-only manifest

Write access restricted to owner

Frontend Dashboard

React + Typescript

Internet Identity authentication

Profile and memory management

Data Model
Profile
nickname  
avatarUrl  
bio  
tags  

SystemConfig
corePrompt  
language  
tone  

MemoryEntry
id  
timestamp  
source  
content  
visibility  

PublicManifest
owner  
profile  
publicMemories  
version  

Registry API

provision_passport()

get_passport(user : Principal)

Passport API

update_profile(...)

update_config(...)

add_memory(...)

delete_memory(...)

get_manifest()

get_full_state()

Local Development

Start replica:

dfx start --clean --background


Deploy:

dfx deploy internet_identity
dfx deploy registry


Run frontend:

cd frontend
npm install
npm run dev

Mainnet Deployment

Convert ICP to cycles:

dfx wallet --network ic balance


Deploy:

dfx deploy --network ic


Configure frontend with live canister IDs.

Integration Guide for dApps

Call get_passport(userPrincipal)

Call get_manifest()

Use cases:

Cross-app AI personality

Memory portability

Game/NPC personalization

Preference onboarding

Security Model

Passport isolation per user

Internet Identity authentication

Public manifest read-only

Cycles required for operation

Future extensions: ACL, encrypted memory, rate limiting

Limitations

Missing ACL system

No encrypted storage

No on-canister LLM integration

Local-development optimized

Roadmap

v0.2: Backup/restore, ACL
v0.3: Encrypted memory, Threshold ECDSA
v1.0: Mainnet release, module marketplace

Contributing

See CONTRIBUTING.md.

License

MIT License.
