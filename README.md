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
sudo sh ibc-testbed/install.sh
```

## Initialize networks & relayer

This script can be run any number of times to reset and restart the tests.

```sh
sh ibc-testbed/init.sh
```

## Run the tests

`WIP`
