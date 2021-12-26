##
## Initialize relayer
##

echo 'Initializing environment...'
. ibc-testbed/.env

echo 'Configuring relayer...'
rly config init --home $RELAYER_HOME
cp ibc-testbed/relayer/config.yaml $RELAYER_HOME/config/config.yaml
rly keys add lum-ibctest-1 rly-testbed-key --home $RELAYER_HOME
rly keys add osmosis-ibctest-1 rly-testbed-key --home $RELAYER_HOME
rly keys add ki-ibctest-1 rly-testbed-key --home $RELAYER_HOME
rly keys add cosmos-ibctest-1 rly-testbed-key --home $RELAYER_HOME
