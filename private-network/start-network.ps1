### Start the bootnode -- networkid is the same as the chainId in the genesis.json
docker run -it -v ${PWD}/cfg:/cfg -v ${PWD}/datadir/bootnode:/datadir --hostname eth-bootnode --network private-eth-network ethereum/client-go --datadir /datadir --networkid 56472 --netrestrict="10.20.30.0/24" --nodiscover  --ipcdisable  # these last 2 are for efficiency

### Start a client as RPC endpoint (uses enode from output of above)
### NOTE:  do NOT include the "?discport=0" part of the enode or you get a UDP port error
docker run -it -v ${PWD}/cfg:/cfg -v ${PWD}/datadir/rpc:/datadir -p 8545:8545 --network private-eth-network ethereum/client-go --datadir /datadir --bootnodes="enode://2e0cccd09a94ea04c59724ae16c0393e21937924b57b8f627242c8a721e1e79a8b32286e495688aae720b443264bf63a0806bb40f20db79a385dc82d44d79180@eth-bootnode:30303" --http --http.addr="0.0.0.0" --http.api="eth,web3,net,admin,personal" --http.corsdomain="*" --netrestrict="10.20.30.0/24" --networkid=56472

