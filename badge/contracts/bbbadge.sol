pragma solidity ^0.5.0;

import "./MyTokenBadgeFootStone.sol";

import "./ManagerContract.sol";

interface MetadataConverter {

    function tokenSLogoURI() view external returns (string memory);
    function tokenBLogoURI() view external returns (string memory);
    function tokenSLogoBGURI() view external returns (string memory);
    function tokenBLogoBGURI() view external returns (string memory);
    function tokenBGURI() view external returns (string memory);
    function tokenURI(uint256 _tokenId) view external returns (string memory);
    function name(uint256 _tokenId) view external returns (string memory);
}

contract DiceConquerorBadge is MyTokenBadgeFootStone, ManagerContract, ERC721Enumerable, ERC721Metadata{

    bytes4 private constant InterfaceId_ERC721Enumerable = 0x780e9d63;
    /**
    * 0x780e9d63 ===
    *   bytes4(keccak256('totalSupply()')) ^
    *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
    *   bytes4(keccak256('tokenByIndex(uint256)'))
    */

    bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
    /**
    * 0x5b5e139f ===
    *   bytes4(keccak256('name()')) ^
    *   bytes4(keccak256('symbol()')) ^
    *   bytes4(keccak256('tokenURI(uint256)'))
    */

    string public constant NAME = "DiceConquerorBadge";
    string public constant SYMBOL = "DCB";
    uint total;
    MetadataConverter metadataURIConverter;
    address public manager;

    constructor() public{
        total = 0;
    }

    modifier check() {
      if (msg.sender == manager) _;
    }

    function upgradeManager(address new_address) public restricted {
        manager = new_address;
    }

    function updateURIConverter (address _URIConverter) public restricted {
        metadataURIConverter = MetadataConverter(_URIConverter);
    }

    function name() external view returns (string memory){
        return NAME;
    }

    function badgeName(uint256 _tokenId) external view returns (string memory){
        return Strings.strConcat(NAME, metadataURIConverter.name(_tokenId));
    }

    function symbol() external view returns (string memory){
        return SYMBOL;
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory){
        return metadataURIConverter.tokenURI(_tokenId);
    }

    function tokenSLogoURI() external view returns (string memory){
        return metadataURIConverter.tokenSLogoURI();
    }

    function tokenBLogoURI() external view returns (string memory){
        return metadataURIConverter.tokenBLogoURI();
    }

    function tokenSLogoBGURI() external view returns (string memory){
        return metadataURIConverter.tokenSLogoBGURI();
    }

    function tokenBLogoBGURI() external view returns (string memory){
        return metadataURIConverter.tokenBLogoBGURI();
    }

    function tokenBGURI() external view returns (string memory){
        return metadataURIConverter.tokenBGURI();
    }

    function totalSupply() view public returns (uint256){
        return total;
    }

    function tokenByIndex(uint256 _index) external view returns (uint256){
        require(_index < totalSupply());
        return _index;
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256){

        return ownedTokens[_owner][_index];
    }

    function addNewBadge(address _owner, uint256 _tokenId) public check {

        // log("addNewBadge", uint(1));
        require(total == uint(_tokenId));
        // log("addNewBadge", uint(2));
        tokenOwner[_tokenId] = _owner;
        // log("addNewBadge", uint(3));
        uint256 length = ownedTokens[_owner].length;
        // log("addNewBadge", uint(4));
        require(length == uint32(length));
        // log("addNewBadge", uint(5));
        ownedTokens[_owner].push(uint8(_tokenId));
        // log("addNewBadge", uint(6));
        ownedTokensIndex.push(uint32(length));
        // log("addNewBadge", uint(7));
        total = total + 1;
    }
}
