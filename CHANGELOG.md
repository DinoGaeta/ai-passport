# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-11-29
### Added
- **Registry Canister**: Implemented core logic for user mapping and passport provisioning.
- **Passport Architecture**: Defined `Profile`, `SystemConfig`, and `MemoryEntry` types.
- **Frontend MVP**: React + Vite application with TailwindCSS styling.
- **Authentication**: Full integration with Internet Identity (II).
- **Dashboard**: User interface for viewing stats, editing profile, and managing memories.
- **Local Dev Environment**: Configured `dfx.json` for local replica testing.

### Security
- Implemented `isOwner` checks for all write operations on Passport data.
- Configured basic visibility rules (Public vs Private memories).

### Known Issues
- Local environment requires manual cycle top-up for Registry in some configurations.
- Actor Class dynamic spawning replaced with Registry-based storage for MVP stability.
