pragma solidity ^0.4.23;

import "./MyTokenBadgeFootStone.sol";

import "./ManagerContract.sol";


interface MetadataConverter {
	function tokenBaseMapURI() view returns (string);
	function tokenIconURI() view returns (string);	
	function tokenURI(uint256 _tokenId) view returns (string);	
	function name(uint256 _tokenId) view returns (string);
}


contract GenesisBadge is MyTokenBadgeFootStone, ManagerContract, ERC721Enumerable, ERC721Metadata {

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

	string public constant NAME = "GenesisBadge";
    string public constant SYMBOL = "GB";
    uint total = 50;
    MetadataConverter metadataURIConverter;

	constructor() public {
        _registerInterface(InterfaceId_ERC721Enumerable);
        _registerInterface(InterfaceId_ERC721Metadata);

        tokenOwner[0] = owner;
        tokenOwner[1] = owner;
        tokenOwner[2] = owner;
        tokenOwner[3] = owner;
        tokenOwner[4] = owner;
        tokenOwner[5] = owner;
        tokenOwner[6] = owner;
        tokenOwner[7] = owner;
        tokenOwner[8] = owner;
        tokenOwner[9] = owner;
        tokenOwner[10] = owner;
        tokenOwner[11] = owner;
        tokenOwner[12] = owner;
        tokenOwner[13] = owner;
        tokenOwner[14] = owner;
        tokenOwner[15] = owner;
        tokenOwner[16] = owner;
        tokenOwner[17] = owner;
        tokenOwner[18] = owner;
        tokenOwner[19] = owner;
        tokenOwner[20] = owner;
        tokenOwner[21] = owner;
        tokenOwner[22] = owner;
        tokenOwner[23] = owner;
        tokenOwner[24] = owner;
        tokenOwner[25] = owner;
        tokenOwner[26] = owner;
        tokenOwner[27] = owner;
        tokenOwner[28] = owner;
        tokenOwner[29] = owner;
        tokenOwner[30] = owner;
        tokenOwner[31] = owner;
        tokenOwner[32] = owner;
        tokenOwner[33] = owner;
        tokenOwner[34] = owner;
        tokenOwner[35] = owner;
        tokenOwner[36] = owner;
        tokenOwner[37] = owner;
        tokenOwner[38] = owner;
        tokenOwner[39] = owner;
        tokenOwner[40] = owner;
        tokenOwner[41] = owner;
        tokenOwner[42] = owner;
        tokenOwner[43] = owner;
        tokenOwner[44] = owner;
        tokenOwner[45] = owner;
        tokenOwner[46] = owner;
        tokenOwner[47] = owner;
        tokenOwner[48] = owner;
        tokenOwner[49] = owner;

        ownedTokens[owner].push(uint8(0));
        ownedTokens[owner].push(uint8(1));
        ownedTokens[owner].push(uint8(2));
        ownedTokens[owner].push(uint8(3));
        ownedTokens[owner].push(uint8(4));
        ownedTokens[owner].push(uint8(5));
        ownedTokens[owner].push(uint8(6));
        ownedTokens[owner].push(uint8(7));
        ownedTokens[owner].push(uint8(8));
        ownedTokens[owner].push(uint8(9));
        ownedTokens[owner].push(uint8(10));
        ownedTokens[owner].push(uint8(11));
        ownedTokens[owner].push(uint8(12));
        ownedTokens[owner].push(uint8(13));
        ownedTokens[owner].push(uint8(14));
        ownedTokens[owner].push(uint8(15));
        ownedTokens[owner].push(uint8(16));
        ownedTokens[owner].push(uint8(17));
        ownedTokens[owner].push(uint8(18));
        ownedTokens[owner].push(uint8(19));
        ownedTokens[owner].push(uint8(20));
        ownedTokens[owner].push(uint8(21));
        ownedTokens[owner].push(uint8(22));
        ownedTokens[owner].push(uint8(23));
        ownedTokens[owner].push(uint8(24));
        ownedTokens[owner].push(uint8(25));
        ownedTokens[owner].push(uint8(26));
        ownedTokens[owner].push(uint8(27));
        ownedTokens[owner].push(uint8(28));
        ownedTokens[owner].push(uint8(29));
        ownedTokens[owner].push(uint8(30));
        ownedTokens[owner].push(uint8(31));
        ownedTokens[owner].push(uint8(32));
        ownedTokens[owner].push(uint8(33));
        ownedTokens[owner].push(uint8(34));
        ownedTokens[owner].push(uint8(35));
        ownedTokens[owner].push(uint8(36));
        ownedTokens[owner].push(uint8(37));
        ownedTokens[owner].push(uint8(38));
        ownedTokens[owner].push(uint8(39));
        ownedTokens[owner].push(uint8(40));
        ownedTokens[owner].push(uint8(41));
        ownedTokens[owner].push(uint8(42));
        ownedTokens[owner].push(uint8(43));
        ownedTokens[owner].push(uint8(44));
        ownedTokens[owner].push(uint8(45));
        ownedTokens[owner].push(uint8(46));
        ownedTokens[owner].push(uint8(47));
        ownedTokens[owner].push(uint8(48));
        ownedTokens[owner].push(uint8(49));

		ownedTokensIndex.push(0);
		ownedTokensIndex.push(1);
		ownedTokensIndex.push(2);
		ownedTokensIndex.push(3);
		ownedTokensIndex.push(4);
		ownedTokensIndex.push(5);
		ownedTokensIndex.push(6);
		ownedTokensIndex.push(7);
		ownedTokensIndex.push(8);
		ownedTokensIndex.push(9);
		ownedTokensIndex.push(10);
		ownedTokensIndex.push(11);
		ownedTokensIndex.push(12);
		ownedTokensIndex.push(13);
		ownedTokensIndex.push(14);
		ownedTokensIndex.push(15);
		ownedTokensIndex.push(16);
		ownedTokensIndex.push(17);
		ownedTokensIndex.push(18);
		ownedTokensIndex.push(19);
		ownedTokensIndex.push(20);
		ownedTokensIndex.push(21);
		ownedTokensIndex.push(22);
		ownedTokensIndex.push(23);
		ownedTokensIndex.push(24);
		ownedTokensIndex.push(25);
		ownedTokensIndex.push(26);
		ownedTokensIndex.push(27);
		ownedTokensIndex.push(28);
		ownedTokensIndex.push(29);
		ownedTokensIndex.push(30);
		ownedTokensIndex.push(31);
        ownedTokensIndex.push(32);
        ownedTokensIndex.push(33);
        ownedTokensIndex.push(34);
        ownedTokensIndex.push(35);
        ownedTokensIndex.push(36);
        ownedTokensIndex.push(37);
        ownedTokensIndex.push(38);
        ownedTokensIndex.push(39);
        ownedTokensIndex.push(40);
        ownedTokensIndex.push(41);
        ownedTokensIndex.push(42);
        ownedTokensIndex.push(43);
        ownedTokensIndex.push(44);
        ownedTokensIndex.push(45);
        ownedTokensIndex.push(46);
        ownedTokensIndex.push(47);
        ownedTokensIndex.push(48);
        ownedTokensIndex.push(49);

    }

    function updateURIConverter (address _URIConverter) restricted {
    	metadataURIConverter = MetadataConverter(_URIConverter);
    }

    function name() external view returns (string){
    	return NAME;
    }

    function badgeName(uint256 _tokenId) external view returns (string){
    	return Strings.strConcat(NAME, metadataURIConverter.name(_tokenId));
    }

    function symbol() external view returns (string){
    	return SYMBOL;
    }

    function tokenURI(uint256 _tokenId) external view returns (string){
    	return metadataURIConverter.tokenURI(_tokenId);
    }

	function tokenBaseMapURI() external view returns (string){
    	return metadataURIConverter.tokenBaseMapURI();
    }

    function tokenIconURI() external view returns (string){
    	return metadataURIConverter.tokenIconURI();
    }

    function totalSupply() view returns (uint256){
    	return total;
    }

    function tokenByIndex(uint256 _index) external view returns (uint256){
    	require(_index < totalSupply());
        return _index;
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256){
		require(_index < balanceOf(_owner));
        return ownedTokens[_owner][_index];
    }
}

