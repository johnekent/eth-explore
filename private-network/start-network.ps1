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
sudo docker run -${RUN_MODE} --name eth-bootnode -v ${PWD}/cfg:/cfg -v ${PWD}/datadir/bootnode:/datadir --hostname eth-bootnode --network private-eth-network ethereum/client-go --datadir /datadir --networkid 56472 --nodekeyhex="d50ceb3fc1910f17457f5f86586ced45f7b740ad1573f4aa2d19e5095ee24454" --netrestrict="10.20.30.0/24" --nodiscover  --ipcdisable  # these last 2 are for efficiency

### Start a client as RPC endpoint (uses enode from output of above)
### NOTE:  do NOT include the "?discport=0" part of the enode or you get a UDP port error
### NOTE:  this uses the dangerous --allow-insecure-unlock to allow for unlocking of accounts through the HTTP
docker stop eth-rpc
docker rm eth-rpc
docker run -${RUN_MODE} --name eth-rpc -v ${PWD}/cfg:/cfg -v ${PWD}/datadir/rpc:/datadir -p 8545:8545 --hostname eth-rpc --network private-eth-network ethereum/client-go --datadir /datadir --bootnodes="enode://77cc6d8bba7e06f83a0496cfa6b564d2aa47c8ba92194e86023fb4784f468bd5157d923802bcffbe25fa4fa64816049753ddadefcfd8325c190c8ba2a0fd5693@eth-bootnode:30303" --http --http.addr="0.0.0.0" --http.api="eth,web3,net,admin,personal" --http.corsdomain="*" --netrestrict="10.20.30.0/24" --networkid=56472 --allow-insecure-unlock

## Start nodes
docker stop eth-node1
docker rm eth-node1
docker run -${RUN_MODE} --name eth-node1 -v ${PWD}/cfg:/cfg -v ${PWD}/datadir/node1:/datadir --hostname eth-node1 --network private-eth-network ethereum/client-go --datadir /datadir --bootnodes="enode://77cc6d8bba7e06f83a0496cfa6b564d2aa47c8ba92194e86023fb4784f468bd5157d923802bcffbe25fa4fa64816049753ddadefcfd8325c190c8ba2a0fd5693@eth-bootnode:30303" --netrestrict="10.20.30.0/24" --networkid=56472
