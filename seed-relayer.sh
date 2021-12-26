##
## Seed relayer wallets
##

echo 'Initializing environment...'
. ibc-testbed/.env

echo 'Sending 1000 LUM to relayer...'
lumd tx bank send $(lumd keys show $IBC_KEY -a --home $LUMD_HOME --keyring-backend test) $(rly keys show $LUM_CHAIN_ID $RLY_KEY --home $RELAYER_HOME) 1000000000ulum --chain-id $LUM_CHAIN_ID --home $LUMD_HOME --keyring-backend test --node $LUM_RPC --yes
