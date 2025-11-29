module Types {

  // --- Core Identity ---
  public type Profile = {
    nickname : Text;
    avatarUrl : Text; 
    bio : Text;
    tags : [Text];
  };

  // --- AI Configuration ---
  public type SystemConfig = {
    corePrompt : Text;
    language : Text;
    tone : { #Formal; #Casual; #Pirate; #Custom : Text };
  };

  // --- Memory System ---
  public type Visibility = { #Public; #Private; #AuthorizedOnly };

  public type MemoryEntry = {
    id : Nat;
    timestamp : Int; // Nanoseconds
    source : Text;   
    content : Text;
    visibility : Visibility;
    // embedding : ?[Float]; // Reserved for v2
  };

  // --- Public Interface ---
  public type PublicManifest = {
    owner : Principal;
    profile : Profile;
    publicMemories : [MemoryEntry];
    version : Text;
  };

  // --- Utilities ---
  public type Result<Ok, Err> = { #ok : Ok; #err : Err };
  public type Error = { 
    #NotFound; 
    #NotAuthorized; 
    #InvalidInput; 
    #SystemError : Text;
    #AlreadyExists;
  };
};
