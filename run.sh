##
## Run the customized tests
## - prepare test env
## - run test
## - clean up test env
##

. ./.env

if [ $# -le 0 ]; then
    echo '$> sh run.sh [test-name]'
    exit 1
fi

if sh scripts/test-before.sh; then
    echo '[INFO][run] Before test preparation success'
else
    echo "[ERROR][run] Before test preparation failed"
    sh scripts/test-after.sh >/dev/null 2>&1
    exit 1
fi

if sh "tests/"$1".sh"; then
    echo '[INFO][run] Test suite succeeded'
else
    echo "[ERROR][run] Test suite failed"
fi

if sh scripts/test-after.sh; then
    echo '[INFO][run] After test clean up success'
else
    echo "[ERROR][run] After test clean up failed"
    exit 1
fi

exit 0
