##
## Test suite
## Will make the Lum <> Osmosis IBC client expire and run a gov prop
## to revive this client
##

. ./.env

echo '[INFO] Transferring coins from Lum to Osmosis (should work)...'
if rly tx transfer $LUM_CHAIN_ID $OSMOSIS_CHAIN_ID 1ulum $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path lum-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    exit 1
fi

echo '[INFO] Transferring coins from Ki to Osmosis (should work)...'
if rly tx transfer $KI_CHAIN_ID $OSMOSIS_CHAIN_ID 1uxki $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path ki-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    exit 1
fi

echo '[INFO] Transferring coins from Cosmos to Osmosis (should work)...'
if rly tx transfer $COSMOS_CHAIN_ID $OSMOSIS_CHAIN_ID 1uatom $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path cosmos-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    exit 1
fi

echo '[INFO] Relay packets manually...'
if rly tx relay-packets lum-osmosis --home $RELAYER_HOME >/dev/null 2>&1 && rly tx relay-packets ki-osmosis --home $RELAYER_HOME >/dev/null 2>&1 && rly tx relay-packets cosmos-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Relaying done"
else
    echo "[ERROR] Relaying failed"
    exit 1
fi

echo '[INFO] Waiting 5min for the Lum <> Osmosis client to expire...'
sleep 300

echo '[INFO] Transferring coins from Lum to Osmosis (should NOT work)...'
if rly tx transfer $LUM_CHAIN_ID $OSMOSIS_CHAIN_ID 1ulum $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path lum-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    exit 1
fi

echo '[INFO] Transferring coins from Ki to Osmosis (should work)...'
if rly tx transfer $KI_CHAIN_ID $OSMOSIS_CHAIN_ID 1uxki $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path ki-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    exit 1
fi

echo '[INFO] Transferring coins from Cosmos to Osmosis (should work)...'
if rly tx transfer $COSMOS_CHAIN_ID $OSMOSIS_CHAIN_ID 1uatom $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path cosmos-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    exit 1
fi

echo '[INFO] Relay packets between Lum <> Osmosis should not work...'
if rly tx raw update-client $OSMOSIS_CHAIN_ID $LUM_CHAIN_ID 07-tendermint-2 --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[ERROR] Relaying is supposedly working but should not be"
    exit 1
else
    echo "[INFO] Relaying not working as expected"
fi

echo '[INFO] Relay packets manually...'
if rly tx relay-packets ki-osmosis --home $RELAYER_HOME >/dev/null 2>&1 && rly tx relay-packets cosmos-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Relaying done"
else
    echo "[ERROR] Relaying failed"
    exit 1
fi

echo '[INFO] Creating and updating new substitute client to replace the expired one...'
rly tx raw client $OSMOSIS_CHAIN_ID $LUM_CHAIN_ID 07-tendermint-3 --home $RELAYER_HOME >/dev/null 2>&1
sleep 5
rly tx raw update-client $OSMOSIS_CHAIN_ID $LUM_CHAIN_ID 07-tendermint-3 --home $RELAYER_HOME >/dev/null 2>&1

echo '[INFO] Running gov proposal on Osmosis to revive Lum <> Osmosis relayer...'
osmosisd tx gov submit-proposal update-client 07-tendermint-2 07-tendermint-3 --deposit 1000uosmo --title "update" --description "upt clt" --from $IBC_KEY --home $OSMOSISD_HOME --keyring-backend test --broadcast-mode block --chain-id $OSMOSIS_CHAIN_ID --node $OSMOSIS_RPC --yes >/dev/null 2>&1
osmosisd tx gov vote 1 yes --from $IBC_KEY --home $OSMOSISD_HOME --keyring-backend test --broadcast-mode block --chain-id $OSMOSIS_CHAIN_ID --node $OSMOSIS_RPC --yes >/dev/null 2>&1

echo '[INFO] Waiting '$GOV_VOTE_DURATION's for the proposal to pass...'
sleep $GOV_VOTE_DURATION

echo '[INFO] Updating substitute client...'
rly tx raw update-client $OSMOSIS_CHAIN_ID $LUM_CHAIN_ID 07-tendermint-3 --home $RELAYER_HOME

echo '[INFO] Transferring coins from Lum to Osmosis (should work)...'
if rly tx transfer $LUM_CHAIN_ID $OSMOSIS_CHAIN_ID 1ulum $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path lum-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    exit 1
fi

echo '[INFO] Transferring coins from Ki to Osmosis (should work)...'
if rly tx transfer $KI_CHAIN_ID $OSMOSIS_CHAIN_ID 1uxki $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path ki-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    exit 1
fi

echo '[INFO] Transferring coins from Cosmos to Osmosis (should work)...'
if rly tx transfer $COSMOS_CHAIN_ID $OSMOSIS_CHAIN_ID 1uatom $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path cosmos-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    exit 1
fi

echo '[INFO] Relay packets manually...'
if rly tx relay-packets lum-osmosis --home $RELAYER_HOME >/dev/null 2>&1 && rly tx relay-packets ki-osmosis --home $RELAYER_HOME >/dev/null 2>&1 && rly tx relay-packets cosmos-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Relaying done"
else
    echo "[ERROR] Relaying failed"
    exit 1
fi

echo '[DEBUG] Dumping test wallets (Osmosis wallet should have 3 ibc denom with 3 coins each)'
sh scripts/dump-wallets.sh
