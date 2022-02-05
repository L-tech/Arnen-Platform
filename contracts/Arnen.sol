//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "./Base64.sol";

contract Arnen is ERC721URIStorage, Ownable, VRFConsumerBase {
    bool public saleIsActive;
    address private arnenCreator = 0x3ae68d8eFB25C137aBd52F16f3fF3067856aa175;
    mapping(address => uint256[]) public holderTokendIds;
    struct TokenHolder {
        address holderAddress;
        uint tokenId;
        uint txTime;
        bool isTokenHolder;
    }
    mapping(address => TokenHolder) public tokenHolders;
    address[] public holderAddresses;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    enum Mode {
        Time,
        Activity,
        Certification
    }
    Mode public nftMode;
    uint public minTip = 350000000000000;
    uint public mintPricePerDay = 280000000000000;
    uint public mintPricePerActivity = 1700000000000000; 
    uint public mintPriceCert = 1700000000000000;
    uint public totalAmountTipped = 0; 
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    event Tipped(address indexed _address, uint256 _amount);
    event SentTipped(address indexed _beneficiary, uint _amount, bytes _data);
    constructor() ERC721("ARNEN", "ARN") VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // VRF Coordinator
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // LINK Token
        ) payable {
        _tokenIds.increment();
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18; // 0.1 LINK (Varies by network)
    }
    function checkTokenHolder(address _address) public view returns(bool isIndeed) {
        return tokenHolders[_address].isTokenHolder;
    }
    function openNFTSale() public onlyOwner {
        saleIsActive = true;
    }
    function closeSale() public onlyOwner {
        saleIsActive = false;
    }
    function getTokenHoldersCount() public view returns(uint entityCount) {
        return holderAddresses.length;
    }
    function mint(uint256 _validity, Mode _mode) public payable {
        require(saleIsActive, "Can't Purchase NFT as at this time");
        nftMode = _mode;
        if(uint256(nftMode) == 0) {
            require(msg.value >= mintPricePerDay * _validity, "Insufficient Funds");
            string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{ "name": "Arnen #',
                        Strings.toString(_tokenIds.current()),
                        '", "description": "A Special Time Based NFT to gain access to the Arnen Platform", ',
                        '"traits": [{ "trait_type": "Mode", "value": "Time" }, { "trait_type": "Validity", "value": _validity }, {"trait_type": "Status", "value": "active"}], ',
                        '"image": "ipfs://QmUuXqMvJckFhfoEaLFMEfum6roqgrjQedoRuitizw3kwQ" }'
                        )
                    )
                )
            );
            string memory tokenURI = string(
                abi.encodePacked("data:application/json;base64,", json)
            );
            console.log(tokenURI);
            _safeMint(msg.sender, _tokenIds.current());
            _setTokenURI(_tokenIds.current(), tokenURI);
            tokenHolders[msg.sender].holderAddress= msg.sender;
            tokenHolders[msg.sender].tokenId= _tokenIds.current();
            tokenHolders[msg.sender].txTime= block.timestamp;
            tokenHolders[msg.sender].isTokenHolder= true;
            holderAddresses.push(msg.sender);
            _tokenIds.increment();
        }
        else if(uint256(nftMode) == 1) {
            require(msg.value >= mintPricePerActivity * _validity, "Insufficient Funds");
            string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{ "name": "Arnen #',
                        Strings.toString(_tokenIds.current()),
                        '", "description": "A Special Activity Based NFT to gain access to the Arnen Platform", ',
                        '"traits": [{ "trait_type": "Mode", "value": "Activity" }, { "trait_type": "Validity", "value": _validity }, {"trait_type": "Status", "value": "active"}], ',
                        '"image": "ipfs://QmUuXqMvJckFhfoEaLFMEfum6roqgrjQedoRuitizw3kwQ" }'
                        )
                    )
                )
            );
            string memory tokenURI = string(
                abi.encodePacked("data:application/json;base64,", json)
            );
            console.log(tokenURI);
            _safeMint(msg.sender, _tokenIds.current());
            _setTokenURI(_tokenIds.current(), tokenURI);
            tokenHolders[msg.sender].holderAddress= msg.sender;
            tokenHolders[msg.sender].tokenId= _tokenIds.current();
            tokenHolders[msg.sender].txTime= block.timestamp;
            tokenHolders[msg.sender].isTokenHolder= true;
            holderAddresses.push(msg.sender);
            _tokenIds.increment();
        }
        else if(uint256(nftMode) == 2) {
            require(msg.value >= mintPriceCert, "Insufficient Funds");
            string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{ "name": "Arnen #',
                        Strings.toString(_tokenIds.current()),
                        '", "description": "A Special Activity Based NFT to gain access to the Arnen Platform", ',
                        '"traits": [{ "trait_type": "Mode", "value": "Certification" }, { "trait_type": "Validity", "value": _validity }, {"trait_type": "Status", "value": "active"}], ',
                        '"image": "ipfs://QmUuXqMvJckFhfoEaLFMEfum6roqgrjQedoRuitizw3kwQ" }'
                        )
                    )
                )
            );
            string memory tokenURI = string(
                abi.encodePacked("data:application/json;base64,", json)
            );
            console.log(tokenURI);
            _safeMint(msg.sender, _tokenIds.current());
            _setTokenURI(_tokenIds.current(), tokenURI);
            tokenHolders[msg.sender].holderAddress= msg.sender;
            tokenHolders[msg.sender].tokenId= _tokenIds.current();
            tokenHolders[msg.sender].txTime= block.timestamp;
            tokenHolders[msg.sender].isTokenHolder= true;
            holderAddresses.push(msg.sender);
            _tokenIds.increment();
        }
        
    }

    function renewNft(uint256 _validity, Mode _mode) public payable {
        require(saleIsActive, "Can't Purchase NFT as at this time");
        nftMode = _mode;
        if(!checkTokenHolder(msg.sender)) revert();
        uint userTokenId = tokenHolders[msg.sender].tokenId;
        if(uint256(nftMode) == 0) {
            require(msg.value >= mintPricePerDay * _validity, "Insufficient Funds");
            string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{ "name": "Arnen #',
                        userTokenId,
                        '", "description": "A Special Time Based NFT to gain access to the Arnen Platform", ',
                        '"traits": [{ "trait_type": "Mode", "value": "Time" }, { "trait_type": "Validity", "value": _validity }, {"trait_type": "Status", "value": "active"}], ',
                        '"image": "ipfs://QmUuXqMvJckFhfoEaLFMEfum6roqgrjQedoRuitizw3kwQ" }'
                        )
                    )
                )
            );
            string memory tokenURI = string(
                abi.encodePacked("data:application/json;base64,", json)
            );
            console.log(tokenURI);
            _safeMint(msg.sender, userTokenId);
            _setTokenURI(userTokenId, tokenURI);
            _tokenIds.increment();
        }
        else if(uint256(nftMode) == 1) {
            require(msg.value >= mintPricePerActivity * _validity, "Insufficient Funds");
            string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{ "name": "Arnen #',
                        userTokenId,
                        '", "description": "A Special Activity Based NFT to gain access to the Arnen Platform", ',
                        '"traits": [{ "trait_type": "Mode", "value": "Activity" }, { "trait_type": "Validity", "value": _validity }, {"trait_type": "Status", "value": "active"}], ',
                        '"image": "ipfs://QmUuXqMvJckFhfoEaLFMEfum6roqgrjQedoRuitizw3kwQ" }'
                        )
                    )
                )
            );
            string memory tokenURI = string(
                abi.encodePacked("data:application/json;base64,", json)
            );
            console.log(tokenURI);
            _safeMint(msg.sender, userTokenId);
            _setTokenURI(userTokenId, tokenURI);
            _tokenIds.increment();
        }
        else if(uint256(nftMode) == 2) {
            require(msg.value >= mintPriceCert, "Insufficient Funds");
            string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{ "name": "Arnen #',
                        userTokenId,
                        '", "description": "A Special Activity Based NFT to gain access to the Arnen Platform", ',
                        '"traits": [{ "trait_type": "Mode", "value": "Certification" }, { "trait_type": "Validity", "value": _validity }, {"trait_type": "Status", "value": "active"}], ',
                        '"image": "ipfs://QmUuXqMvJckFhfoEaLFMEfum6roqgrjQedoRuitizw3kwQ" }'
                        )
                    )
                )
            );
            string memory tokenURI = string(
                abi.encodePacked("data:application/json;base64,", json)
            );
            console.log(tokenURI);
            _safeMint(msg.sender,userTokenId);
            _setTokenURI(userTokenId, tokenURI);
            holderAddresses.push(msg.sender);
            _tokenIds.increment();
        }
        
    }

    // update - change NFT validity after 24 hours for Time based and after a click for activity baseed NFT

    function tip() public payable returns (bool) {
        require(msg.value >= minTip, "Minimum tip is 0.00035");
        totalAmountTipped += msg.value;
        emit Tipped(msg.sender, msg.value);
        return true;
        
    }

    function getRandomNumber() public returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        uint 
        randomResult = (randomness % getTokenHoldersCount() - 1) + 1;
    }
    function DistributeTip() public onlyOwner payable {
        // This returns a boolean value indicating success or failure.
        require(msg.value <= totalAmountTipped, "Insuffiecient Amount");
        address payable beneficiary = payable(holderAddresses[randomResult]);
        uint beneficiaryAmount = (30 * msg.value) / 100;
        (bool sent, bytes memory data) = beneficiary.call{value: beneficiaryAmount}("");
        payable(arnenCreator).transfer(msg.value - beneficiaryAmount);
        totalAmountTipped -= msg.value;
        emit SentTipped(beneficiary, beneficiaryAmount, data);
        require(sent, "Failed to send Ether");
    }

    

    receive() external payable {}
    fallback() external payable {}
}