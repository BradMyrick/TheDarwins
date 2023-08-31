# TheDarwins - NFT Contract

Welcome to TheDarwins, an NFT contract for minting and managing unique Darwin-themed NFTs. This contract is powered by Ethereum and follows the Web3 standards. Below, you'll find all the information you need to understand and interact with this contract.

![TheDarwins](https://i.imgur.com/xxxxxxxx.png)

## Contract Details

- **Contract Address**: [Contract Address](https://etherscan.io/address/YOUR_CONTRACT_ADDRESS)
- **Token Name**: TheDarwins
- **Token Symbol**: DRWN
- **License**: MIT License

## Overview

TheDarwins is a unique NFT collection inspired by the world of Darwins. This contract allows you to mint these exclusive NFTs and perform various operations.

### Features

- **Minting**: Mint your own Darwin NFTs.
- **Ownership**: Prove your skills and claim unique NFTs.
- **MultiSig**: Securely manage contract funds with multisignature wallet support.
- **Skills**: Evolve your skills to access exclusive features.

## Getting Started

### Installation

To use this contract, you'll need Solidity 0.8.16. Make sure to install it before deploying the contract.

### Usage

#### Public Minting

- Use the `publicMint` function to mint Darwin NFTs.
- Ensure the contract is not paused and that you send enough Ether for the desired quantity of NFTs.

#### Private Minting

- Use the `privateMint` function to mint for NFTs that you own of the `WHITE_LISTED_CONTRACT`.
- Make sure you are the owner of all tokens you intend to mint privately.
- Tokens can only be used for claiming once.

#### Other Functions

- Explore other functions like updating the max supply, setting the base URI, evolving your skills, and more.

### Skills

To access certain functions, you need to acquire specific skills:
- **Trading Skill**: Required for some functions.
- **Fire Skill**: Required for burning NFTs.

### Multisig Wallet

- The contract supports a multisignature wallet for secure fund management.

## Contract Addresses

- **White Listed Contract**: [White Listed Contract](https://etherscan.io/address/YOUR_WHITE_LISTED_CONTRACT)
- **Multisig Wallet**: [Multisig Wallet](https://etherscan.io/address/YOUR_MULTISIG_WALLET)

## Configuration

- `pricePerMint`: Price to mint a Darwin NFT.
- `maxSupply`: Maximum number of Darwin NFTs.
- `privMintLive` and `pubMintLive`: Control the availability of private and public mints.
- `paused`: Pauses or unpauses contract operations.

## Support

If you have any questions or need assistance, you can contact [kodr.eth](https://x.com/kodr_eth) for support.

## License

This contract is released under the [MIT License](LICENSE).

Enjoy collecting your Darwins! 🦖🌿