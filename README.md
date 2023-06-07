# Black hole Canister on the Internet Computer

Once a canister sets its only controller to a black hole, it becomes immutable and more!

## How to verify it is a black hole

First, we can read the source code in [src/main.mo](https://github.com/CygnusIC/Blackhole_Canister/blob/main/src/main.mo).
It is about 40 lines, so it should be easy to convince ourselves that it is not doing anything suspicious.

Next, we need to make sure that what is deployed on the Internet Computer is compiled from this source code. To do this, we can verify the hash of the Wasm binary from three sources: built by us (available in Github), built locally, and what is deployed.

```
$ curl -Ls https://github.com/CygnusIC/Blackhole_Canister/blob/main/cygnus_blackhole.wasm |sha256sum
26f789b884355d69d99948c8fe836006c9d3e84ab82af759334fce184029e9ed  -
```

```
$ git clone https://github.com/CygnusIC/Blackhole_Canister.git
$ dfx build cygnus_blackhole
$ cat .dfx/local/canisters/cygnus_blackhole/cygnus_blackhole.wasm | sha256sum
26f789b884355d69d99948c8fe836006c9d3e84ab82af759334fce184029e9ed  -
```

```
$ dfx canister --network=ic info w7sux-siaaa-aaaai-qpasa-cai
Controller: w7sux-siaaa-aaaai-qpasa-cai
Module hash: 0x26f789b884355d69d99948c8fe836006c9d3e84ab82af759334fce184029e9ed
```

## Versions

Each subsequent version allows for the incorporation of additional features, and upon implementation, it transforms into an entirely distinct entity, akin to a new black hole.
_Naturally, it should be noted that there exist multiple black holes in the universe!_

### Version 1.0

Black hole Canister ID: [`w7sux-siaaa-aaaai-qpasa-cai`](https://icscan.io/canister/w7sux-siaaa-aaaai-qpasa-cai)

This version gives one interface `canister_status` that is identical to the IC management canister.

```
service : {
  canister_status: (record {canister_id: canister_id;}) -> (canister_status);
}
```

The safety of this setup lies in the fact that the black hole canister itself is immutable and incapable of taking any action apart from revealing the canister's status. It cannot modify the controlled canister in any way.

When a canister designates the black hole as its sole controller, it becomes non-upgradable. While it is still possible to add cycles to the canister through the ledger, no one can alter its code or behavior. The black hole relies on donations to maintain its cycles balance.

## How to give your canister to a black hole

**WARNING: Be cautious with the steps. You might lose control to your canisters forever!**

Pick one of the black hole canister IDs published above, and run the following command (`w7sux-siaaa-aaaai-qpasa-cai` aka version 1.0 is used here):

```
dfx canister --network=ic update-settings \
    --add-controller w7sux-siaaa-aaaai-qpasa-cai \
    [CANISTER_ID]
```

You will need at least dfx version 0.9.2 to be able to add a controller as shown above.

The above command makes the specified black hole a controller of your canister, but does not remove your access.

To set a black hole as your canister's **only** controller, run the above command with the following modification. Again, this will **remove your ability to control your canister!**

- dfx >= 0.12.0: replace `--add-controller` with `--set-controller`
- dfx 0.8.4 to 0.11.2: replace `--add-controller` with `--controller`

[dfx]: https://sdk.dfinity.org/docs/developers-guide/install-upgrade-remove
[ic-utils]: https://github.com/ninegua/ic-utils
