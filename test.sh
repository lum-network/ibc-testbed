##
## Test suite
##

echo '[INFO] Initializing environment...'
. ibc-testbed/.env

echo '[INFO] Initializing networks...'
if sh ibc-testbed/init.sh >/dev/null 2>&1; then
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

echo '[INFO] Initializing relayers...'
if sh ibc-testbed/init-relayers.sh >/dev/null 2>&1; then
    echo '[INFO] Relayers initialization succeeded'
else
    echo '[ERROR] Relayers initialization failed'
    sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1
    exit 1
fi

echo '== TEST SUITE - START =='

## TODO
##

echo '== TEST SUITE - END =='

echo 'Stopping networks and relayers daemons...'
sh ibc-testbed/stop-daemons.sh >/dev/null 2>&1

exit 0
