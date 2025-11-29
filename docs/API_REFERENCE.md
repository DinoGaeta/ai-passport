# 🔌 API Reference

## Registry Canister
**Canister ID (Local):** `uzt4z-lp777-77774-qaabq-cai`

### Types

```motoko
type Result<T, E> = { #ok : T; #err : E };
type Visibility = { #Public; #Private; #AuthorizedOnly };
```

### Methods

#### `provision_passport`
Creates a new passport for the caller.
```motoko
func provision_passport() : async Result<Principal, Error>
```

#### `get_full_state`
Returns the complete state of the user's passport. **Owner Only.**
```motoko
func get_full_state() : async Result<FullState, Error>
```

#### `update_profile`
Updates the public profile. **Owner Only.**
```motoko
func update_profile(profile : Profile) : async Result<(), Error>
```

#### `add_memory`
Adds a new memory entry. **Owner Only.**
```motoko
func add_memory(content : Text, visibility : Visibility) : async Result<Nat, Error>
```

#### `delete_memory`
Removes a memory entry by ID. **Owner Only.**
```motoko
func delete_memory(id : Nat) : async Result<(), Error>
```
