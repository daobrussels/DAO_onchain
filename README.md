# BrusselsDAO

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```


https://book.getfoundry.sh/getting-started/installation

Prerequisits 

curl -L https://foundry.paradigm.xyz | bash

rustup update stable


Run anvil

$anvil

commands 


To Deploy 
$ forge script script/Starter.s.sol --fork-url http://localhost:8545 --broadcast -vvv


Register Stewards

´´´
$ cast send --rpc-url=http://localhost:8545 0x5FbDB2315678afecb367f032d93F642f64180aa3  "registerSteward(address)" 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

blockHash               0x71b22d74424b46339291e1e4c76e71b443880f6de03358c5be9b8268189965d0
blockNumber             2
contractAddress
cumulativeGasUsed       46327
effectiveGasPrice       3881834334
from                    0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
gasUsed                 46327
logs                    []
logsBloom               0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
root
status                  1
transactionHash         0xca2ef97558d925cb6a116a590f4d29d8dbba484ed3ed70007e19f760d47f9208
transactionIndex        0
type                    2
to                      0x5fbd…0aa3
´´´

