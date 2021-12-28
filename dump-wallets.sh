##
## Debug - Dump test wallets
##

echo '[INFO] Initializing environment...'
. ibc-testbed/.env

echo '[DEBUG] Lum wallet:'
lumd query bank balances $(lumd keys show $IBC_KEY -a --home $LUMD_HOME --keyring-backend test) --node $LUM_RPC
echo '[DEBUG] Osmosis wallet:'
osmosisd query bank balances $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --node $OSMOSIS_RPC
echo '[DEBUG] Ki wallet:'
kid query bank balances $(kid keys show $IBC_KEY -a --home $KID_HOME --keyring-backend test) --node $KI_RPC
echo '[DEBUG] Cosmos wallet:'
gaiad query bank balances $(gaiad keys show $IBC_KEY -a --home $GAIAD_HOME --keyring-backend test) --node $COSMOS_RPC
