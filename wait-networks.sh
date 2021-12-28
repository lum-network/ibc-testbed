##
## Wait for networks to be up and running
##

. ibc-testbed/.env

i=30
while [ $i -ge 0 ]; do
    ok=0
    if lumd query block --node $LUM_RPC >/dev/null 2>&1; then
        ok=$((ok + 1))
    fi
    if osmosisd query block --node $OSMOSIS_RPC >/dev/null 2>&1; then
        ok=$((ok + 1))
    fi
    if kid query block --node $KI_RPC >/dev/null 2>&1; then
        ok=$((ok + 1))
    fi
    if gaiad query block --node $COSMOS_RPC >/dev/null 2>&1; then
        ok=$((ok + 1))
    fi

    if [ "$ok" = "4" ]; then
        exit 0
    fi

    i=$((i - 1))
    sleep 1
done

exit 1
