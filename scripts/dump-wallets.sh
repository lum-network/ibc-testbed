##
## Debug - Dump test wallets
##

. .env

echo '[DEBUG] Osmosis wallet (chain): $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test)'
osmosisd query bank balances $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) --node $OSMOSIS_RPC
echo '[DEBUG] Lum wallet (chain): '$(lumd keys show $IBC_KEY -a --home $LUMD_HOME --keyring-backend test)
lumd query bank balances $(lumd keys show $IBC_KEY -a --home $LUMD_HOME --keyring-backend test) --node $LUM_RPC
echo '[DEBUG] Ki wallet (chain): $(kid keys show $IBC_KEY -a --home $KID_HOME --keyring-backend test)'
kid query bank balances $(kid keys show $IBC_KEY -a --home $KID_HOME --keyring-backend test) --node $KI_RPC
echo '[DEBUG] Cosmos wallet (chain): $(gaiad keys show $IBC_KEY -a --home $GAIAD_HOME --keyring-backend test)'
gaiad query bank balances $(gaiad keys show $IBC_KEY -a --home $GAIAD_HOME --keyring-backend test) --node $COSMOS_RPC
