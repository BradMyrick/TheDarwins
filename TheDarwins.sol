// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ERC721A.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
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
// variables
    string private _baseTokenURI;
    bool public tradingSkill = false;
    bool public rexMintLive = false;
    bool public paused = false;
    uint256 public maxPerWallet = 25;
    uint256 public pricePerMint;
    uint256 public immutable maxSupply = 10000;
    uint256 public constant BATCH_SIZE = 20;

    address public constant evolutionRexContract = 0x0D01Eaf7b57d95CC4DAF73A99b7916752aa6Fe15;
    address public constant multiSig = 0xa8F045c97BaB4AEF16B5e2d84DE16f581D1C7654; // set to my dev wallet for testing
    
// mappings
    mapping(uint256 => uint256) public usedEvolutionRexTokens;

// modifiers
    modifier tradingSkillAquired() {
        require(tradingSkill, "Trading skill not aquired");
        _;
    }

    modifier notPaused() {
        require(!paused, "Paused");
        _;
    }

    modifier rexLive() {
        require(rexMintLive, "Rex minting not live");
        _;
    }

    modifier onlyMultiSig() {
        require(msg.sender == multiSig, "Only multisig");
        _;
    }

// events

// constructor
    constructor() ERC721A("TheDarwins", "DRWN") {
        _mintERC2309(msg.sender, 679); // Darwins 1 - 679 are reserved for giveaways
    }
    

// override functions
    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setApprovalForAll(address operator, bool approved) public override tradingSkillAquired {
        super.setApprovalForAll(operator, approved);
    }


// public functions

    // public mint
    function publicMint(uint256 quantity) public payable notPaused nonReentrant {
        uint256 ts = totalSupply();
        require(ts + quantity <= maxSupply && quantity <= maxPerWallet, "Max supply reached");

        unchecked {
            require(msg.value == quantity * pricePerMint, "Insufficient funds to mint");
            uint64(_getAux(msg.sender)) + quantity;
        }

        _mint(msg.sender, quantity);
    }

    // rex mint
    function mintWithEvolutionRex(uint256[] calldata tokenIds) external notPaused nonReentrant rexLive{
        uint256 ts = totalSupply();
        require(ts < maxSupply, "Max supply reached");

        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            if (tokenId > 0 && tokenId <= maxSupply && !_isEvolutionRexTokenUsed(tokenId)) {
                require(IERC721(evolutionRexContract).ownerOf(tokenId) == msg.sender, "Sender does not own token");
                _markEvolutionRexTokenUsed(tokenId);
            }
        }

        // Mint the Darwins
        _mint(msg.sender, tokenIds.length);
    }

    function pause(bool _paused) external onlyOwner {
        paused = _paused;
    }

    function getWhitelistMintedAmount(address wallet) public view returns (uint256) {
        return _numberMinted(wallet);
    }

    function getPublicMintedAmount(address wallet) public view returns (uint256) {
        return _numberMinted(wallet) - _getAux(wallet);
    }

    function setBaseURI(string calldata _uri) external onlyOwner {
        _baseTokenURI = _uri;
    }

    function setRexMintLive(bool isActive) external onlyOwner {
        rexMintLive = isActive;
    }

    function setMaxPerWallet(uint256 _maxPerWallet) external onlyOwner {
        maxPerWallet = _maxPerWallet;
    }

    function setPricePerMint(uint256 price) external onlyOwner {
        pricePerMint = price;
    }

    function burn(uint256[] calldata tokenIds) external nonReentrant {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _burn(tokenIds[i], true); // with approval check
        }
    }

    function estimateGasForMint(uint256 quantity) public pure returns (uint256) {
        return _gasEstimateForMint(quantity);
    }

// internal functions

    function _gasEstimateForMint(uint256 quantity) internal  pure returns (uint256) {
        uint256 gasUsage = 25000; // Base gas usage for minting
        gasUsage += quantity * 30000; // Additional gas per minted token
        return gasUsage;
    }

    function _isEvolutionRexTokenUsed(uint256 tokenId) internal view returns (bool) {
        uint256 wordIndex = tokenId / 256;
        uint256 bitIndex = tokenId % 256;
        return (usedEvolutionRexTokens[wordIndex] & (1 << bitIndex)) != 0;
    }

    function _markEvolutionRexTokenUsed(uint256 tokenId) internal {
        uint256 wordIndex = tokenId / 256;
        uint256 bitIndex = tokenId % 256;
        usedEvolutionRexTokens[wordIndex] |= (1 << bitIndex);
    }


// multi sig functions

    function withdraw(address withdrawLocation) external onlyMultiSig {
        require(withdrawLocation != address(0), "Withdraw location address cannot be zero");

        uint256 balance = address(this).balance;

        (bool success, ) = payable(withdrawLocation).call{value: balance}("");
        require(success, "withdraw failed");
    }

}
