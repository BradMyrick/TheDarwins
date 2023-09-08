// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./node_modules/erc721a/contracts/ERC721A.sol";
import "./node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "./node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./node_modules/@openzeppelin/contracts/utils/Strings.sol";
import "./node_modules/@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

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
    uint256 public privMints;

    bytes32 private root;

    address public constant MULTI_SIG_WALLET =
        0x07133dec805C3ED394Fb141f410f32fb407Bec16;

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

    modifier wlCheck(
        bytes32[] memory proof,
        uint64 originalAmount,
        uint64 amountToMint
    ) {
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, originalAmount));
        require(MerkleProof.verify(proof, root, leaf), "Invalid proof");
        uint256 minted = _getAux(msg.sender);
        require(minted + amountToMint <= originalAmount, "Max mint reached");
        // update the amount minted by the wallet
        _updateWhitelistMintedAmount(msg.sender, amountToMint);
        _;
    }

    // constructor
    constructor() ERC721A("TheDarwins", "DRWN") {
        privMints = 50;
        _mintERC2309(msg.sender, 50); // Darwins 1 - 50 are reserved for giveaways
    }

    // override functions
    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");
        return
            string(
                abi.encodePacked(_baseURI(), Strings.toString(tokenId), ".json")
            );
    }

    function setApprovalForAll(
        address operator,
        bool approved
    ) public override tradingSkillAquired {
        super.setApprovalForAll(operator, approved);
    }

    // public functions

    function publicMint(
        uint256 quantity
    ) external payable notPaused nonReentrant {
        uint256 ts = totalSupply();
        require(ts + quantity <= maxSupply, "Max supply reached");
        require(
            msg.value == quantity * pricePerMint,
            "Insufficient funds to mint"
        );
        _mint(msg.sender, quantity);
    }

    function privateMint(
        bytes32[] calldata merkleProof,
        uint64 originalAmount,
        uint64 amountToMint
    )
        external
        notPaused
        nonReentrant
        privateLive
        wlCheck(merkleProof, originalAmount, amountToMint)
    {
        privMints += amountToMint;
        _mint(msg.sender, amountToMint);
        
    }

    function updateMaxSupply(uint256 newMax) external onlyOwner {
        require(
            newMax > _totalMinted(),
            "New max must be greater than current supply"
        );
        maxSupply = newMax;
    }

    function pause() external onlyOwner {
        paused = !paused;
    }

    function getWhitelistMintedAmount(
        address wallet
    ) external view returns (uint256) {
        return _getAux(wallet);
    }

    function _updateWhitelistMintedAmount(
        address wallet,
        uint64 amount
    ) internal {
        _setAux(wallet, _getAux(wallet) + amount);
    }

    function getPublicMintedAmount(
        address wallet
    ) external view returns (uint256) {
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
        privMintLive = !privMintLive;
    }

    function setPubMint() external onlyOwner {
        pubMintLive = !pubMintLive;
    }

    function updatePricePerMint(
        uint256 price
    ) external onlyOwner {
        pricePerMint = price;
    }

    function burn(
        uint256[] calldata tokenIds
    ) external nonReentrant fireSkillAquired {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _burn(tokenIds[i], true);
        }
    }

    function setMerkleRoot(string calldata _merkleRoot) external onlyOwner {
        root = bytes32(bytes(_merkleRoot));
    }

    function withdraw(address payable withdrawLocation) external onlyMultiSig {
        require(
            withdrawLocation != address(0),
            "Withdraw location address cannot be zero"
        );

        uint256 balance = address(this).balance;

        withdrawLocation.transfer(balance);
    }
}
