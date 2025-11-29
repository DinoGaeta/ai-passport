import Types "../types";
import HashMap "mo:base/HashMap";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import Time "mo:base/Time";
import Array "mo:base/Array";

// SIMPLIFIED MVP VERSION
// Instead of spawning individual canisters, we store all passports in the Registry
// This works for local testing. In production, we'd use the Actor Class approach.

persistent actor Registry {

  // Map User Principal -> Passport Data
  type PassportData = {
    owner: Principal;
    var profile: Types.Profile;
    var config: Types.SystemConfig;
    memories: Buffer.Buffer<Types.MemoryEntry>;
    var nextMemoryId: Nat;
  };

  transient let passports = HashMap.HashMap<Principal, PassportData>(0, Principal.equal, Principal.hash);

  // --- Public API ---

  public query func get_passport(user : Principal) : async ?Principal {
    // In this simplified version, we return the user's own principal as their "passport ID"
    // since the data lives here in the registry
    switch (passports.get(user)) {
      case (?_) { ?user };
      case (null) { null };
    };
  };

  public shared(msg) func provision_passport() : async Types.Result<Principal, Types.Error> {
    let user = msg.caller;

    switch (passports.get(user)) {
      case (?_) {
        return #ok(user); // Already exists
      };
      case (null) {
        // Create new passport data
        let newPassport : PassportData = {
          owner = user;
          var profile = {
            nickname = "Anon";
            avatarUrl = "";
            bio = "New AI Passport";
            tags = [];
          };
          var config = {
            corePrompt = "You are a helpful AI assistant.";
            language = "en";
            tone = #Casual;
          };
          memories = Buffer.Buffer<Types.MemoryEntry>(10);
          var nextMemoryId = 0;
        };
        
        passports.put(user, newPassport);
        return #ok(user);
      };
    };
  };

  // Passport-like methods (called by frontend thinking it's talking to a separate canister)
  
  public shared(msg) func update_profile(newProfile : Types.Profile) : async Types.Result<(), Types.Error> {
    switch (passports.get(msg.caller)) {
      case (?passport) {
        passport.profile := newProfile;
        return #ok(());
      };
      case (null) { #err(#NotFound) };
    };
  };

  public shared(msg) func update_config(newConfig : Types.SystemConfig) : async Types.Result<(), Types.Error> {
    switch (passports.get(msg.caller)) {
      case (?passport) {
        passport.config := newConfig;
        return #ok(());
      };
      case (null) { #err(#NotFound) };
    };
  };

  public shared(msg) func add_memory(content : Text, visibility : Types.Visibility) : async Types.Result<Nat, Types.Error> {
    switch (passports.get(msg.caller)) {
      case (?passport) {
        let id = passport.nextMemoryId;
        passport.nextMemoryId := passport.nextMemoryId + 1;

        let newMemory : Types.MemoryEntry = {
          id = id;
          timestamp = Time.now();
          source = "User";
          content = content;
          visibility = visibility;
        };

        passport.memories.add(newMemory);
        return #ok(id);
      };
      case (null) { #err(#NotFound) };
    };
  };

  public shared(msg) func delete_memory(id : Nat) : async Types.Result<(), Types.Error> {
    switch (passports.get(msg.caller)) {
      case (?passport) {
        var found = false;
        var index = 0;
        
        for (mem in passport.memories.vals()) {
          if (mem.id == id) {
            found := true;
          };
          if (not found) {
            index += 1;
          };
        };

        if (found) {
          ignore passport.memories.remove(index);
          return #ok(());
        } else {
          return #err(#NotFound);
        };
      };
      case (null) { #err(#NotFound) };
    };
  };

  public query func get_manifest(user: Principal) : async Types.PublicManifest {
    switch (passports.get(user)) {
      case (?passport) {
        return {
          owner = user;
          profile = passport.profile;
          publicMemories = Buffer.toArray(passport.memories); // In a real app we would filter for #Public visibility
          version = "0.1.0-MVP";
        };
      };
      case (null) {
        return {
          owner = user;
          profile = {
            nickname = "Not Found";
            avatarUrl = "";
            bio = "No passport found for this user.";
            tags = [];
          };
          publicMemories = [];
          version = "0.0.0";
        };
      };
    };
  };

  public query func get_full_state(userOpt : ?Principal) : async Types.Result<Types.FullState, Types.Error> {
    let targetUser = switch(userOpt) {
      case (null) { msg.caller }; // If null, use caller (but msg.caller in query is anonymous unless authenticated, which is fine for local MVP if using default identity)
      case (?u) { u };
    };

    // Note: In a real query call, msg.caller is not authenticated unless using update. 
    // For this MVP, we allow reading state if we know the principal.
    // If userOpt is null, we try msg.caller.

    switch (passports.get(targetUser)) {
      case (?passport) {
        return #ok({
          profile = passport.profile;
          config = passport.config;
          allMemories = Buffer.toArray(passport.memories);
        });
      };
      case (null) { #err(#NotFound) };
    };
  };
};
