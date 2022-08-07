### For powershell, first run this command
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

### whether to run detached or interactive
Set-Variable -Name RUN_MODE -Value it   #interactive
#Set-Variable -Name RUN_MODE -Value d     #detached

##
echo "Run Mode is ${RUN_MODE}"

### Start the bootnode -- networkid is the same as the chainId in the genesis.json
docker stop eth-bootnode
docker rm eth-bootnode
docker run -${RUN_MODE} --name eth-bootnode -v ${PWD}/cfg:/cfg -v ${PWD}/datadir/bootnode:/datadir --hostname eth-bootnode --network private-eth-network ethereum/client-go --datadir /datadir --networkid 56472 --netrestrict="10.20.30.0/24" --nodiscover  --ipcdisable  # these last 2 are for efficiency

### Start a client as RPC endpoint (uses enode from output of above)
### NOTE:  do NOT include the "?discport=0" part of the enode or you get a UDP port error
docker stop eth-rpc
docker rm eth-rpc
docker run -${RUN_MODE} --name eth-rpc -v ${PWD}/cfg:/cfg -v ${PWD}/datadir/rpc:/datadir -p 8545:8545 --hostname eth-rpc --network private-eth-network ethereum/client-go --datadir /datadir --bootnodes="enode://35c59479863896a3cb29177a7ebdf668bd9ced7bf8219e1740860738b753c9e134dfd63337265da16d5d0a2fd1f425a97472176395cbb9eb6b569a0cacf62eff@eth-bootnode:30303" --http --http.addr="0.0.0.0" --http.api="eth,web3,net,admin,personal" --http.corsdomain="*" --netrestrict="10.20.30.0/24" --networkid=56472

## Start nodes
docker stop eth-node1
docker rm eth-node1
docker run -${RUN_MODE} --name eth-node1 -v ${PWD}/cfg:/cfg -v ${PWD}/datadir/node1:/datadir --hostname eth-node1 --network private-eth-network ethereum/client-go --datadir /datadir --bootnodes="enode://35c59479863896a3cb29177a7ebdf668bd9ced7bf8219e1740860738b753c9e134dfd63337265da16d5d0a2fd1f425a97472176395cbb9eb6b569a0cacf62eff@eth-bootnode:30303" --netrestrict="10.20.30.0/24" --networkid=56472
