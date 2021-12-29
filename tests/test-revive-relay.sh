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

echo '[INFO] Waiting for the Lum <> Osmosis client to expire...'
rly tx update-clients ki-osmosis --home $RELAYER_HOME
rly tx update-clients cosmos-osmosis --home $RELAYER_HOME
sleep 300
rly tx update-clients ki-osmosis --home $RELAYER_HOME
rly tx update-clients cosmos-osmosis --home $RELAYER_HOME

echo '[INFO] Transferring coins from Lum to Osmosis (should NOT work)...'
if rly tx transfer $LUM_CHAIN_ID $OSMOSIS_CHAIN_ID 1ulum $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path lum-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[ERROR] Transaction accepted"
    exit 1
else
    echo "[INFO] Transaction rejected as expected"
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
if rly tx relay-packets ki-osmosis --home $RELAYER_HOME >/dev/null 2>&1 && rly tx relay-packets cosmos-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Relaying done"
else
    echo "[ERROR] Relaying failed"
    exit 1
fi

echo '[INFO] Running gov proposal on Osmosis to revive Lum <> Osmosis relayer...'
#TODO - gov prop + vote

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

echo '[DEBUG] Dumping test wallets'
sh scripts/dump-wallets.sh
