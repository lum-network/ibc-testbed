##
## Initialize all networks
##

IBC_TESDBED_HOME=$HOME/.ibc-testbed

lumd keys add ibc-testbed-key --home $IBC_TESDBED_HOME/lumd --keyring-backend test
osmosisd keys add ibc-testbed-key --home $IBC_TESDBED_HOME/osmosisd --keyring-backend test
kid keys add ibc-testbed-key --home $$IBC_TESDBED_HOME/kid --keyring-backend test
gaiad keys add ibc-testbed-key --home $$IBC_TESDBED_HOME/gaiad --keyring-backend test
