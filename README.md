# eth-explore
Exploration of private ethereum network with contract creation and execution.

The *initial* goal is to create a network, store a contract, and execute the contract.

## Approach

Use the [Docker Ethereum Go Client](https://hub.docker.com/r/ethereum/client-go/) to create a private network.

Follow the instructions on the docker client above in addition to the [Private Network Guide](https://geth.ethereum.org/docs/interface/private-network).

**Note:** The private test network is being created before [The Merge](https://geth.ethereum.org/docs/interface/merge), and initially will not include any [concensus client](https://geth.ethereum.org/docs/interface/consensus-clients).  It will also use miners instead of Validators.

## How to run
- docker pull ethereum/client-go
- Update the <em>private-network\cfg\notsecret.txt</em> with a different value if you so desire.

### Initializing
- run then <em>account new</em> line from the <em>initialize-network.ps1</em>.  Run that more than once if you like.
- copy the <em>genesis-example.json</em> file and save it as <em>genesis.json</em>
- update genesis.json
    - update account opening balance section (<em>alloc</em>) with the account(s) from the account new output addresses as above.
    - update the <em>extraData</em> (used for Clique consensus) with an account from above, replacing the text <em>account-output-1</em> with the account value (sans 0x prefix)
- run the rest of the commands in <em>initialize-network.ps1</em> to init the desired nodes with the genesis.json updated above

### Running
- run the commands from the <em>start-network.ps1</em> powershell script.  you may prefer to run these independently as interactive to see the outputs in different consoles.
- edit and run the <em>src\rpc-json\calls.py</em> commands to interact with the network

### Commands and Notes

#### Commands
> Override entrypoint (geth by default) and launch container with shell:   <em>docker run -it --entrypoint sh ethereum/client-go</em>
> 

#### Notes
> <em>--http.addr 0.0.0.0</em> allows RPCs from other containers and/or hosts.  Otherwise, geth binds to localhost and isn't accessible.  
> The bootnode executable from the go-ethereum project is not in the client-go docker container.  Therefore, geth client is used to create bootnode.  
> RE: bootnode executable, the [alltools image](https://geth.ethereum.org/docs/install-and-build/installing-geth#run-inside-docker-container) may actually contain bootnode.  
> Clique consensus algorithm is preferred for private networks since it's Proof-of-Authority (PoA) and doesn't require resource-intensive miners as are needed in Proof-of-Work (PoW).  
> [Postman Ethereum JSON-RPC](https://documenter.getpostman.com/view/4117254/ethereum-json-rpc/RVu7CT5J#7218b6e7-5e7f-da59-fe48-17838cce9731) has some good examples.  