##
## Start networks
##

echo 'Initializing environment...'
. ibc-testbed/.env

echo 'Starting all networks...'
sudo systemctl start lumd
sudo systemctl start osmosisd
sudo systemctl start gaiad
sudo systemctl start kid
