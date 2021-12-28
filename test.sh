##
## Test suite
##

echo '[INFO] Initializing environment...'
. ibc-testbed/.env

echo '[INFO] Initializing networks...'
if sh ibc-testbed/init.sh &>/dev/null; then
    echo '[ERROR] Failed to initialize networks'
    exit 1
fi

echo 'Starting networks...'
sh ibc-testbed/run-networks.sh &>/dev/null

echo 'Waiting for networks to be up and running...'
if sh ibc-testbed/wait-networks.sh &>/dev/null; then
    echo '[ERROR] Waiting for networks timed out'
    sh ibc-testbed/stop-networks.sh &>/dev/null
    exit 1
fi

echo 'Seeding relayer wallets...'
if sh ibc-testbed/seed-relayer.sh &>/dev/null; then
    echo '[ERROR] Relayer wallets seed failed'
    sh ibc-testbed/stop-networks.sh &>/dev/null
    exit 1
fi

echo '== TEST SUITE - START =='

##
## TODO
##

echo '== TEST SUITE - END =='

echo 'Stopping networks...'
sh ibc-testbed/stop-networks.sh &>/dev/null

exit 0
