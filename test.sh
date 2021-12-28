##
## Test suite
##

echo 'Initializing environment...'
. ibc-testbed/.env

echo 'Initializing networks...'
sh ibc-testbed/init.sh

echo 'Starting networks...'
sh ibc-testbed/run-networks.sh

echo 'Seeding relayer wallets...'
sh ibc-testbed/seed-relayer.sh

echo '== TEST SUITE - START =='

##
## TODO
##

echo '== TEST SUITE - END =='

echo 'Stopping networks...'
sh ibc-testbed/stop-networks.sh
