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
# if sh ibc-testbed/init-relayers.sh >/dev/null 2>&1; then
#     echo '[INFO] Relayers initialization succeeded'
# else
#     echo '[ERROR] Relayers initialization failed'
#     sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
#     exit 1
# fi

echo '[INFO] Transferring coins from Lum to Osmosis (should work)...'
if lumd tx ibc-transfer transfer transfer channel-0 $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) 1000ulum --from $IBC_KEY --keyring-backend test --home $LUMD_HOME --chain-id $LUM_CHAIN_ID --output text --yes | grep "code: 0"; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Transferring coins from Ki to Osmosis (should work)...'
if kid tx ibc-transfer transfer transfer channel-0 $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) 1000uxki --from $IBC_KEY --keyring-backend test --home $KID_HOME --chain-id $KI_CHAIN_ID --output text --yes | grep "code: 0"; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Transferring coins from Cosmos to Osmosis (should work)...'
if gaiad tx ibc-transfer transfer transfer channel-0 $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) 1000uatom --from $IBC_KEY --keyring-backend test --home $GAIAD_HOME --chain-id $COSMOS_CHAIN_ID --output text --yes | grep "code: 0"; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Stopping Lum <> Osmosis relayer and waiting for the client to expire...'
# sudo systemctl stop rly-lum-osmosis
# sleep 120

echo '[INFO] Transferring coins from Lum to Osmosis (should NOT work)...'
if lumd tx ibc-transfer transfer transfer channel-0 $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) 1000ulum --from $IBC_KEY --keyring-backend test --home $LUMD_HOME --chain-id $LUM_CHAIN_ID --output text --yes | grep "code: 0"; then
    echo "[ERROR] Transaction accepted"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
else
    echo "[INFO] Transaction rejected as expected"
fi

echo '[INFO] Transferring coins from Ki to Osmosis (should work)...'
if kid tx ibc-transfer transfer transfer channel-0 $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) 1000uxki --from $IBC_KEY --keyring-backend test --home $KID_HOME --chain-id $KI_CHAIN_ID --output text --yes | grep "code: 0"; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Transferring coins from Cosmos to Osmosis (should work)...'
if gaiad tx ibc-transfer transfer transfer channel-0 $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) 1000uatom --from $IBC_KEY --keyring-backend test --home $GAIAD_HOME --chain-id $COSMOS_CHAIN_ID --output text --yes | grep "code: 0"; then
    echo "[INFO] Transaction accepted"
else
    echo "[ERROR] Transaction rejected"
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '[INFO] Running gov proposal on Osmosis to revive Lum <> Osmosis relayer...'
#TODO - gov prop + vote

echo '[INFO] Transferring coins from Lum to Osmosis (should work)...'
#TODO - should work

echo '[INFO] Transferring coins from Ki to Osmosis (should work)...'
#TODO - should work

echo '[INFO] Transferring coins from Cosmos to Osmosis (should work)...'
#TODO - should work

echo '[INFO] Stopping networks and relayers daemons...'
sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1

exit 0
