##
## Initialize all networks
##

. .env

echo '[INFO] Testbed directory is '$IBC_TESDBED_HOME

sh stop-daemons.sh

echo '[INFO] Cleaning up testbed directories...'
rm -rf $LUMD_HOME
rm -rf $OSMOSISD_HOME
rm -rf $KID_HOME
rm -rf $GAIAD_HOME
rm -rf $RELAYER_HOME

echo '[INFO] Initializing networks keyring...'
osmosisd keys add $IBC_KEY --home $OSMOSISD_HOME --keyring-backend test
lumd keys add $IBC_KEY --home $LUMD_HOME --keyring-backend test
kid keys add $IBC_KEY --home $KID_HOME --keyring-backend test
gaiad keys add $IBC_KEY --home $GAIAD_HOME --keyring-backend test

echo '[INFO] Initializing Osmosis Network...'
cp ibc-testbed/genesis_config/osmosisd.json $OSMOSISD_HOME/config/genesis.json
osmosisd add-genesis-account $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) 1000000000000000uosmo --home $OSMOSISD_HOME
osmosisd gentx $IBC_KEY 1000000000000uosmo --chain-id=$OSMOSIS_CHAIN_ID --home $OSMOSISD_HOME --keyring-backend test
osmosisd collect-gentxs --home $OSMOSISD_HOME

echo '[INFO] Initializing Lum Network...'
cp ibc-testbed/genesis_config/lumd.json $LUMD_HOME/config/genesis.json
lumd add-genesis-account $(lumd keys show $IBC_KEY -a --home $LUMD_HOME --keyring-backend test) 1000000000000000ulum --home $LUMD_HOME
lumd gentx $IBC_KEY 1000000000000ulum --chain-id=$LUM_CHAIN_ID --home $LUMD_HOME
lumd collect-gentxs --home $LUMD_HOME

echo '[INFO] Initializing Ki Network...'
cp ibc-testbed/genesis_config/kid.json $KID_HOME/config/genesis.json
kid add-genesis-account $(kid keys show $IBC_KEY -a --home $KID_HOME --keyring-backend test) 1000000000000000uxki --home $KID_HOME
kid gentx $IBC_KEY 1000000000000uxki --chain-id=$KI_CHAIN_ID --home $KID_HOME --keyring-backend test
kid collect-gentxs --home $KID_HOME

echo '[INFO] Initializing Cosmos Network...'
cp ibc-testbed/genesis_config/gaiad.json $GAIAD_HOME/config/genesis.json
gaiad add-genesis-account $(gaiad keys show $IBC_KEY -a --home $GAIAD_HOME --keyring-backend test) 1000000000000000uatom --home $GAIAD_HOME
gaiad gentx $IBC_KEY 1000000000000uatom --chain-id=$COSMOS_CHAIN_ID --home $GAIAD_HOME --keyring-backend test
gaiad collect-gentxs --home $GAIAD_HOME

echo '[INFO] Initializing relayer confg and wallets...'
rly config init --home $RELAYER_HOME
cp ibc-testbed/relayer/config.yaml $RELAYER_HOME/config/config.yaml
rly keys add $OSMOSIS_CHAIN_ID $RLY_KEY --home $RELAYER_HOME
rly keys add $LUM_CHAIN_ID $RLY_KEY --home $RELAYER_HOME
rly keys add $KI_CHAIN_ID $RLY_KEY --home $RELAYER_HOME
rly keys add $COSMOS_CHAIN_ID $RLY_KEY --home $RELAYER_HOME
