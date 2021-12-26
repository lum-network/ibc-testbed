##
## Initialize all networks
##

echo 'Initializing environment...'
sh ibc-testbed/env.sh

echo 'Testbed directory is '$IBC_TESDBED_HOME

echo 'Stopping all networks binaries...'
sudo systemctl stop lumd
sudo systemctl stop osmosisd
sudo systemctl stop kid
sudo systemctl stop gaiad

echo 'Cleaning up testbed directory...'
rm -rf $IBC_TESDBED_HOME

echo 'Initializing networks keyring...'
lumd keys add ibc-testbed-key --home $LUMD_HOME --keyring-backend test
# osmosisd keys add ibc-testbed-key --home $IBC_TESDBED_HOME/osmosisd --keyring-backend test
# kid keys add ibc-testbed-key --home $IBC_TESDBED_HOME/kid --keyring-backend test
# gaiad keys add ibc-testbed-key --home $IBC_TESDBED_HOME/gaiad --keyring-backend test

echo 'Initializing networks genesis files...'
cp ibc-testbed/genesis_config/lumd.json $LUMD_HOME/config/genesis.json
lumd add-genesis-account $(lumd keys show ibc-testbed-key -a --home $LUMD_HOME) 1000000000000000ulum --home $LUMD_HOME
lumd gentx ibc-testbed-key 1000000000000ulum --chain-id=lum-ibctest-1 --home $LUMD_HOME
lumd collect-gentxs --home $LUMD_HOME
