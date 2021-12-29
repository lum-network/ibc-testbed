##
## Test suite
##

echo '[INFO] Initializing environment...'
. ibc-testbed/.env

echo '[INFO] Initializing networks...'
if sh ibc-testbed/init-networks.sh >/dev/null 2>&1; then
    echo '[INFO] Network initialized with success'
else
    echo '[ERROR] Failed to initialize networks'
    exit 1
fi

echo '[INFO] Starting networks and relayers daemons...'
sh ibc-testbed/start-daemons.sh >/dev/null 2>&1

echo '[INFO] Waiting for networks to be up and running...'
if sh ibc-testbed/wait-networks.sh >/dev/null 2>&1; then
    echo '[INFO] Networks are up and running'
else
    echo '[ERROR] Waiting for networks timed out'
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Seeding relayers wallets...'
if sh ibc-testbed/seed-relayers.sh >/dev/null 2>&1; then
    echo '[INFO] Relayer wallets seed succeeded'
else
    echo '[ERROR] Relayer wallets seed failed'
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Initializing relayers (will take a while)...'
if sh ibc-testbed/init-relayers.sh >/dev/null 2>&1; then
    echo '[INFO] Relayers initialization succeeded'
else
    echo '[ERROR] Relayers initialization failed'
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Transferring coins from Lum to Osmosis (should work)...'
if rly tx transfer $LUM_CHAIN_ID $OSMOSIS_CHAIN_ID 1ulum $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path lum-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Transferring coins from Ki to Osmosis (should work)...'
if rly tx transfer $KI_CHAIN_ID $OSMOSIS_CHAIN_ID 1uxki $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path ki-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Transferring coins from Cosmos to Osmosis (should work)...'
if rly tx transfer $COSMOS_CHAIN_ID $OSMOSIS_CHAIN_ID 1uatom $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path cosmos-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Relay packets manually...'
if rly tx relay-packets lum-osmosis --home $RELAYER_HOME >/dev/null 2>&1 && rly tx relay-packets ki-osmosis --home $RELAYER_HOME >/dev/null 2>&1 && rly tx relay-packets cosmos-osmosis --home $RELAYER_HOME >/dev/null 2>&1 ; then
    echo "[INFO] Relaying done"
else
    echo "[ERROR] Relaying failed"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
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
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
else
    echo "[INFO] Transaction rejected as expected"
fi

echo '[INFO] Transferring coins from Ki to Osmosis (should work)...'
if rly tx transfer $KI_CHAIN_ID $OSMOSIS_CHAIN_ID 1uxki $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path ki-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Transferring coins from Cosmos to Osmosis (should work)...'
if rly tx transfer $COSMOS_CHAIN_ID $OSMOSIS_CHAIN_ID 1uatom $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path cosmos-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Relay packets manually...'
if rly tx relay-packets ki-osmosis --home $RELAYER_HOME >/dev/null 2>&1 && rly tx relay-packets cosmos-osmosis --home $RELAYER_HOME >/dev/null 2>&1 ; then
    echo "[INFO] Relaying done"
else
    echo "[ERROR] Relaying failed"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Running gov proposal on Osmosis to revive Lum <> Osmosis relayer...'
#TODO - gov prop + vote

echo '[INFO] Transferring coins from Lum to Osmosis (should work)...'
if rly tx transfer $LUM_CHAIN_ID $OSMOSIS_CHAIN_ID 1ulum $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path lum-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Transferring coins from Ki to Osmosis (should work)...'
if rly tx transfer $KI_CHAIN_ID $OSMOSIS_CHAIN_ID 1uxki $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path ki-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Transferring coins from Cosmos to Osmosis (should work)...'
if rly tx transfer $COSMOS_CHAIN_ID $OSMOSIS_CHAIN_ID 1uatom $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --path cosmos-osmosis --home $RELAYER_HOME >/dev/null 2>&1; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Relay packets manually...'
if rly tx relay-packets lum-osmosis --home $RELAYER_HOME >/dev/null 2>&1 && rly tx relay-packets ki-osmosis --home $RELAYER_HOME >/dev/null 2>&1 && rly tx relay-packets cosmos-osmosis --home $RELAYER_HOME >/dev/null 2>&1 ; then
    echo "[INFO] Relaying done"
else
    echo "[ERROR] Relaying failed"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[DEBUG] Dumping test wallets'
sh ibc-testbed/dump-wallets.sh

echo '[INFO] Stopping networks and relayers daemons...'
sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1

exit 0
