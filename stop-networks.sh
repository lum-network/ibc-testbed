##
## Stop networks
##

echo 'Initializing environment...'
. ibc-testbed/.env

echo 'Stopping all networks...'
sudo systemctl stop lumd
sudo systemctl stop osmosisd
sudo systemctl stop gaiad
sudo systemctl stop kid
