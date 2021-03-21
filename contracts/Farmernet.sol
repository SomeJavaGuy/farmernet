// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract FarmerNetLand is ERC721, VRFConsumerBase, Ownable {
    using SafeMath for uint256;
    using Strings for string;

    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    address public VRFCoordinator;
    // rinkeby: 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B
    address public LinkToken;
    // rinkeby: 0x01BE23585060835E02B77ef475b0Cc51aA1e0709a

    struct FarmerNetLand {
        // land and their stats
        uint256 longitude;
        uint256 latitude;
        uint256 carbon_emissions;
        string name;
    }

    FarmerNetLand[] public Land;
    // keep track of our land + mappings (for random data request/return to match )
    mapping(bytes32 => string) requestToLandName;
    mapping(bytes32 => address) requestToSender;
    mapping(bytes32 => uint256) requestToTokenId;

    /**
     * Constructor inherits VRFConsumerBase
     *
     * Network: Rinkeby
     * Chainlink VRF Coordinator address: 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B
     * LINK token address:                0x01BE23585060835E02B77ef475b0Cc51aA1e0709
     * Key Hash: 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311
     */
    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash)
        public
        VRFConsumerBase(_VRFCoordinator, _LinkToken)
        ERC721("FarmerNetLand", "D&D")
    {   
        VRFCoordinator = _VRFCoordinator;
        LinkToken = _LinkToken;
        keyHash = _keyhash;
        fee = 0.1 * 10**18; // hardcoded 0.1 LINK
    }

    function requestNewRandomLand(
        uint256 userProvidedSeed,
        string memory name
    ) public returns (bytes32) {
        // chainlink and truffle
        require(
            LINK.balanceOf(address(this)) >= fee,
            "Not enough LINK - fill contract with faucet"
        );
        // get random number from chainlink VRF
        bytes32 requestId = requestRandomness(keyHash, fee, userProvidedSeed);
        requestToLandName[requestId] = name;
        requestToSender[requestId] = msg.sender;
        return requestId;
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        return tokenURI(tokenId);
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        // link to OpenSea tokenURI
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _setTokenURI(tokenId, _tokenURI);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber)
    // request randomnumber - now return randomnumber to define creation of NFT
    // mapping to make sure data matches
        internal
        override
    {
        uint256 newId = Land.length;
        uint256 longitude = (randomNumber % 100);
        uint256 latitude = ((randomNumber % 10000) / 100 );
        uint256 carbon_emission = ((randomNumber % 1000000) / 10000 );
        uint256 experience = 0;

        // random number request associated with land name 
        // push to farmernet 
        farmernetland.push(
            Land(
                Longitude,
                latitude,
                carbon_emissions,
                requestToLandName[requestId]
            )
        );
        // sender == owner of the NFT , safemint mints the NFT with tokenID 
        _safeMint(requestToSender[requestId], newId);
    }

    
    function getLevel(uint256 tokenId) public view returns (uint256) {
        return sqrt(FarmerNetLand[tokenId].experience);
    }

    function getNumberOfland() public view returns (uint256) {
        return land.length; 
    }

    function getLandOverView(uint256 tokenId)
        public
        view
        returns (
            string memory,
            uint256,
            uint256,
            uint256
        )
    {
        return (
            Land[tokenId].name,
            Land[tokenId].strength + Land[tokenId].dexterity + Land[tokenId].constitution + Land[tokenId].intelligence + Land[tokenId].wisdom + Land[tokenId].charisma,
            getLevel(tokenId),
            Land[tokenId].experience
        );
    }

    function getLandtats(uint256 tokenId)
        public
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        return (
            Land[tokenId].longitude,
            Land[tokenId].latitude,
            Land[tokenId].carbon_emission,
        );
    }

    function sqrt(uint256 x) internal view returns (uint256 y) {
        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}
