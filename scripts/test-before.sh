##
## To run before the test suite in order to prepare everything
##

. ./.env

echo '[INFO] Initializing networks...'
if sh scripts/init.sh >/dev/null 2>&1; then
    echo '[INFO] Network initialized with success'
else
    echo '[ERROR] Failed to initialize networks'
    exit 1
fi

echo '[INFO] Starting networks daemons...'
sh scripts/start-daemons.sh >/dev/null 2>&1

echo '[INFO] Waiting for networks to be up and running...'
if sh scripts/wait-networks.sh >/dev/null 2>&1; then
    echo '[INFO] Networks are up and running'
else
    echo '[ERROR] Waiting for networks timed out'
    exit 1
fi

echo '[INFO] Initializing relayers (will take a while)...'
if sh scripts/init-relayers.sh >/dev/null 2>&1; then
    echo '[INFO] Relayers initialization succeeded'
else
    echo '[ERROR] Relayers initialization failed'
    exit 1
fi

exit 0
