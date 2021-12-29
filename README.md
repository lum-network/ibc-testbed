# IBC integration testbed

This repository contains scripts and files required to run a full IBC test run.

The goal of this repository is to provide a testbed for IBC integrations and multiple networks.

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

#### Run

```sh
sh run.sh test-revive-relay
```
