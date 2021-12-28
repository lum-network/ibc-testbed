##
## Test suite
##

echo 'Initializing environment...'
. ibc-testbed/.env

echo 'Initializing networks...'
sh init.sh

echo 'Starting networks...'
sh run-networks.sh

echo 'Seeding relayer wallets...'
sh seed-relayer.sh

echo '== TEST SUITE - START =='

##
## TODO
##

echo '== TEST SUITE - END =='

echo 'Stopping networks...'
sh stop-networks.sh
