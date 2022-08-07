### For powershell, first run this command
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

### Run setup commands.

### create a network to use for connectivity between components  (this creates it in the local machine environment -- only need to run once)
docker network create -d=bridge --subnet=10.20.30.0/24 private-eth-network
#  -- 5abc5e5b233e6693e92a7d5a7b3dbef6afab69cbe1ffa56da655bed565c32407

### This generates output that must be updated in genesis.json

### Create an account -- this creates output in the datadir
docker run -it -v ${PWD}/cfg:/cfg -v ${PWD}/datadir/rpc:/datadir ethereum/client-go account new --password /cfg/notsecret.txt --datadir /datadir

### Initialize nodes -- this creates output in the datadir
docker run -it -v ${PWD}/cfg:/cfg -v ${PWD}/datadir/rpc:/datadir ethereum/client-go init --datadir /datadir /cfg/genesis.json

docker run -it -v ${PWD}/cfg:/cfg -v ${PWD}/datadir/node1:/datadir ethereum/client-go init --datadir /datadir /cfg/genesis.json

### Initialize the boot node
docker run -it -v ${PWD}/cfg:/cfg -v ${PWD}/datadir/bootnode:/datadir ethereum/client-go  init --datadir /datadir /cfg/genesis.json

