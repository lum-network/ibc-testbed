##
## Wait for networks to be up and running
##

. ibc-testbed/.env

COUNT=30
while [ $COUNT -ge 0 ]; do
    OK=0
    if lumd status --node $LUM_RPC &>/dev/null; then
        ((OK++))
    fi
    if osmosisd status --node $OSMOSIS_RPC &>/dev/null; then
        ((OK++))
    fi
    if kid status --node $KID_RPC &>/dev/null; then
        ((OK++))
    fi
    if gaiad status --node $COSMOS_RPC &>/dev/null; then
        ((OK++))
    fi

    if [[ $OK == 4 ]]; then
        exit 0
    fi

    ((COUNT--))
    sleep 1
done

exit 1
