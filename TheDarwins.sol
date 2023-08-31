// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./node_modules/erc721a/contracts/ERC721A.sol";
import "./node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "./node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./node_modules/@openzeppelin/contracts/utils/Strings.sol";

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
    bool public fireSkill = false;
    bool public privMintLive = false;
    bool public pubMintLive = false;

    bool public paused = false;

    uint256 public pricePerMint = 0.0069 ether;
    uint256 public maxSupply = 10000;
    uint256 public privMints = 0;

    // for testing using prev version deployment of this contract
    // TODO: Update this to the correct contract address
    address public constant WHITE_LISTED_CONTRACT = 0xCc184d75B98667CFCC531835dCe5F76B118A486B;
    // TODO: Update this to the correct multisig wallet address
    address public constant MULTI_SIG_WALLET = 0xa8F045c97BaB4AEF16B5e2d84DE16f581D1C7654;
    
// mappings
    mapping(uint256 => bool) public claimTokenUsed;

// modifiers
    modifier tradingSkillAquired() {
        require(tradingSkill, "Trading skill not aquired");
        _;
    }

    modifier fireSkillAquired() {
        require(fireSkill, "Fire skill not aquired");
        _;
    }

    modifier notPaused() {
        require(!paused, "Paused");
        _;
    }

    modifier privateLive() {
        require(privMintLive, "Rex minting not live");
        _;
    }

    modifier onlyMultiSig() {
        require(msg.sender == MULTI_SIG_WALLET, "Only multisig");
        _;
    }

    modifier mintInsurance(uint256 price) {
         
        require(address(this).balance >= (pricePerMint - price) * (_totalMinted() - privMints), "Refund cannot be insured");
        _;
    }

// events

// constructor
    constructor() ERC721A("TheDarwins", "DRWN") {
        _setAux(msg.sender, 679); // all non paid mints are logged in Aux
        _mintERC2309(msg.sender, 679); // Darwins 1 - 679 are reserved for giveaways
    }
    

// override functions
    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return string(abi.encodePacked(_baseURI(), Strings.toString(tokenId), ".json"));
    }

    function setApprovalForAll(address operator, bool approved) public override tradingSkillAquired {
        super.setApprovalForAll(operator, approved);
    }


// public functions

    // public mint
    function publicMint(uint256 quantity) public payable notPaused nonReentrant {
        uint256 ts = totalSupply();
        require(ts + quantity <= maxSupply, "Max supply reached");

        unchecked {
            require(msg.value == quantity * pricePerMint, "Insufficient funds to mint");
            uint64(_getAux(msg.sender)) + quantity;
        }

        _mint(msg.sender, quantity);
    }

    // private mint
    function privateMint(uint256[] calldata tokenIds) external notPaused nonReentrant privateLive{
        uint256 ts = totalSupply();
        require(ts < maxSupply, "Max supply reached");
        require(_checkOutsideOwnership(tokenIds), "Not the owner of all tokens");

        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            require(!claimTokenUsed[tokenId], "Token already minted");
            claimTokenUsed[tokenId] = true;
        }

        // Mint the Darwins
        privMints += tokenIds.length;
        uint currentPrivateMinted =_getAux(msg.sender);
        uint64 mintedamount = uint64(currentPrivateMinted + tokenIds.length);
        _setAux(msg.sender, mintedamount);
        _mint(msg.sender, tokenIds.length);
    }

    function updateMaxSupply(uint256 newMax) external onlyOwner {
        require(newMax > _totalMinted() , "New max must be greater than current supply");
        maxSupply = newMax;
    }

    function pause() external onlyOwner {
        paused = !paused;
    }

    function getWhitelistMintedAmount(address wallet) public view returns (uint256) {
        return _numberMinted(wallet);
    }

    function getPublicMintedAmount(address wallet) public view returns (uint256) {
        return _numberMinted(wallet) - _getAux(wallet);
    }

    function setBaseURI(string calldata uri) external onlyOwner {
        _baseTokenURI = uri;
    }

    function evolveTrading() external onlyOwner {
        // once trading skill is aquired, it cannot be revoked
        tradingSkill = true;
    }

    function evolveFire() external onlyOwner {
        // once fire skill is aquired, it cannot be revoked
        fireSkill = true;
    }

    function setPrivMint() external onlyOwner {
        // if privMintLive is true, set to false, if false, set to true
        privMintLive = !privMintLive;

    }

    function setPubMint() external onlyOwner {
        // if pubMintLive is true, set to false, if false, set to true
        pubMintLive = !pubMintLive;
    }

    function updatePricePerMint(uint256 price) external onlyOwner mintInsurance(price) {
        pricePerMint = price;
    }

    function burn(uint256[] calldata tokenIds) external nonReentrant fireSkillAquired {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _burn(tokenIds[i], true); // with approval check
        }
    }

    function _checkOutsideOwnership(uint256[] calldata tokenIds) internal view returns (bool) {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            if (IERC721(WHITE_LISTED_CONTRACT).ownerOf(tokenIds[i]) != msg.sender) {
                return false;
            }
        }
        return true;
    }


// multi sig functions

    function withdraw(address payable withdrawLocation) external onlyMultiSig {
        require(withdrawLocation != address(0), "Withdraw location address cannot be zero");

        uint256 balance = address(this).balance;

        withdrawLocation.transfer(balance);
    }

}
