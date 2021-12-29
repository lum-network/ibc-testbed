##
## Init relayers wallets and paths
##

. .env

echo '[INFO] Sending 1Mi OSMO to relayer...'
osmosisd tx bank send $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) $(rly keys show $OSMOSIS_CHAIN_ID $RLY_KEY --home $RELAYER_HOME) 1000000000000uosmo --chain-id $OSMOSIS_CHAIN_ID --home $OSMOSISD_HOME --keyring-backend test --node $OSMOSIS_RPC --yes

echo '[INFO] Sending 1Mi LUM to relayer...'
lumd tx bank send $(lumd keys show $IBC_KEY -a --home $LUMD_HOME --keyring-backend test) $(rly keys show $LUM_CHAIN_ID $RLY_KEY --home $RELAYER_HOME) 1000000000000ulum --chain-id $LUM_CHAIN_ID --home $LUMD_HOME --keyring-backend test --node $LUM_RPC --yes

echo '[INFO] Sending 1Mi XKI to relayer...'
kid tx bank send $(kid keys show $IBC_KEY -a --home $KID_HOME --keyring-backend test) $(rly keys show $KI_CHAIN_ID $RLY_KEY --home $RELAYER_HOME) 1000000000000uxki --chain-id $KI_CHAIN_ID --home $KID_HOME --keyring-backend test --node $KI_RPC --yes

echo '[INFO] Sending 1Mi ATOM to relayer...'
gaiad tx bank send $(gaiad keys show $IBC_KEY -a --home $GAIAD_HOME --keyring-backend test) $(rly keys show $COSMOS_CHAIN_ID $RLY_KEY --home $RELAYER_HOME) 1000000000000uatom --chain-id $COSMOS_CHAIN_ID --home $GAIAD_HOME --keyring-backend test --node $COSMOS_RPC --yes

echo '[INFO] Initializing Lum <> Osmosis relayer...'
rly paths generate $LUM_CHAIN_ID $OSMOSIS_CHAIN_ID lum-osmosis --home $RELAYER_HOME
rly tx clients lum-osmosis --home $RELAYER_HOME
sleep 5
rly tx connection lum-osmosis --home $RELAYER_HOME
sleep 5
rly tx link lum-osmosis --home $RELAYER_HOME

# Refresh clients to avoid unwanted timeouts
rly tx update-clients lum-osmosis --home $RELAYER_HOME

echo '[INFO] Initializing Ki <> Osmosis relayer...'
rly paths generate $KI_CHAIN_ID $OSMOSIS_CHAIN_ID ki-osmosis --home $RELAYER_HOME
rly tx clients ki-osmosis --home $RELAYER_HOME
sleep 5
rly tx connection ki-osmosis --home $RELAYER_HOME
sleep 5
rly tx link ki-osmosis --home $RELAYER_HOME

# Refresh clients to avoid unwanted timeouts
rly tx update-clients lum-osmosis --home $RELAYER_HOME
rly tx update-clients ki-osmosis --home $RELAYER_HOME

echo '[INFO] Initializing Cosmos <> Osmosis relayer...'
rly paths generate $COSMOS_CHAIN_ID $OSMOSIS_CHAIN_ID cosmos-osmosis --home $RELAYER_HOME
rly tx clients cosmos-osmosis --home $RELAYER_HOME
sleep 5
rly tx connection cosmos-osmosis --home $RELAYER_HOME
sleep 5
rly tx link cosmos-osmosis --home $RELAYER_HOME

# Refresh clients to avoid unwanted timeouts
rly tx update-clients lum-osmosis --home $RELAYER_HOME
rly tx update-clients ki-osmosis --home $RELAYER_HOME
rly tx update-clients cosmos-osmosis --home $RELAYER_HOME
