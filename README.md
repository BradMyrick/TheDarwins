# Darwins NFT Contract

## Overview

The Darwins NFT contract allows users to mint unique Darwins NFT tokens. It supports both public minting and minting with Evolution Rex tokens,
utilizing the ERC721A base standard.

## Features

- Public Minting: Users can mint Darwins NFT tokens by sending ETH.
- Whitelist Minting with Evolution Rex Tokens: Users can mint Darwins NFT tokens by providing valid Evolution Rex tokens they own.
- Gas Estimation: Estimate the gas required for minting Darwins NFT tokens.
- Ownership and Control: The contract owner has control over configuration parameters.

## Smart Contract Details

- **Base Contract**: This contract is based on the ERC721A standard, which includes batch minting functionality.

- **Access Control**: Certain functions are restricted to the contract owner (`safewallet multisig`).

- **Reentrancy Protection**: The contract uses ReentrancyGuard to prevent reentrancy attacks.

- **Used Evolution Rex Tokens**: The contract keeps track of used Evolution Rex tokens to prevent double minting.

## Usage

- **Public Minting**: Users can mint Darwins NFT tokens by calling the `publicMint` function and sending ETH. The amount of ETH required is determined by the `pricePerMint` and `quantity` parameters.

- **Minting with Evolution Rex Tokens**: Users can mint Darwins NFT tokens by calling the `mintWithEvolutionRex` function and providing valid Evolution Rex tokens they own.

## Configuration

- **Whitelist Minting**: The contract owner can enable or disable whitelist minting using the `setWhitelistMintAvailable` function.

- **Public Minting Availability**: The contract owner can enable or disable public minting using the `setPublicMintAvailable` function.

- **Maximum Tokens per Wallet**: The maximum number of tokens that can be minted per wallet can be set using the `setMaxPerWallet` function.

- **Base Token URI**: The base URI for token metadata can be set using the `setBaseURI` function.

## Gas Estimation

To estimate the gas required for minting Darwins NFT tokens, you can use the `estimateGasForMint` function, providing the desired quantity as a parameter.

## Ownership and Control

The contract owner has the ability to manage and configure the contract parameters. Ownership of the contract is our multisig wallet `safewallet`.

## License

This contract is released under the MIT License.

## Contact

For any inquiries or assistance, please contact `kodr.eth` via [X.com](https://x.com/kodr_eth)
```

