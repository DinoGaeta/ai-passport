import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const { Actor, HttpAgent } = require('../frontend/node_modules/@dfinity/agent');
const { Principal } = require('../frontend/node_modules/@dfinity/principal');
import { execSync } from 'child_process';

// IDL Factory (copied from idls.ts)
const idlFactory = ({ IDL }) => {
    const Profile = IDL.Record({
        'nickname': IDL.Text,
        'avatarUrl': IDL.Text,
        'bio': IDL.Text,
        'tags': IDL.Vec(IDL.Text),
    });

    const SystemConfig = IDL.Record({
        'corePrompt': IDL.Text,
        'language': IDL.Text,
        'tone': IDL.Variant({ 'Formal': IDL.Null, 'Casual': IDL.Null, 'Pirate': IDL.Null, 'Custom': IDL.Text }),
    });

    const Visibility = IDL.Variant({ 'Public': IDL.Null, 'Private': IDL.Null, 'AuthorizedOnly': IDL.Null });

    const MemoryEntry = IDL.Record({
        'id': IDL.Nat,
        'timestamp': IDL.Int,
        'source': IDL.Text,
        'content': IDL.Text,
        'visibility': Visibility,
    });

    const FullState = IDL.Record({
        'profile': Profile,
        'config': SystemConfig,
        'allMemories': IDL.Vec(MemoryEntry),
    });

    const Manifest = IDL.Record({
        'version': IDL.Nat,
        'schema_version': IDL.Nat,
        'profile': Profile,
        'public_memories': IDL.Vec(MemoryEntry),
        'updated_at': IDL.Nat64,
    });

    const Error = IDL.Variant({
        'NotFound': IDL.Null,
        'NotAuthorized': IDL.Null,
        'InvalidInput': IDL.Null,
        'SystemError': IDL.Text,
        'AlreadyExists': IDL.Null,
        'Conflict': IDL.Text,
    });

    return IDL.Service({
        'update_manifest': IDL.Func([Manifest], [IDL.Variant({ 'ok': IDL.Null, 'err': Error })], []),
    });
};

async function main() {
    console.log("🚀 Starting Concurrency Tests...");

    // Get Canister ID
    const canisterId = execSync('dfx canister id registry').toString().trim();
    console.log(`📍 Registry Canister ID: ${canisterId}`);

    // Create Agent
    const agent = new HttpAgent({ host: "http://127.0.0.1:4943" });
    await agent.fetchRootKey();

    // Create Actor
    const actor = Actor.createActor(idlFactory, {
        agent,
        canisterId,
    });

    // Determine start version
    // Since we can't easily query (IDL mismatch potential), we'll use a timestamp-based version
    // which is guaranteed to be higher than any previous 1-50 counter.
    const startVersion = BigInt(Date.now());
    console.log(`\n🕒 Using start version: ${startVersion}`);

    // Test 1: Sequential Updates (Functional Check)
    console.log("\n🧪 Test 1: Sequential Updates (Ensure ordering works)");
    let seqSuccess = 0;
    for (let i = 1; i <= 10; i++) {
        const ver = startVersion + BigInt(i);
        const manifest = {
            version: ver,
            schema_version: 1n,
            profile: { nickname: `Seq ${i}`, avatarUrl: "", bio: "", tags: [] },
            public_memories: [],
            updated_at: BigInt(Date.now()) * 1000000n,
        };
        try {
            const res = await actor.update_manifest(manifest);
            if ('ok' in res) seqSuccess++;
            else console.error(`Failed seq update ${i}:`, res);
        } catch (e) { console.error(e); }
    }
    if (seqSuccess === 10) console.log("✅ All 10 sequential updates succeeded.");
    else console.error(`❌ Only ${seqSuccess}/10 sequential updates succeeded.`);

    // Test 2: Concurrent Race (Stress Check)
    console.log("\n🧪 Test 2: Concurrent Race (50 updates in parallel)");
    console.log("   Expectation: Some might fail as 'Stale', but final version must be high.");

    const updates = [];
    const raceBaseVersion = startVersion + 100n; // Start well after sequential
    const count = 50;

    for (let i = 0; i < count; i++) {
        const manifest = {
            version: raceBaseVersion + BigInt(i),
            schema_version: 1n,
            profile: { nickname: `Race ${i}`, avatarUrl: "", bio: "", tags: [] },
            public_memories: [],
            updated_at: BigInt(Date.now()) * 1000000n,
        };
        updates.push(actor.update_manifest(manifest));
    }

    const results = await Promise.all(updates);
    const successes = results.filter(r => 'ok' in r).length;
    const conflicts = results.filter(r => 'err' in r && 'Conflict' in r.err).length;

    console.log(`   Results: ${successes} OK, ${conflicts} Conflicts (Stale).`);

    if (successes + conflicts === count) {
        console.log("✅ All requests processed (either accepted or correctly rejected).");
    } else {
        console.error("❌ Some requests failed with unknown errors.");
    }

    // Test 3: Stale Version Conflict (Explicit)
    console.log("\n🧪 Test 3: Explicit Stale Version Conflict");
    try {
        const staleManifest = {
            version: 1n, // Much lower than current (timestamp based)
            schema_version: 1n,
            profile: { nickname: "Stale", avatarUrl: "", bio: "", tags: [] },
            public_memories: [],
            updated_at: BigInt(Date.now()) * 1000000n,
        };
        const result = await actor.update_manifest(staleManifest);
        if ('err' in result && 'Conflict' in result.err) {
            console.log("✅ Stale version correctly rejected with Conflict error.");
        } else {
            console.error("❌ Stale version was NOT rejected!", result);
        }
    } catch (e) {
        console.error("❌ Exception during stale test:", e);
    }

    console.log("\n🎉 Tests Completed.");
}

main();
