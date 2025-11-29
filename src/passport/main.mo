import Types "../types";
import Buffer "mo:base/Buffer";
import Time "mo:base/Time";

// The Passport Actor Class
// This is spawned for each user.
shared ({ caller = installer }) actor class Passport(initOwner : Principal) {

  // --- State ---
  private let owner : Principal = initOwner;
  
  private var profile : Types.Profile = {
    nickname = "Anon";
    avatarUrl = "";
    bio = "New AI Passport";
    tags = [];
  };

  private var config : Types.SystemConfig = {
    corePrompt = "You are a helpful AI assistant.";
    language = "en";
    tone = #Casual;
  };

  // Using a Buffer for dynamic storage
  private let memories = Buffer.Buffer<Types.MemoryEntry>(10);
  private var nextMemoryId : Nat = 0;

  // --- Helpers ---
  private func isOwner(p : Principal) : Bool {
    return p == owner;
  };

  // --- Write Methods (Owner Only) ---

  public shared(msg) func update_profile(newProfile : Types.Profile) : async Types.Result<(), Types.Error> {
    if (not isOwner(msg.caller)) return #err(#NotAuthorized);
    profile := newProfile;
    return #ok(());
  };

  public shared(msg) func update_config(newConfig : Types.SystemConfig) : async Types.Result<(), Types.Error> {
    if (not isOwner(msg.caller)) return #err(#NotAuthorized);
    config := newConfig;
    return #ok(());
  };

  public shared(msg) func add_memory(content : Text, visibility : Types.Visibility) : async Types.Result<Nat, Types.Error> {
    if (not isOwner(msg.caller)) return #err(#NotAuthorized);
    
    let id = nextMemoryId;
    nextMemoryId += 1;

    let newMemory : Types.MemoryEntry = {
      id = id;
      timestamp = Time.now();
      source = "User";
      content = content;
      visibility = visibility;
    };

    memories.add(newMemory);
    return #ok(id);
  };

  public shared(msg) func delete_memory(id : Nat) : async Types.Result<(), Types.Error> {
    if (not isOwner(msg.caller)) return #err(#NotAuthorized);
    
    // Simple linear search for MVP. In prod, use a HashMap or stable structure.
    var found = false;
    var index = 0;
    
    // Iterate to find index
    for (mem in memories.vals()) {
      if (mem.id == id) {
        found := true;
        // We can't break easily in Motoko iterators without a label, 
        // but for MVP we just mark found.
      };
      if (not found) {
        index += 1;
      };
    };

    if (found) {
      memories.remove(index);
      return #ok(());
    } else {
      return #err(#NotFound);
    };
  };

  // --- Read Methods (Public / Owner) ---

  public query func get_manifest() : async Types.PublicManifest {
    // Filter only public memories
    var publicMems : [Types.MemoryEntry] = [];
    for (mem in memories.vals()) {
      switch (mem.visibility) {
        case (#Public) {
          publicMems := Array.append(publicMems, [mem]);
        };
        case (_) {};
      };
    };

    return {
      owner = owner;
      profile = profile;
      publicMemories = publicMems;
      version = "0.1.0-MVP";
    };
  };

  public shared(msg) func get_full_state() : async Types.Result<{
    profile: Types.Profile;
    config: Types.SystemConfig;
    allMemories: [Types.MemoryEntry];
  }, Types.Error> {
    if (not isOwner(msg.caller)) return #err(#NotAuthorized);

    return #ok({
      profile = profile;
      config = config;
      allMemories = Buffer.toArray(memories);
    });
  };
};
