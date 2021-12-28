##
## Init relayer paths
##

. ibc-testbed/.env

echo 'Initializing Lum <> Osmosis relayer...'
rly paths generate $LUM_CHAIN_ID $OSMOSIS_CHAIN_ID lum-osmosis --home $RELAYER_HOME
rly tx clients lum-osmosis --home $RELAYER_HOME
sleep 5
rly tx connection lum-osmosis --home $RELAYER_HOME
sleep 5
rly tx link lum-osmosis --home $RELAYER_HOME

echo 'Initializing Ki <> Osmosis relayer...'
rly paths generate $KI_CHAIN_ID $OSMOSIS_CHAIN_ID ki-osmosis --home $RELAYER_HOME
rly tx clients ki-osmosis --home $RELAYER_HOME
sleep 5
rly tx connection ki-osmosis --home $RELAYER_HOME
sleep 5
rly tx link ki-osmosis --home $RELAYER_HOME

echo 'Initializing Cosmos <> Osmosis relayer...'
rly paths generate $COSMOS_CHAIN_ID $OSMOSIS_CHAIN_ID cosmos-osmosis --home $RELAYER_HOME
rly tx clients cosmos-osmosis --home $RELAYER_HOME
sleep 5
rly tx connection cosmos-osmosis --home $RELAYER_HOME
sleep 5
rly tx link cosmos-osmosis --home $RELAYER_HOME
