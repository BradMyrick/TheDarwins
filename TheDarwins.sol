// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/*
      __ ______  ____  ____        __  __  
     / //_/ __ \/ __ \/ __ \ ___  / /_/ /_ 
    / ,< / / / / / / / /_/ // _ \/ __/ __ \
   / /| / /_/ / /_/ / _, _//  __/ /_/ / / /
  /_/ |_\____/_____/_/ |_(_)___/\__/_/ /_/ 
  
  @dev: kodr.eth
*/

contract Darwins is ERC721A, Ownable, ReentrancyGuard {
    string private _baseTokenURI;

    bool public whitelistMintAvailable = false;
    bool public publicMintAvailable = false;
    uint256 public maxPerWallet = 25;
    uint256 public pricePerMint;
    uint256 public immutable maxSupply;
    uint256 public constant BATCH_SIZE = 20;

    /** @dev Address of the Evolution Rex contract */
    address public evolutionRexContract;
    address public multiSig;
    /** @dev mapping of used evolution rex tokens */
    mapping(uint256 => bool) public usedEvolutionRexTokens;


    modifier onlyMultiSig() {
        require(msg.sender == multiSig, "Only multisig");
        _;
    }
    constructor(uint256 maxSupply_ , address evolutionRexContract_, address multiSig_) ERC721A("TheDarwins", "DRWN") {
        maxSupply = maxSupply_;
        evolutionRexContract = evolutionRexContract_;
        multiSig = multiSig_;
        _mintERC2309(msg.sender, 679); // Darwins 1 - 679 are reserved for giveaways
    }

    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function getWhitelistMintedAmount(address wallet) public view returns (uint256) {
        return _numberMinted(wallet);
    }

    function getPublicMintedAmount(address wallet) public view returns (uint256) {
        return _numberMinted(wallet) - _getAux(wallet);
    }

    function publicMint(uint256 quantity) public payable nonReentrant {
        require(publicMintAvailable, "Public mint is unavailable");
        uint256 ts = totalSupply();
        require(ts + quantity <= maxSupply && quantity <= maxPerWallet, "Max supply reached");

        unchecked {
            require(msg.value == quantity * pricePerMint, "Insufficient funds to mint");
            _setAux(msg.sender, _getAux(msg.sender) + quantity);
        }

        _mint(msg.sender, quantity);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string calldata _uri) external onlyOwner {
        _baseTokenURI = _uri;
    }


    function setWhitelistMintAvailable(bool isActive) external onlyOwner {
        whitelistMintAvailable = isActive;
    }

    function setPublicMintAvailable(bool active) external onlyOwner {
        publicMintAvailable = active;
    }

    function setMaxPerWallet(uint256 _maxPerWallet) external onlyOwner {
        maxPerWallet = _maxPerWallet;
    }

    function setPricePerMint(uint256 price) external onlyOwner {
        pricePerMint = price;
    }

    function withdraw(address withdrawLocation) external onlyMultiSig {
        uint256 balance = address(this).balance;

        (bool success, ) = payable(withdrawLocation).call{value: balance}("");
        require(success, "withdraw failed");
    }

    function burn(uint256[] calldata tokenIds) external nonReentrant {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _burn(tokenIds[i], true); // with approval check
        }
    }

    // Estimate gas required for minting Darwins
    function estimateGasForMint(uint256 quantity) public view returns (uint256) {
        return gasEstimateForMint(quantity);
    }

    // Internal function for gas estimation
    function gasEstimateForMint(uint256 quantity) internal view returns (uint256) {
        uint256 gasUsage = 25000; // Base gas usage for minting
        gasUsage += quantity * 30000; // Additional gas per minted token
        return gasUsage;
    }

    // Must have given approval to this contract to transfer the tokens
    function mintWithEvolutionRex(uint256[] calldata tokenIds) external nonReentrant {
        require(whitelistMintAvailable, "EvoRex mint is unavailable");
        uint256 ts = totalSupply();
        require(ts < maxSupply, "Max supply reached");

        for (uint256 i; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            if (tokenId > 0 && tokenId <= maxSupply && !isEvolutionRexTokenUsed(tokenId)) {
                require(IERC721(evolutionRexContract).ownerOf(tokenId) == msg.sender, "Sender does not own token");
                markEvolutionRexTokenUsed(tokenId);
            }
        }

        // Mint the Darwins
        _mint(msg.sender, tokenIds.length);
    }

    // Check if an Evolution Rex token has been used
    function isEvolutionRexTokenUsed(uint256 tokenId) internal view returns (bool) {
        uint256 wordIndex = tokenId / 256;
        uint256 bitIndex = tokenId % 256;
        return (usedEvolutionRexTokens[wordIndex] & (1 << bitIndex)) != 0;
    }

    // Mark an Evolution Rex token as used
    function markEvolutionRexTokenUsed(uint256 tokenId) internal {
        uint256 wordIndex = tokenId / 256;
        uint256 bitIndex = tokenId % 256;
        usedEvolutionRexTokens[wordIndex] |= (1 << bitIndex);
    }

    // 
}
