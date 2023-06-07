import Principal "mo:base/Principal";
import Prelude "mo:base/Prelude";

actor {
    public type canister_id = Principal;

    public type definite_canister_settings = {
        freezing_threshold : Nat;
        controllers : [Principal];
        memory_allocation : Nat;
        compute_allocation : Nat;
    };

    public type canister_status = {
        status : { #stopped; #stopping; #running };
        memory_size : Nat;
        cycles : Nat;
        settings : definite_canister_settings;
        module_hash : ?[Nat8];
        idle_cycles_burned_per_day : Nat;
    };

    public type IC = actor {
        canister_status : { canister_id : canister_id } -> async canister_status;
    };

    let ic : IC = actor ("aaaaa-aa");

    let CYGNUS_CANISTER_ID = "dowzh-nyaaa-aaaai-qnowq-cai";

    public shared ({ caller }) func canister_status(request : { canister_id : canister_id }) : async canister_status {

        // Only Cygnus can invoke this function and it prevents unwanted invocations
        if (caller != Principal.fromText(CYGNUS_CANISTER_ID)) {
            Prelude.unreachable();
        };

        await ic.canister_status(request);
    };
};
