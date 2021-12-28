##
## Seed relayer wallets
##

. ibc-testbed/.env

echo 'Sending 1000 OSMO to relayer...'
osmosisd tx bank send $(osmosisd keys show $IBC_KEY -a --home $OSMOSISD_HOME --keyring-backend test) $(rly keys show $OSMOSIS_CHAIN_ID $RLY_KEY --home $RELAYER_HOME) 1000000000uosmo --chain-id $OSMOSIS_CHAIN_ID --home $OSMOSISD_HOME --keyring-backend test --node $OSMOSIS_RPC --yes

echo 'Sending 1000 XKI to relayer...'
kid tx bank send $(kid keys show $IBC_KEY -a --home $KID_HOME --keyring-backend test) $(rly keys show $KI_CHAIN_ID $RLY_KEY --home $RELAYER_HOME) 1000000000uxki --chain-id $KI_CHAIN_ID --home $KID_HOME --keyring-backend test --node $KI_RPC --yes

echo 'Sending 1000 ATOM to relayer...'
gaiad tx bank send $(gaiad keys show $IBC_KEY -a --home $GAIAD_HOME --keyring-backend test) $(rly keys show $COSMOS_CHAIN_ID $RLY_KEY --home $RELAYER_HOME) 1000000000uatom --chain-id $COSMOS_CHAIN_ID --home $GAIAD_HOME --keyring-backend test --node $COSMOS_RPC --yes

echo 'Sending 1000 LUM to relayer...'
lumd tx bank send $(lumd keys show $IBC_KEY -a --home $LUMD_HOME --keyring-backend test) $(rly keys show $LUM_CHAIN_ID $RLY_KEY --home $RELAYER_HOME) 1000000000ulum --chain-id $LUM_CHAIN_ID --home $LUMD_HOME --keyring-backend test --node $LUM_RPC --yes
