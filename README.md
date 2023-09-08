## TheDarwins - NFT Contract

Welcome to TheDarwins, an NFT contract for minting and managing unique Darwin-themed NFTs. This contract is powered by Ethereum and follows the Web3 standards. Below, you'll find all the information you need to understand and interact with this contract.

TheDarwins

## Contract Details

- **Contract Address**: [Contract Address](https://etherscan.io/address/OUR_CONTRACT_ADDRESS)
- **Token Name**: TheDarwins
- **Token Symbol**: DRWN
- **License**: MIT License

## Overview

TheDarwins is a unique NFT collection inspired by the evolution of humanity through time. This contract allows you to mint these exclusive NFTs and perform various operations.

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

- **White Listed Contract**: [White Listed Contract](https://etherscan.io/address/WHITE_LISTED_CONTRACT)
- **Multisig Wallet**: [Multisig Wallet](https://etherscan.io/address/OUR_MULTISIG_WALLET)

## Configuration

- `pricePerMint`: Price to mint a Darwin NFT.
- `maxSupply`: Maximum number of Darwin NFTs.
- `privMintLive` and `pubMintLive`: Control the availability of private and public mints.
- `paused`: Pauses or unpauses contract operations.

## Resources

To better understand NFTs and smart contract security, consider the following resources:

1. [Anatomy of an NFT: A Guide to NFT Analysis](https://www.ledger.com/academy/anatomy-of-an-nft-a-guide-to-nft-analysis)
2. [NFT Smart Contract Audit: Ultimate Guide for Founders and Managers](https://hacken.io/discover/security-audit-for-nft-guide-for-founders-and-managers/)
3. [NFT Security 101. An example-based analysis](https://medium.com/geekculture/nft-security-101-bc19e689e27b)
4. [How to Secure NFTs: Part Two - NFT Smart Contract Security](https://www.certik.com/resources/blog/1Kl3XHKDdzIZvW0dyJLuSu-how-to-secure-nfts-part-two-nft-smart-contract-security)

## Support

If you have any questions or need assistance, you can contact [kodr.eth](https://x.com/kodr_eth) for support.

## License

This contract is released under the [MIT License](LICENSE).

Enjoy collecting your Darwins! 🦖🌿