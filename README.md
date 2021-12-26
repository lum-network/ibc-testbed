# IBC integration testbed

This repository contains scripts and files required to run a full IBC test run.

The goal of this repository is to test IBC integration between multiple networks alongside IBC channel modifications using governance proposal.

## Tested using

-   Debian Bullseye
-   8 Core / 32 GB RAM / 300 GB disk

## Running the tests

SSH to your machine and follow the steps below.

### Install git

```sh
sudo apt-get install git --yes
```

## Clone this repository

```sh
git clone https://github.com/lum-network/ibc-testbed.git
```

## Instal dependencies and network binaries

This script must only be run once.

```sh
sh ibc-testbed/install.sh
```

## Initialize networks & relayer

This script can be run any number of times to reset and restart the tests.

It will stop the daemon processes, clean up and init all networks and restart the processes.

```sh
sh ibc-testbed/init.sh
```

## Seed the relayer addresses

```sh
sh ibc-testbed/seed-relayer.sh
```

## Run the tests

WIP/TODO:
- Update genesis configs to have ~60 seconds voting time
- IBC channel freeze + revive using proposal
- IBC transfer test pre and post proposal
