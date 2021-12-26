##
## Initialize all networks
##

export IBC_TESDBED_HOME=$HOME/.ibc-testbed
echo 'Testbed directory is '$IBC_TESDBED_HOME

echo 'Stopping all networks binaries...'
sudo systemctl stop lumd
sudo systemctl stop osmosisd
sudo systemctl stop kid
sudo systemctl stop gaiad

echo 'Cleaning up testbed directory...'
rm -rf $HOME/.ibc-testbed

echo 'Initializing networks keyring...'
lumd keys add ibc-testbed-key --home $IBC_TESDBED_HOME/lumd --keyring-backend test
osmosisd keys add ibc-testbed-key --home $IBC_TESDBED_HOME/osmosisd --keyring-backend test
kid keys add ibc-testbed-key --home $IBC_TESDBED_HOME/kid --keyring-backend test
gaiad keys add ibc-testbed-key --home $IBC_TESDBED_HOME/gaiad --keyring-backend test

echo 'Initializing networks genesis files...'
cp ibc-testbed/genesis_config/lumd.json $IBC_TESDBED_HOME/lumd/config/genesis.json
lumd add-genesis-account $(lumd keys show ibc-testbed-key -a --home $IBC_TESDBED_HOME/lumd) 1000000000000000ulum --home $IBC_TESDBED_HOME/lumd
lumd gentx ibc-testbed-key 1000000000000ulum --chain-id=lum-ibctest-1 --home $IBC_TESDBED_HOME/lumd
lumd collect-gentxs --home $IBC_TESDBED_HOME/lumd
