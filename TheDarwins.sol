// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./npm/erc721a/contracts/ERC721A.sol";
import "./npm/@openzeppelin/contracts/utils/Strings.sol";


/*
      __ ______  ____  ____        __  __  
     / //_/ __ \/ __ \/ __ \ ___  / /_/ /_ 
    / ,< / / / / / / / /_/ // _ \/ __/ __ \
   / /| / /_/ / /_/ / _, _//  __/ /_/ / / /
  /_/ |_\____/_____/_/ |_(_)___/\__/_/ /_/ 
  
  @dev: kodr.eth
*/

contract Darwins is ERC721A {
    // variables
    string private _baseTokenURI = "https://darwins.app/metadata/";
    bool public privMintLive = false;
    bool public pubMintLive = false;

    uint public pricePerMint = 0.0015 ether;
    uint public maxSupply = 10000;

    address public kodr = 0xa8F045c97BaB4AEF16B5e2d84DE16f581D1C7654;

    mapping(address => uint) public whiteList;


    address public MULTI_SIG_WALLET =
        0x07133dec805C3ED394Fb141f410f32fb407Bec16;

    // modifiers
    modifier privateLive() {
        require(privMintLive, "WL minting not live");
        _;
    }

    modifier publicLive() {
        require(pubMintLive, "Public minting not live");
        _;
    }

    modifier onlyMultiSig() {
        require(msg.sender == MULTI_SIG_WALLET, "Only multisig");
        _;
    }

    modifier onlyKodr() {
        require(msg.sender == kodr, "Only Kodr");
        _;
    }

    // constructor
    constructor() ERC721A("TheDarwins", "DRWN") {
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
    // public functions

    function publicMint(
        uint256 quantity
    ) external payable publicLive {
        uint256 ts = totalSupply();
        require(ts + quantity <= maxSupply, "Max supply reached");
        require(
            msg.value == quantity * pricePerMint,
            "Insufficient funds to mint"
        );
        _mint(msg.sender, quantity);
    }

    function privateMint(uint64 quantity) external privateLive {
        uint256 ts = totalSupply();
        require(ts + quantity <= maxSupply, "Max supply reached");
        require(
            whiteList[msg.sender] >= quantity,
            "Insufficient tokens to mint"
        );
        whiteList[msg.sender] -= quantity;
        _mint(msg.sender, quantity);
    }

    function updateMaxSupply(uint256 newMax) external onlyKodr {
        require(
            newMax > _totalMinted(),
            "New max must be greater than current supply"
        );
        maxSupply = newMax;
    }

    function setBaseURI(string calldata uri) external onlyKodr {
        _baseTokenURI = uri;
    }

    function setPrivMint() external onlyKodr {
        privMintLive = !privMintLive;
    }

    function setPubMint() external onlyKodr {
        pubMintLive = !pubMintLive;
    }

    function updatePricePerMint(uint256 price) external onlyKodr {
        pricePerMint = price;
    }

    function withdraw(address payable withdrawLocation) external onlyMultiSig {
        require(
            withdrawLocation != address(0),
            "Withdraw location address cannot be zero"
        );

        uint256 balance = address(this).balance;

        withdrawLocation.transfer(balance);
    }

    function updateMultiSig(address newMultiSig) external onlyMultiSig {
        require(newMultiSig != address(0), "MultiSig address cannot be zero");

        MULTI_SIG_WALLET = newMultiSig;
    }

    function updateKodr(address newKodr) external onlyMultiSig {
        kodr = newKodr;
    }

    function initWL() external onlyKodr {
        whiteList[MULTI_SIG_WALLET] = 500;
        whiteList[0x0144C8A1c8691C93dA212609b7E1041e64210468] = 19;
        whiteList[0x04F19722Cc685FE3AdbB3eFc69de969B21Fa3569] = 5;
        whiteList[0x050A560Ad5F501cC6Fc7dD9b10482051fc56d24b] = 26;
        whiteList[0x05996007C6071D2aeAd99B1c6b712BfB888bB71c] = 10;
        whiteList[0x0735832e9F0037ac8ab6B10D7d264F9B38A9d6a7] = 6;
        whiteList[0x07bE036F5baedA1115b1132e2412900d85985510] = 2;
        whiteList[0x07c7d4EE6fA803114D863Bde46bCff5a5157de1C] = 1;
        whiteList[0x07Ff43FEf899f5c69D5F771f44f12954455fd8e2] = 4;
        whiteList[0x08463568344Ec6862904b188b5a26Bb81aa12201] = 1;
        whiteList[0x09D7418A0B62e70D94adA390B09E482AD2d85e1c] = 1;
        whiteList[0x09F0e2f6ac543EE7653C05f592fbB2f5d1F8cB2a] = 9;
        whiteList[0x0a0F313c154338E40bFbf33e946299cDdD259F0d] = 1;
        whiteList[0x0aAf12E967BF6a00C863735aAb30031A9aaaC429] = 10;
        whiteList[0x0BA248d14c1eDeEFF527854024C41Fc60FC2b42b] = 20;
        whiteList[0x0be8bC490093ebD4361F14eCf64977A6519A9B48] = 7;
        whiteList[0x0d182Abb31C5c5060502bEC2C4153F9747E598Bb] = 1;
        whiteList[0x0D69383021A62E31644472EE75c71648E9Bc1d2F] = 1;
        whiteList[0x0da90deaa61E8c2b6aB82023e72BEdc0be82c4f1] = 8;
        whiteList[0x10a9eaE4d9186c7f666a80aD64df1fdC8e0d2b1D] = 1;
        whiteList[0x11717FB8c74bc3fe1268cEE13898ba6F550763D5] = 18;
        whiteList[0x121e9da048d70e70CaA07Bf7c7548BCcE906835a] = 3;
        whiteList[0x1349f0975Fe8313e765F37B6D7b6fbdfDB13d025] = 5;
        whiteList[0x155e32A5Fc0DaC7b069AC4cd82Bf0b1b73a1e7E5] = 1;
        whiteList[0x159F7A2E758D8F16615D6Ce6b35040d4C629a38f] = 2;
        whiteList[0x15a5Ee798fe010CDc18295c30af76AE475211fd2] = 5;
        whiteList[0x162196a46aE350Ab10fE219BCa715Cd28Bb90d22] = 1;
        whiteList[0x174382F5c66ab9045eE784AaA9c201e84e289338] = 16;
        whiteList[0x1746A9fa5D8FFa2fE85911f7956156f7F148847b] = 6;
        whiteList[0x1807bbA25E904A8798EBE50c5B2735996aD68C27] = 1;
        whiteList[0x18101F05F8180b4ca5347C990544aaede8B7425e] = 15;
        whiteList[0x1a0C5F0d1684e8CC8459D6d9cb919977CB6668C1] = 2;
        whiteList[0x1A107FcB3f05654D45dD417F549546fC0e63D7Ca] = 2;
        whiteList[0x1A305bebDAa5B821b22f47D10cD7c1bab915BaD5] = 1;
        whiteList[0x1AC8D541B8643b8bc15D3A48E76826597F4Dca55] = 50;
        whiteList[0x1b6bC7EA3B3612d7E43842E5Bee97433A89B4aFD] = 1;
        whiteList[0x1D6FA76b3a383cb9ab4151f9AB1597BC95948A4C] = 20;
        whiteList[0x1DA58933f381EDf6f09e9FaF2ca789b48e58BaFB] = 100;
        whiteList[0x1E59Fd8De7d13Cf7681658E5F9F318326840F8DF] = 20;
        whiteList[0x1f428262B898a3ADcaAE1508f0C708a9151610C6] = 28;
        whiteList[0x1Ff5fD0c5A7Fc3c74Ab2E407e23ED0855Ee20697] = 12;
        whiteList[0x2083B4D378239304CDDB7f4eD1DF31349E3ef7F6] = 10;
        whiteList[0x21F27F429B289007cd682D587893b95338D73803] = 2;
        whiteList[0x22035d938b3fe388586F362c3BCF5471383A2AC9] = 5;
        whiteList[0x227602E85370b8b58c3f43b75cfCC380293D46c7] = 8;
        whiteList[0x22Ed4a07Ed8B6cbBf8505124BD93170bF979EaD0] = 1;
        whiteList[0x24306bDc0AD35c844e8F5E9D869974fB8F584607] = 13;
        whiteList[0x2447c20C6225Da4cdAa30179b39C1399f947F953] = 3;
        whiteList[0x24576f2193b7C09D372e834FDC120d79257cB447] = 22;
        whiteList[0x25104e2Ec7BF52f3Ff9d688737a9Ed7ce7680adc] = 2;
        whiteList[0x255b45C04F138a037aFe7C57dA3f8d1cFB4115C4] = 3;
        whiteList[0x256A0f2c2e4e25Be77D0fD4FD240367c30B72f51] = 99;
        whiteList[0x264366130E553183a764cb7cae236181CfCe9F5E] = 5;
        whiteList[0x2687B8f2762D557fBC8CFBb5a73aeE71fDd5C604] = 2;
        whiteList[0x274C723813AdC7C0242bDE23008c413CC3AD7692] = 30;
        whiteList[0x278E1Dbe867d4157b85B841c1BE343be9a252b07] = 1;
        whiteList[0x28224E9a97876F8CF6398a03775B10a0536db741] = 153;
        whiteList[0x283349c3D6Ca4c67F92eF8e086DB75A5e3B30b4A] = 1;
        whiteList[0x28cdF78DcD8A2E97f5E56062FcBdC8084a1827AD] = 50;
        whiteList[0x2930b195CAbA1618fE69da90Fd8f60f16E6B66f5] = 11;
        whiteList[0x293927B0D79190110888f6ce37F943F065121506] = 1;
        whiteList[0x2BAc1C1675EA6fFa9B85A69624D03D605fe67846] = 2;
        whiteList[0x2c064Aa8aBe232babf7a32932f7AB7c4E22b3885] = 1;
        whiteList[0x2C2c67B6AD0fA3B3a5455770Ce1bf43A6AcE02AC] = 1;
        whiteList[0x2Cad00eBaF3D6D5B2435338D8999252a527bDc2d] = 1;
        whiteList[0x2d5207efEa0D9fCfAFC234F07388D9B095350c93] = 10;
        whiteList[0x2db053A1C06Fb7D2c4d783d7bD4B1b0d4e3ccc3A] = 7;
        whiteList[0x300CE77dAFd2c0e91fe0B4DcF49Bd068F1b936c3] = 6;
        whiteList[0x30ecE5B508e58deb520cf71ba8F69CDA3472fDf3] = 1;
        whiteList[0x32e98b4f2a678Ab14211D844034c16134204f25b] = 3;
        whiteList[0x32F2895b0b5F00fF53EC6279F02876a6cABC3c85] = 95;
        whiteList[0x343dfD70e8F8cB4aa895A036C5D0860c69D50236] = 3;
        whiteList[0x34486D30bB1D9ACB60f60d27b7717bEDe2c68A36] = 20;
        whiteList[0x34aD3f00C4ABbE169EC1203Be34de622671381af] = 2;
        whiteList[0x352a08f487Bc0c765c88A657729e927Ab6A8d83c] = 5;
        whiteList[0x360CbBd9C3f3545B4A0825E1Bbda64EF370B279F] = 1;
        whiteList[0x36cAE665915960BfEACe3eaB66B1Cb2A0B3B723a] = 164;
        whiteList[0x3710fE20FE3B93bc90CFc2A0806E32FF930338F8] = 1;
        whiteList[0x3722Bc2806edd9A5A7151327A12EAAC38c3DA089] = 10;
        whiteList[0x37d84263ACD62a99e99E2E9A71766b79b9AD3ff0] = 1;
        whiteList[0x38f3e5d737E14580162ECe6a23A8b548b725e880] = 5;
        whiteList[0x39351F3B8abC2540BAd03926be7694a0D7E66085] = 2;
        whiteList[0x39ea75f28af4fB2354eE08b5E6B18e31DB236787] = 1;
        whiteList[0x3A6ad82Fa99bc786545409fC98b490a85f137695] = 1;
        whiteList[0x3AC9E19507B2BeBd1Ea1D29f51C5eA36d221E780] = 6;
        whiteList[0x3bD3d4C9E3a94d7E66357b6b80727ab948F7Cf21] = 3;
        whiteList[0x3C323d953Dd4c2089188739509ecd642dBDD33BE] = 1;
        whiteList[0x3eaFC0F3f731A142084C8D83CBfC4b902Cf052EC] = 1;
        whiteList[0x4031c03871A3e1eD5557F527D9CB983dD4797AC8] = 6;
        whiteList[0x4173262E7B4f3288fd49989dae59f5d5AD289291] = 1;
        whiteList[0x424016f8059FE832f8C38BC8429ADceE00d58fDd] = 1;
        whiteList[0x425aB2051e0cB14701Bd00bFa7e65aa57dA252Df] = 42;
        whiteList[0x42C69511953C56Ea6fFbAcf840dA370ab82b83e8] = 13;
        whiteList[0x434Eb950eF67470F1c255BDAcd1b6A39e1c67A14] = 2;
        whiteList[0x444e2DB32b1fd1Bb4CaCB546f2D6832427e9C646] = 4;
        whiteList[0x474B8CEaAD690A8c9Ca8840eFe48917D642E9e53] = 10;
        whiteList[0x495B7807507FD839501D86c1CA8e84Ac9295710D] = 5;
        whiteList[0x49723bB74dcDAd9bcDbA97FA63686684ba5714D4] = 1;
        whiteList[0x4A82C4fd2e757DE7AeaB8996Da95B0a363009C74] = 1;
        whiteList[0x4AB4F4A4E382793BCd25176E8d6A5891FA64a5c9] = 3;
        whiteList[0x4B8Db3EeE0dBf35a3D13d910e48Ab29b57EAf381] = 8;
        whiteList[0x4cF2C4dE3a6a379470815D6CaBAdbd8577BA8b35] = 3;
        whiteList[0x4dB791031a793c1aeFA3214ad2EF2223E11d0a24] = 17;
        whiteList[0x4DF5335fFaE910eD28fF7CcD0412cA44E53e926e] = 2;
        whiteList[0x50105A8cFFeE4b8F843fDb0FF947cFF3051a0520] = 2;
        whiteList[0x51eBEf5b2eCA862cC26C402E65058642a03696bA] = 2;
        whiteList[0x531524F530b2ACcdE6F4eb1db1F6006722A57B37] = 4;
        whiteList[0x53586fE029D8e5c645F5Bc4d9514D291d9166261] = 1;
        whiteList[0x54Ca2155b9cd7f5937A6087A39C55682193E42E1] = 14;
        whiteList[0x54D300b961Df1d470296DbaFfcDebF2F76Ac0a88] = 113;
        whiteList[0x54e60273E3DDAc8Aee7c4a1aE799aC91322ee0F6] = 1;
        whiteList[0x56dDA7A588320F20CE3bEeAC29ca08279973d78F] = 1;
        whiteList[0x57A6eea3A6cB37bC9B65866E9CdbBC52d0f9e116] = 1;
        whiteList[0x591F8a2deCC1c86cce0c7Bea22Fa921c2c72fb95] = 12;
        whiteList[0x5943Ca679faC6f9284718adB4065EF284eF5F5FF] = 1;
        whiteList[0x594D3831698de6F1b946163ED4876E990E31d421] = 5;
        whiteList[0x5B33ea8B7836FF4D14C75F0d461Fc67a23D777F0] = 4;
        whiteList[0x5c1a3cd12b66b38Ff52b4Ad90A7bC23425e30023] = 2;
        whiteList[0x5D06bbd476DEb800A1AE6a4a8Eb12628580D837d] = 2;
        whiteList[0x5D300f524EF4ad000eCCB14b005ba790265b96c7] = 5;
        whiteList[0x5D84c00cDC2AbaCfEFEeF83DdA8B5e4995f59294] = 2;
        whiteList[0x5F07E22668a29D7CE9074cb94ef5Ec458f77d4c1] = 2;
        whiteList[0x5fecCF279B28BFc972bd06c79665B55E44D94B1c] = 1;
        whiteList[0x6006FD9eaD65D5534Fe0cFCE96E300ac51194AD5] = 14;
        whiteList[0x62794186e721A14780FF2382d9B695457A442BB9] = 2;
        whiteList[0x62b0184F1C852601Bf57dF64EBa15D54F1c2dB2B] = 3;
        whiteList[0x62C46784e6fbBE766FA2cCBa3330A5d749D37B72] = 4;
        whiteList[0x632935146013bA7381ECD293a8b90c8aff818B9c] = 17;
        whiteList[0x6564E9241F6EEa5A0E5DF1443F02d5b0320fae6F] = 9;
        whiteList[0x65fb47Ce9108B5c937cAa3e9707FcB581CF14B0E] = 3;
        whiteList[0x66557b7cAAceD6215d206E78526F7b7eE6A1842a] = 2;
        whiteList[0x670f2c2172D5aF2DeF7b8b1d3dD33F63F8c589EC] = 1;
        whiteList[0x6748c23CB9D9F40aC75ec2C43106A8BC3197f82E] = 6;
        whiteList[0x678469cA566BEE59C2eE779B09976B8072B572BB] = 1;
        whiteList[0x68365e692B7D46D7287905Aa40160C8EEA322b47] = 4;
        whiteList[0x6853B875c8fAfb9Df34D720933DbEF334324822e] = 5;
        whiteList[0x686a0AF16D26DD698c623e01F752a78e0A612479] = 2;
        whiteList[0x68a333921e94C31F2b7E1cC5abDf6409A0Cdd6c0] = 13;
        whiteList[0x698B13c6413eB652c2188941589515e39b5b9091] = 19;
        whiteList[0x69C0d742B429764e1B10C82E0002D56f0A92fe3b] = 5;
        whiteList[0x69d2aE270f11280467302f1C794dd443e649E478] = 8;
        whiteList[0x6AE7737fFB0E7862de7d6F77F48e72Ac693BC363] = 1;
        whiteList[0x6b4983cFF0d886c062CA663e1502AA8c7d94Ebe5] = 2;
        whiteList[0x6BaCc18289823b6E8fafAE0f1bbC80D301455fa4] = 6;
        whiteList[0x6c414F94194e3C0Ff752A1D24d0dCC577f418193] = 1;
        whiteList[0x6C75881D661f2d0d160011BDC967263C02D18357] = 3;
        whiteList[0x6d172968a80b780123648cD05A342A980C4E12cA] = 2;
        whiteList[0x6d3C240860B7fd8613e4837575cA35bC51876Ead] = 11;
        whiteList[0x6d81d9A6387610181C02b435886C28F5C14082A5] = 3;
        whiteList[0x6f478b0517D26ae9cf2251Abe232eA2Ee3eF8F4b] = 4;
        whiteList[0x6F585209648c6983d68DB0832840F618413a9CF8] = 4;
        whiteList[0x6Fb1B3e05dF9A12B2BbB4A0CbEFefbAE644CCCFE] = 1;
        whiteList[0x6Fd496AEcfe6D392aD34322372B861473eAA2105] = 3;
        whiteList[0x6fE45a06Eb4Dd15a05B542F53D5F3c496021c430] = 3;
        whiteList[0x70E1B51989E28B23add92F8d1050Ee25636B1F0C] = 3;
        whiteList[0x71Da842fF20aff3833A4Ea7D6F15b10B2f50e35C] = 9;
        whiteList[0x71E39b6eB61F73ac505eED6CEC25e48a8F6E6dE9] = 5;
        whiteList[0x720478aD6ec430140E282E17c0F48f6bC50258BA] = 3;
        whiteList[0x727D7F5664E47Be8aa01658a952069618CE738fd] = 1;
        whiteList[0x74C473f363809D4462A17397c2F416eBCb5A4ECE] = 4;
        whiteList[0x74F04dc8E81E121755f9c9353085d1587F42cB8D] = 9;
        whiteList[0x7536b5bFCEB896057bc9209BDD9A7b97Aa0418B0] = 29;
        whiteList[0x76B54fcF8432c0b20A334FeeC430C0CEBD67b071] = 1;
        whiteList[0x7734c878688638701c36cd42637841a1524f1d27] = 182;
        whiteList[0x778fe031687Cb628dE761dac965a9b2acC2CFF28] = 9;
        whiteList[0x784C1fd6503ca63989339001eb5c448577b6783B] = 30;
        whiteList[0x7B2ffe139191b962c1f5686aE5025d4A64eAF2Ee] = 3;
        whiteList[0x7B37aE72E3E6A8330002f16865707aa26154a0aF] = 110;
        whiteList[0x7d3658d367bFAe8325Cb7E6C6992161F39BA9719] = 50;
        whiteList[0x7d5deaBD408de86FF8Bd8c0Fa77aAaE49dc56B70] = 3;
        whiteList[0x7D694112F45E263EA248168700a59e2cDe490fDc] = 1;
        whiteList[0x7d807BEA2B4325BeC13231aAe3f2b3aE355d626D] = 1;
        whiteList[0x7f9B48021C6E6AEF86C6563Ab2FA031BDaeEc3A9] = 4;
        whiteList[0x8001f39E78095095d064C479E886FDE9b26fC390] = 1;
        whiteList[0x80aE8be9DDBF4372954aAE15C4aeba6464D79BAf] = 5;
        whiteList[0x812d7fbaB15adA04A69eF77221225b83D32d310C] = 49;
        whiteList[0x814DBA71d0a064DBE28dfbC9f33B4063722620B0] = 5;
        whiteList[0x81c4C188dAcC70A1e4452B6BB3879A2e125c89D2] = 1;
        whiteList[0x831a81fa489b3e8eC6E8b56776A0AA78dC24c74f] = 1;
        whiteList[0x83c3B26509E92C4edfb16B46b20556EF46b07909] = 2;
        whiteList[0x84AAAf0294c36551042C6681dfA0838Fb2C3A66C] = 25;
        whiteList[0x84bB5f1D4420B872a435CDa39EcC49CB2f7A140B] = 5;
        whiteList[0x85884781F0CB4f5bCDbe46679663cc930f0d51F5] = 82;
        whiteList[0x85D4b10812204B5AD1E05Dd8Ce5c5384E583d4E2] = 3;
        whiteList[0x85D7E076163Eb1FB86162832DAb1b5da87Aaf981] = 1;
        whiteList[0x85F3fA6C4BCae7A342dA955C35a49b874a8E08fF] = 2;
        whiteList[0x860F4d513Fd15789Af2D5942fF80a637Fd4a27d7] = 1;
        whiteList[0x86173528CA463a1fd164b5B219EA0b944204A528] = 10;
        whiteList[0x8629d20300E1b93D169AF3C143bcc9C2AB662D71] = 2;
        whiteList[0x8656025C50f0Ec44F2a114c98ba0A446b8b7B28E] = 1;
        whiteList[0x87B218641Bd6611531C70211Aab3D514F8a1731B] = 13;
        whiteList[0x88e137bd3C1d8E94162B48034b221335f7aCe9ff] = 1;
        whiteList[0x899bFF3d1A3592DcbbA5Fe11ff230cb87539c5C5] = 76;
        whiteList[0x89a55D60956A071a58C27fB6376fEcB19ecf197F] = 1;
        whiteList[0x8c2116BC5B1d04A5319156Eb8100CE3F5Fc74BD5] = 2;
        whiteList[0x8cbE859eD0DD03aE78cACacf0e539c9aD4c197BE] = 1;
        whiteList[0x8DB973EeCD14D658180a9b78B07a16f66D06920c] = 9;
        whiteList[0x8DBF6B34D823Ad58C88f826d6AfD6863A13122E5] = 3;
        whiteList[0x8Ded135a82742d8a6525Dd467d302eF34628F21e] = 15;
        whiteList[0x8f85Da98b6cd6951E9CCDCBa776B24F404A7CCE9] = 1;
        whiteList[0x8Fb448B51E6d6c3d07FE59D8e8d4766560F76991] = 52;
        whiteList[0x9054390476042fb17Afe1061082E3e46A7637cB4] = 3;
        whiteList[0x9058a6dF1674964996bDBe1a35304367e6f0e7De] = 14;
        whiteList[0x905BCaF1e8dDC86f228B95068063765BB4750704] = 15;
        whiteList[0x90a79DF35A425694CC6D86022ff0f2AbF1cB7813] = 16;
        whiteList[0x93bcF9d3aF436fAd94b4bA980E4590cFe45d77DA] = 2;
        whiteList[0x94B65bc4bde4524FefDa35FFeEB90218BC15B66c] = 1;
        whiteList[0x95893796445Fd4AF70899bd147151919ff5A3605] = 17;
        whiteList[0x95Ee6D92DD595590Ee4194C254787836366F3179] = 2;
        whiteList[0x970E82C7D8c3649F747769DD41cC51f22C811c75] = 2;
        whiteList[0x99b95f21f48651b9473012a91796D5C5Cd226C19] = 101;
        whiteList[0x9Ac944ADa45531304ab9ADab06C5cf575E35A203] = 39;
        whiteList[0x9B52a90C2A7C2d0c476DE449e4F5400306368AeA] = 6;
        whiteList[0x9b55b3448471a393682CEB895042470Dd4B86cfF] = 1;
        whiteList[0x9BcEbbB078EE2D86Fd0D9EAf9afD07A152beeD1C] = 12;
        whiteList[0x9C48F233A3cf6c95496844Ca418AceA9BF5ee143] = 4;
        whiteList[0x9C9EAEf819fF2b0B7d21f23f881710DaB9B16c29] = 59;
        whiteList[0x9Cb51b11317157776BEa1eA2e904BF7a4474A4Df] = 2;
        whiteList[0x9dFcABbe7cAc0C13658A6f7ab999565dE044ffcC] = 2;
        whiteList[0xa007D946BaD4e53C4E57f37E7e10Bef28e5bbc5E] = 1;
        whiteList[0xA01db4332D4b646B75842b9A094f4187fb38958B] = 1;
        whiteList[0xA0ca33ec3a437A24A2C3424c1D49A88C9Cd62FD8] = 1;
        whiteList[0xa1D80730e04FD7DA39eE755424D51269ddbc082f] = 1;
        whiteList[0xA2fe06b8B3Ce3887BEc864E71ad5Ff6B480Bb463] = 33;
        whiteList[0xA3609C5e507E7dDeD0036bB7E43bbA9832293c7b] = 30;
        whiteList[0xA50459D0FdD7E183254f1632e493ad8F4947BB24] = 35;
        whiteList[0xa719B83FC387fa2A24aD7587400E206797E942e6] = 5;
        whiteList[0xa7A78045251D8be6ED56e5BD3f09cCCEdb2dbd1B] = 2;
        whiteList[0xA7Cf1BFb46b8be063ec0d8b65506DeC05cA73cF5] = 3;
        whiteList[0xA86322a72Bd98c269E0D72Dc79594A25E3461b0B] = 1;
        whiteList[0xa86A82606C161f1E24f68E13232239406fbDfC38] = 1;
        whiteList[0xa8c36cF930842d734912e28423df7F95b28618D3] = 2;
        whiteList[0xa8F045c97BaB4AEF16B5e2d84DE16f581D1C7654] = 114;
        whiteList[0xA902Bb5809c225f58c5f2E53087C97978A00Aac7] = 1;
        whiteList[0xa9722a78cDC99F8C87FCA5B6A9F36A37F93199d6] = 1;
        whiteList[0xA9f46856f70D4935c41D2A682Aa24d553801b0f5] = 150;
        whiteList[0xaA5f4abcEF7945f350645AeD38dC4fEE9e037ce9] = 7;
        whiteList[0xAAbc271ce7a47faA8CBdfe55673a4103bde81999] = 2;
        whiteList[0xAb1b9521de0F0A30c43817c66C54C06A95548058] = 2;
        whiteList[0xaBa4792e6715C712dF01F436f7Cd9c5C2fc32eD9] = 3;
        whiteList[0xAbcF0aCd650dB812faEF2dfE5790f696a064E1ED] = 1;
        whiteList[0xAc492b0FeC41590ecB08B0EDBBEfA3319CFc7e1F] = 1;
        whiteList[0xace4f4a061e5487ce77b7A0397F9acD7ADA8BF4f] = 1;
        whiteList[0xaCF20245c0e60e4E79a1d080e03D7112354bE47c] = 5;
        whiteList[0xAe3C3d8F7d0bCa3ac8191D470173fBa38AC6338d] = 22;
        whiteList[0xAE97A8BfA58d9573aABA7b7d4339f9E027936bb7] = 2;
        whiteList[0xAEE9142Fbb594D2fdb270d6497428eF5880167e9] = 6;
        whiteList[0xAf28b3FF0969E56368d83137fAf2B04d1d39CF6a] = 1;
        whiteList[0xAF3cE683CD9593f63206f359625d7eE1C62072e9] = 1;
        whiteList[0xAf708AD676a9558206e108afC07bD798DDa0dafd] = 1;
        whiteList[0xAFa9bb2C6ED4B369DdAAc0B510700165D1D40FC5] = 4;
        whiteList[0xb0396C7b1102a978a87A863Fbca7FD095b933D58] = 5;
        whiteList[0xB079d24BA76dF7208FB55A047275D1f8737654B6] = 1;
        whiteList[0xB07Fb9076c9F421efc915385ce3EFFAE3182842F] = 2;
        whiteList[0xb0a4BA8ab848A84581c464e6E17caE2E620769eE] = 1;
        whiteList[0xb20A6b24E3c6eA252cc3B3073706aDD5BF6908c8] = 1;
        whiteList[0xb3676e348d0a77a8CC01964135D098D746346Bf8] = 16;
        whiteList[0xB46e03ae1D184a4090efB086BDDCE57770EF976e] = 3;
        whiteList[0xb5bDCa6E33fda852bD9df0fC6a3dd3ead7ac5A4a] = 73;
        whiteList[0xB6DF0e7E7be8E6B3EC047cdffBdDC198357d9d65] = 1;
        whiteList[0xb745364B2CDaE4Da02E513566C2fa3418a6d6826] = 1;
        whiteList[0xB7608D4E47F867eea5d8eb8379ED95238cEB2D2D] = 1;
        whiteList[0xb7F879787CF0eBD6825eb3234dAd90d1659948f0] = 1;
        whiteList[0xb832d4B24045690f5fC4476703fe0A35B4861F93] = 7;
        whiteList[0xB8FBf753C312A9f019B73904DAa2804383ab7324] = 13;
        whiteList[0xb8fc44EB23fc325356198818D0Ef2fec7aC0b6D7] = 1;
        whiteList[0xb9143a229BAdFCECD570e26e26bFc1d33D2A1fE6] = 3;
        whiteList[0xba4540a3D4914Ec852a554FDBFfC80f0820f989e] = 1;
        whiteList[0xBB070BaF5c12A125b87CB3A08BED6D397B9d962b] = 15;
        whiteList[0xBB7b86161D49A62dC0Fb9f5124500C7384dd1339] = 1;
        whiteList[0xBc1E4FAC9c0E10d466AAad6d35BB79241325b5c5] = 10;
        whiteList[0xBcf03166D5609Df19B0c0c1b1659966CBb0cA5d9] = 2;
        whiteList[0xBec8a402549EBA6f67722105A18da3389D9f094d] = 1;
        whiteList[0xbeebCDA5a3B321787cAF342ffeD6A458f29e6f15] = 3;
        whiteList[0xbfCDd24BA91b346bDf0B335A5162E928E25F1735] = 34;
        whiteList[0xc0A514315815c66e9b555E49b97B3b6ec04408B6] = 5;
        whiteList[0xC145CD123DA54F67CC2e61ff5D6338445B61de73] = 4;
        whiteList[0xC177CD31E6b23201e75411148787cD596B9233d1] = 72;
        whiteList[0xc2fD353FCD0a0E3c99f3e15a60508961ac890a79] = 1;
        whiteList[0xc319d409A8b297289E2aBa17b289c2925f41c857] = 1;
        whiteList[0xc4AF1032Aa1564BeeA7d3c21cC0c3048C1880304] = 1;
        whiteList[0xC7dB6357D08e5A29B1BC3ADf518BfF3Cdf635AF7] = 30;
        whiteList[0xc7E04E68B835dF274B647881Cc105a2B5FAd36f5] = 3;
        whiteList[0xc825D89c6F5247C37d84Db625d49f2d0299fA401] = 1;
        whiteList[0xc8cb5F540E0585de84CF838De01c37E62dc131d7] = 2;
        whiteList[0xC92a25Bdc029d8A55EC82B50ee9EB3dEdb2305aC] = 11;
        whiteList[0xC937B9426E1B02df7418FEa86888922acf5203E3] = 3;
        whiteList[0xC9FAc24a346f6BC3A240641d8921a4B91F760bF4] = 1;
        whiteList[0xCA7dbcd7D9773CD9F64eBd73920DcA9ce43c49ad] = 1;
        whiteList[0xCb0De375Ac3d35cB4346704D40127dbc92ACFDe7] = 10;
        whiteList[0xCbBb2733ec931ad094F791aC6256B2749c1DC3C1] = 200;
        whiteList[0xcc58C190F7b55eEe00F09437D766F05913194f7e] = 50;
        whiteList[0xcCF7AB664A9f51E0c3F6130950a575aE4f45f3a7] = 1;
        whiteList[0xCd87e8992b908779232414F6ff7507F899649077] = 2;
        whiteList[0xCdfe5F8f08ed476E0CCC4CaDbC3fe0D1b42876d3] = 2;
        whiteList[0xCe621E1Db598A3A60006F402D7530aF7F3ae737f] = 10;
        whiteList[0xcef845FcD3645F27722BBcf0F3583F0cE4168026] = 1;
        whiteList[0xCF2C5699a8696f9578d1992dBD1b2CE61b6e441d] = 91;
        whiteList[0xCFEc52223af7aa6546036e464cdAb388432c91Fa] = 1;
        whiteList[0xd03c4c2B5998bF77692FdDf6018A45ff822bE8aB] = 1;
        whiteList[0xD1032a082Da6dBB606787e377DC77ec57d50aB91] = 1;
        whiteList[0xd1049a4E6Ade876B93ffAC2689012a880BbfD31B] = 5;
        whiteList[0xD197B24EB9a74E1AcF7C0f258B1D6937BD98C62a] = 2;
        whiteList[0xD393985069bba87EDb407d1e9772B7f265073001] = 1;
        whiteList[0xD62137DDf43160B8Fbd4C5cEe170e4747091FA15] = 3;
        whiteList[0xd670e1330ae2c044769B77935C4768436b63bf3b] = 3;
        whiteList[0xd6De065069632B7871208016e6f7bF57E32a30dc] = 2;
        whiteList[0xd744ec54A619f2474d331d382b820c39422F32ba] = 1;
        whiteList[0xD78220606D2C2e67554B95686eeeA12AbA7A6625] = 2;
        whiteList[0xD7BF52dC6498788c60337AB83876e3d37b6A345a] = 2;
        whiteList[0xD7ff2D1588d47cDcECe05E33968a84a6BDC2fEb1] = 6;
        whiteList[0xd803633480E7EE47403a80FCB7d3BFb8fD6D601f] = 14;
        whiteList[0xD80fF0e3A570e66324ECDCb0DA32425f77466e2C] = 15;
        whiteList[0xD82dC63fa437CD41e1659F993cb394A0dD2FD115] = 2;
        whiteList[0xd85686984dF2d99aFe2d2cf48d5aaeA84A516dE2] = 1;
        whiteList[0xD9Bd57133F1B17d6cFF4bAaAfb2c7D57bDEd7B0F] = 25;
        whiteList[0xdAC82863b5ac45BEF8Df418c47874B3e97cc5b49] = 1;
        whiteList[0xDade2Ed550a70eed39a43B07791e689E18d1ec60] = 1;
        whiteList[0xdb8ba5a25542Cd744482ee5E63D27adE9e7d927C] = 2;
        whiteList[0xDD156cB6552AcE53af81eb2c647110bd4486224A] = 3;
        whiteList[0xDd1C982C2169485136D0349DF562494642adB305] = 7;
        whiteList[0xde63f011b86767aD578980FFe1f5DeD77ebc4265] = 1;
        whiteList[0xDeC111F162838BDC81336f4e01065Fe06309075d] = 1;
        whiteList[0xE05345732079186c49D3C98A28Cdc40b656eF445] = 1;
        whiteList[0xE118B4f9CFfbCe9530831Ce1aB8D426E6274ba47] = 3;
        whiteList[0xE127542c51A1ACf674cA076c33f954abf3460b02] = 5;
        whiteList[0xe14b4585795bEFEa1B08A4317b46ca218000AC93] = 9;
        whiteList[0xE19C93C8B77DdF06c9DD8e77D867D19920336666] = 1;
        whiteList[0xE32A47D3FC34F17CBF4FE3E7Fa9E7aEBD7ed10c6] = 8;
        whiteList[0xE5475694dbDa631a7d88Fff7d1b751A457B76824] = 1;
        whiteList[0xe599aA2bfBDF6e0Bc042f83c80F16aA66Bfa04bF] = 5;
        whiteList[0xE5F44679300c5fa44cEe33be6CC40173BB9a268c] = 15;
        whiteList[0xE653ab25AEbcBb3Fdf1A7618a2d7A56B6D8fc11c] = 1;
        whiteList[0xe83E50a7b1d8D02832eaB3EDb8D1Cb381Ef79704] = 6;
        whiteList[0xE8761B3270D7E5DbC6C56a81625Df1C728Ff9EA9] = 5;
        whiteList[0xe95c99B3Ccde316624D6318433C17a53E7dD3d18] = 150;
        whiteList[0xE9AF94a913099d37bd01ECD168A181a20847C732] = 3;
        whiteList[0xEb11D86833e1Cd7bB1AEDc1aBeAea904B38eA21D] = 3;
        whiteList[0xEe81e0b37A1736234bEDFD6d37d38DF1A570787D] = 15;
        whiteList[0xeedcC4D7d9ea1C9c1d1944717a1dFc73663d7D45] = 2;
        whiteList[0xf1d0d0d85d975fbA31700cE3C8D2ba07C7468E7d] = 2;
        whiteList[0xF20b0673718bF4DF7E1132eb6bDAaDc7330A20Fe] = 1;
        whiteList[0xF34B1b5D188743eb0970095D0F578A103366Ee25] = 5;
        whiteList[0xF438a2D2Bfd0BA733708348519222c80Fc7B521d] = 1;
        whiteList[0xF51490B452fD12eAe4674005343002B37dB2Cb6C] = 1;
        whiteList[0xf6dA0f62EeB7D27a3C181d92f849fca1ec8F32e1] = 1;
        whiteList[0xf7C4788E335f4c9B67E8D28eb90f5fD0347bF5B5] = 2;
        whiteList[0xf7f832498d5FcBb95C435b8Ba8aC26231Afc8606] = 2;
        whiteList[0xf80853697a855346F6D3c5e4ee5D5fB41a005586] = 1;
        whiteList[0xf8a4D48323AB962581fEAAbb5621fFD5db8fb4c0] = 1;
        whiteList[0xfB43f0333aeAA535582141CF28AB209AE85aD52a] = 3;
        whiteList[0xfCe303560116D5880B8CC59BfA3ACa5b24c0297B] = 1;
        whiteList[0xFDcc8aff007890cd3CF0bE646BE50898D3914835] = 8;
        whiteList[0xFe2bfc5b6DE568bBBEDe911477DEFc08d3DD557F] = 2;
        whiteList[0xFe60aCBDB8487B61d015a999a7519c087C3904E8] = 5;
        whiteList[0xFebe5cb3Cf3274E9570B71Bf5Ff8Aa4590f375eB] = 2;
        whiteList[0xfeD79641f2f8AEca217a25a57bf9dA1B0cca3575] = 1;
        whiteList[0xffccf17D09E0585e7C1bA3A3584fC9356C93d11F] = 5;
    }
}