##
## Initialize all networks
##

echo 'Initializing environment...'
. ibc-testbed/.env

echo 'Testbed directory is '$IBC_TESDBED_HOME

echo 'Stopping all networks binaries...'
sudo systemctl stop lumd
sudo systemctl stop osmosisd
sudo systemctl stop kid
sudo systemctl stop gaiad

echo 'Cleaning up testbed directory...'
rm -rf $IBC_TESDBED_HOME

echo 'Initializing networks keyring...'
lumd keys add $IBC_KEY --home $LUMD_HOME --keyring-backend test
osmosisd keys add $IBC_KEY --home $OSMOSISD_HOME --keyring-backend test
kid keys add $IBC_KEY --home $KID_HOME --keyring-backend test
gaiad keys add $IBC_KEY --home $GAIAD_HOME --keyring-backend test

echo 'Initializing Lum Network...'
cp ibc-testbed/genesis_config/lumd.json $LUMD_HOME/config/genesis.json
lumd add-genesis-account $(lumd keys show $IBC_KEY -a --home $LUMD_HOME --keyring-backend test) 1000000000000000ulum --home $LUMD_HOME
lumd gentx $IBC_KEY 1000000000000ulum --chain-id=$LUM_CHAIN_ID --home $LUMD_HOME
lumd collect-gentxs --home $LUMD_HOME

echo 'Initializing Osmosis Network...'
cp ibc-testbed/genesis_config/osmosisd.json $OSMOSISD_HOME/config/genesis.json
osmosisd add-genesis-account $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) 1000000000000000uosmo --home $OSMOSISD_HOME
osmosisd gentx $IBC_KEY 1000000000000uosmo --chain-id=$OSMOSIS_CHAIN_ID --home $OSMOSISD_HOME --keyring-backend test
osmosisd collect-gentxs --home $OSMOSISD_HOME

# echo 'Initializing Ki Network...'
# cp ibc-testbed/genesis_config/kid.json $KID_HOME/config/genesis.json
# kid add-genesis-account $(kid keys show $IBC_KEY -a --home $KID_HOME) 1000000000000000uxki --home $KID_HOME
# kid gentx $IBC_KEY 1000000000000uxki --chain-id=$KI_CHAIN_ID --home $KID_HOME
# kid collect-gentxs --home $KID_HOME

# echo 'Initializing Cosmos Network...'
cp ibc-testbed/genesis_config/gaiad.json $GAIAD_HOME/config/genesis.json
gaiad add-genesis-account $(gaiad keys show $IBC_KEY -a --home $GAIAD_HOME) 1000000000000000uatom --home $GAIAD_HOME
gaiad gentx $IBC_KEY 1000000000000uatom --chain-id=$COSMOS_CHAIN_ID --home $GAIAD_HOME
gaiad collect-gentxs --home $GAIAD_HOME
