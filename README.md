# IBC integration testbed

This repository contains scripts and files required to run a full IBC test run.

The goal of this repository is to provide a testbed for IBC integrations and multiple networks.

## Basic features

-   Launch 4 networks (Tendermint & Cosmos SDK based)
    -   Lum Network
    -   Osmosis
    -   Cosmos Hub
    -   Ki chain
-   Create IBC channels to Osmosis
    -   Lum <> Osmosis
    -   Ki <> Osmosis
    -   Cosmos <> Osmosis

## Project structure

-   [daemons](./daemons)
    -   systemctl service files to run the networks
-   [genesis_config](./genesis_config)
    -   genesis configurations suited for testing
-   [relayer](./relayer)
    -   relayer configuration
    -   note: an improvement would be to specify which relayer config to use for each test suite
-   [scripts](./scripts)
    -   a bunch of scripts to run the test suites
    -   each script should be test independant
    -   scripts should all use the [.env](./.env) variables
-   [tests](./tests)
    -   test suites
    -   each test suite should consider that it is running in a ready+clean environment (networks and relayers)

## Tested using

-   Debian Bullseye
-   8 Core / 32 GB RAM / 300 GB disk

## Getting started

SSH to your machine and follow the steps below.

_Note: it is recommended to use a clean test machine._

### Install git

```sh
sudo apt-get install git --yes
```

## Clone this repository

```sh
git clone https://github.com/lum-network/ibc-testbed.git
```

## Move into the repository

```sh
cd ibc-testbed
```

## Instal dependencies and network binaries

This script must only be run once.

```sh
sh scripts/install.sh
```

## Running test(s)

Each test present in the [tests](./tests) folder can be run using the following command

```sh
sh run.sh test-name
```

The [run.sh](./run.sh) script does the following:

-   Stop all running daemons (if needed)
-   Clean up networks and relayers
-   Initialize networks, relayers and wallets
    -   Each network has a 1Bi master wallet
    -   Each relayer has a 1Mi wallet
-   Start networks and relayers
-   Run the requested test suite
-   Stop networks daemons

## Debugging

To ease debugging you can set all the [env](./.env) variable for your current sheel by using

```sh
set -a; source .env; set +a
```

Which will let you basically copy commands from the scripts and use all the pre-set paths, urls etc...

## Available tests

Feel free to contribute by either improving existing test suites or by adding new test suites

### Test Revive Relaying

[tests/test-revive-relay.sh](./tests/test-revive-relay.sh)

#### Goal

Test suite to see how networks and IBC relayers react when an IBC client expires and a governance proposal is voted YES in order to update and "revive" the client.

Since the feature is experimental (and has apparently never been tested in production) it is critical for this test to verify the following:

-   Expired clients do not prevent other clients to work properly
-   Governance proposal of type `ibc.core.client.v1.ClientUpdateProposal` can be voted YES without impacting other clients
-   Once governance proposal is passed all clients work including the expired clients

This test basically does:

-   Send coins from and to Osmosis for all networks
-   Relay (should work)
-   Wait for Lum <> Osmosis client to expire
-   Send coins from and to Osmosis for all networks
-   Relay (should work except for Lum <> Osmosis)
-   Revive the client using gov proposal on Osmosis
-   Send coins from and to Osmosis for all networks
-   Relay (should work)
-   Dump wallets for manual verification (debug / double check)

#### Run

```sh
sh run.sh test-revive-relay
```

#### Expected output

<details>
    <summary>
        Click to expand to see full output
    </summary>
    
    [INFO] Initializing networks...

    [INFO] Network initialized with success

    [INFO] Starting networks daemons...

    [INFO] Waiting for networks to be up and running...

    [INFO] Networks are up and running

    [INFO] Initializing relayers (will take a while)...

    [INFO] Relayers initialization succeeded

    [INFO][run] Before test preparation success

    [INFO] Transferring coins from Lum to Osmosis...

    [INFO] Transaction accepted

    [INFO] Transferring coins from Ki to Osmosis...

    [INFO] Transaction accepted

    [INFO] Transferring coins from Cosmos to Osmosis...

    [INFO] Transaction accepted

    [INFO] Transferring coins from Osmosis to Lum...

    [INFO] Transaction accepted

    [INFO] Transferring coins from Osmosis to Ki...

    [INFO] Transaction accepted

    [INFO] Transferring coins from Osmosis to Cosmos...

    [INFO] Transaction accepted

    [INFO] Relay packets manually (all realyers should work)...

    [INFO] Relaying done

    [INFO] Waiting 5min for the Lum <> Osmosis client to expire...

    [INFO] Transferring coins from Lum to Osmosis...

    [INFO] Transaction accepted

    [INFO] Transferring coins from Ki to Osmosis...

    [INFO] Transaction accepted

    [INFO] Transferring coins from Cosmos to Osmosis...

    [INFO] Transaction accepted

    [INFO] Transferring coins from Osmosis to Lum...

    [INFO] Transaction rejected

    [INFO] Transferring coins from Osmosis to Ki...

    [INFO] Transaction accepted

    [INFO] Transferring coins from Osmosis to Cosmos...

    [INFO] Transaction accepted

    [INFO] Relay packets between Lum <> Osmosis (should not work)...

    [INFO] Relaying not working as expected

    [INFO] Relay packets between other networks (should work)...

    [INFO] Relaying done

    [INFO] Creating and updating new substitute client to replace the expired one...

    [INFO] Running gov proposal on Osmosis to revive Lum <> Osmosis relayer...

    [INFO] Waiting 60s for the proposal to pass...

    [INFO] Updating substitute client...

    [INFO] Transferring coins from Lum to Osmosis...

    [INFO] Transaction accepted

    [INFO] Transferring coins from Ki to Osmosis...

    [INFO] Transaction accepted

    [INFO] Transferring coins from Cosmos to Osmosis...

    [INFO] Transaction accepted

    [INFO] Transferring coins from Osmosis to Lum...

    [INFO] Transaction accepted

    [INFO] Transferring coins from Osmosis to Ki...

    [INFO] Transaction accepted

    [INFO] Transferring coins from Osmosis to Cosmos...

    [INFO] Transaction accepted

    [INFO] Relay packets manually...

    [INFO] Relaying done

    [DEBUG] Dumping test wallets:

    - Osmosis wallet should have 3 ibc denom with 3 coins each

    - Each network should have an extra denom with 3 coins (uosmo IBC)

    [DEBUG] Osmosis wallet (chain): osmo1prs4r3kf940m8czmyx20h8t2f69z7mstrjuv4y

    balances:

    - amount: "3"

    denom: ibc/09AB36F70D97B9D4C43168A3389CBDA70CAEA7D3A5A9A2D57C7E1E10F2BDB213

    - amount: "3"

    denom: ibc/C4CFF46FD6DE35CA4CF4CE031E643C8FDC9BA4B99AE598E9B0ED98FE3A2319F9

    - amount: "3"

    denom: ibc/D140FF970C4256ADD8CF74815DA15279ECD10C7DD588FF41165F423C53BE256C

    - amount: "998000000000000"

    denom: uosmo

    pagination:

    next_key: null

    total: "0"

    [DEBUG] Lum wallet (chain): lum1xs87ptzrjzq6fgye8gn9es5hlma4jzxywhtw75

    balances:

    - amount: "2"

    denom: ibc/ED07A3391A112B175915CD8FAF43A2DA8E4790EDE12566649D0C2F97716B8518

    - amount: "998000000000000"

    denom: ulum

    pagination:

    next_key: null

    total: "0"

    [DEBUG] Ki wallet (chain): ki155htzc84xe4qlc033t60dfknw8rvyas4xe748s

    balances:

    - amount: "3"

    denom: ibc/ED07A3391A112B175915CD8FAF43A2DA8E4790EDE12566649D0C2F97716B8518

    - amount: "998000000000000"

    denom: uxki

    pagination:

    next_key: null

    total: "0"

    [DEBUG] Cosmos wallet (chain): cosmos1s5y2al7gu669hud6yq6hgdvl670kagma8nths2

    balances:

    - amount: "3"

    denom: ibc/ED07A3391A112B175915CD8FAF43A2DA8E4790EDE12566649D0C2F97716B8518

    - amount: "998000000000000"

    denom: uatom

    pagination:

    next_key: null

    total: "0"

    [INFO][run] Test suite succeeded

    [INFO] Stopping networks daemons...

    [INFO][run] After test clean up success

</details>
