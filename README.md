# eth-explore
Exploration of private ethereum network with contract creation and execution.

The *initial* goal is to create a network, store a contract, and execute the contract.

## Approach

Use the [Docker Ethereum Go Client](https://hub.docker.com/r/ethereum/client-go/) to create a private network.

Follow the instructions on the docker client above in addition to the [Private Network Guide](https://geth.ethereum.org/docs/interface/private-network).

**Note:** The private test network is being created before [The Merge](https://geth.ethereum.org/docs/interface/merge), and initially will not include any [concensus client](https://geth.ethereum.org/docs/interface/consensus-clients).  It will also use miners instead of Validators.

### Commands and Notes

#### Commands
> Override entrypoint (geth by default) and launch container with shell:   <em>docker run -it --entrypoint sh ethereum/client-go</em>
> 

#### Notes
> <em>--http.addr 0.0.0.0</em> allows RPCs from other containers and/or hosts.  Otherwise, geth binds to localhost and isn't accessible.  
> The bootnode executable from the go-ethereum project is not in the client-go docker container.  Therefore, geth client is used to create bootnode.  
> Clique consensus algorithm is preferred for private networks since it's Proof-of-Authority (PoA) and doesn't require resource-intensive miners as are needed in Proof-of-Work (PoW).  