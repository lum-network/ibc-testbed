##
## Wait for networks to be up and running by querying block 1
##

. ./.env

i=60
while [ $i -ge 0 ]; do
    ok=0
    if osmosisd query block 1 --node $OSMOSIS_RPC >/dev/null 2>&1; then
        ok=$((ok + 1))
    fi
    if lumd query block 1 --node $LUM_RPC >/dev/null 2>&1; then
        ok=$((ok + 1))
    fi
    if kid query block 1 --node $KI_RPC >/dev/null 2>&1; then
        ok=$((ok + 1))
    fi
    if gaiad query block 1 --node $COSMOS_RPC >/dev/null 2>&1; then
        ok=$((ok + 1))
    fi

    if [ "$ok" = "4" ]; then
        exit 0
    fi

    i=$((i - 1))
    sleep 1
done

exit 1
