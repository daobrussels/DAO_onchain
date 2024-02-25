# BrusselsDAO
-----------------------------------


### Structure:
* Proposal: Represents a proposal within the DAO, including a description, vote count, funding amount, the steward responsible for the proposal, the number of unique contributors, and a mapping to track which addresses have contributed.
* Steward: Represents a steward of the DAO, with flags for registration and commitment, and a list of proposal IDs they own.
* Member: Represents a member of the DAO, including flags for registration, voting status, and the ID of the last proposal they voted on.
-----------------------------------


### Modifiers:
* onlyAdmin: Ensures that only the admin can perform certain actions.
* onlyMembers: Ensures that only registered members can perform certain actions.
* onlyStewards: Ensures that only registered stewards can perform certain actions.
-----------------------------------


### Functions:
* Constructor: Sets the contract deployer (msg.sender) as the admin of the DAO.
* isMemberRegistered: Checks if a member is registered in the DAO.
* getProposalAmount: Returns the funding amount for a specified proposal.
* registerMember: Allows a steward to register a new member.
* registerSteward: Allows the admin to register a new steward.
* createProposal: Allows a steward to create a new proposal.
* contributeToProposal: Enables members to contribute funds to a proposal.
* vote: Allows members to vote on proposals.
* canUnlockFunds: Checks if a proposal meets the criteria to unlock funds (i.e., has enough contributions, unique contributors, and votes).
* unlockFunds: Allows the steward of a proposal to unlock and distribute the funds if the criteria are met.
* receive(): A fallback function to receive ether into the contract.
-----------------------------------


### Key Concepts:
* Proposals: Proposals are central to the DAO's operation, allowing members to suggest initiatives that require funding and approval from the community.
* Voting and Contribution: Members can vote on proposals and contribute funds, which are critical for the democratic process and funding mechanism of the DAO.
* Stewards: Stewards play a significant role in managing proposals and the DAO's operations, including the ability to register members and create proposals.
* Funds Management: The DAO has mechanisms to collect contributions for proposals and criteria-based fund unlocking, enabling the execution of community-approved projects.
-----------------------------------

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

```
curl -L https://foundry.paradigm.xyz | bash
rustup update stable
```

Run anvil

`$anvil`

commands 


To Deploy 
`$ forge script script/Starter.s.sol --fork-url http://localhost:8545 --broadcast -vvv`


Register Stewards

```

´´´
$ cast send --rpc-url=http://localhost:8545 <YOUR-DEPLOYER-ADDRESS>  "registerSteward(address)" <YOUR-NEW-STEWARD-ADDRESS> --private-key <YOUR-PRIVATE-KEY>

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
```

