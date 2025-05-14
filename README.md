## Foundry

### Deploy protocol

For a mainnet deployment, you can use the `Deploy.s.sol` script with:

```bash
source .env
forge script script/Deploy.s.sol:Deploy -f RPC_URL --broadcast -i 1 --verify -vvvv
```

You can use `-t` or `-l` options instead of `-i 1` for trezor or ledger hardware wallet.

### Testnet deployment

I use https://ethereum-sepolia-rpc.publicnode.com as RPC_URL for sepolia testnet. You can use any other RPC URL as well.

erc20: address 0xf4175c50f958b65627E8D31DCa0C63813e7e6dCA
boonty: address 0x70ae97866e716fFe21262fd4768DC492b37cd77C

### init

```shell
[forge] soldeer update
```

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

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

## Scripts

### Deploy protocol

For a mainnet deployment, you can use the `Spro.s.sol` script with:

```bash
forge script -f RPC_URL script/Spro.s.sol --broadcast -i 1
```

You can use `-t` or `-l` options instead of `-i 1` for trezor or ledger hardware wallet.