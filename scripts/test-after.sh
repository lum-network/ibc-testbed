##
## To run after the test suite either succeeded or failed
##

. .env

echo '[INFO] Stopping networks daemons...'
sh scripts/stop-daemons.sh
