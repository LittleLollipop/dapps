pragma solidity ^0.4.23;

interface ERC721 /* is ERC165 */ {
   
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner) external view returns (uint256);

    function ownerOf(uint256 _tokenId) external view returns (address);

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) payable;

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;

    function approve(address _approved, uint256 _tokenId) external payable;

    function setApprovalForAll(address _operator, bool _approved) external;

    function getApproved(uint256 _tokenId) view returns (address);

    function isApprovedForAll(address _owner, address _operator) view returns (bool);
}

interface ERC165 {
   
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

/// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
interface ERC721TokenReceiver {
  
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
}

interface ERC721Metadata /* is ERC721 */ {
    
    function name() external view returns (string _name);

    function symbol() external view returns (string _symbol);

    function tokenURI(uint256 _tokenId) external view returns (string);
}

interface ERC721Enumerable /* is ERC721 */ {
    
    function totalSupply() external view returns (uint256);

    function tokenByIndex(uint256 _index) external view returns (uint256);

    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
}

library Strings {
    
  // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
  function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
      bytes memory _ba = bytes(_a);
      bytes memory _bb = bytes(_b);
      bytes memory _bc = bytes(_c);
      bytes memory _bd = bytes(_d);
      bytes memory _be = bytes(_e);
      string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
      bytes memory babcde = bytes(abcde);
      uint k = 0;
      for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
      for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
      for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
      for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
      for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
      return string(babcde);
    }

    function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
        return strConcat(_a, _b, _c, _d, "");
    }

    function strConcat(string _a, string _b, string _c) internal pure returns (string) {
        return strConcat(_a, _b, _c, "", "");
    }

    function strConcat(string _a, string _b) internal pure returns (string) {
        return strConcat(_a, _b, "", "", "");
    }

    function uint2str(uint i) internal pure returns (string) {
        if (i == 0) return "0";
        uint j = i;
        uint len;
        while (j != 0){
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (i != 0){
            bstr[k--] = byte(48 + i % 10);
            i /= 10;
        }
        return string(bstr);
    }
}

library AddressUtils {

  /**
   * Returns whether the target address is a contract
   * @dev This function will return false if invoked during the constructor of a contract,
   * as the code is not actually created until after the constructor finishes.
   * @param addr address to check
   * @return whether the target address is a contract
   */
    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        // XXX Currently there is no better way to check if there is a contract in an address
        // than to check the size of the code at that address.
        // See https://ethereum.stackexchange.com/a/14016/36603
        // for more details about how this works.
        // TODO Check this again before the Serenity release, because all addresses will be
        // contracts then.
        // solium-disable-next-line security/no-inline-assembly
        assembly { size := extcodesize(addr) }
        return size > 0;
    }

}

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

contract MyTokenBadgeFootStone is ERC721, ERC165 {

    bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
    
    bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;

    bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
    /*
    * 0x80ac58cd ===
    *   bytes4(keccak256('balanceOf(address)')) ^
    *   bytes4(keccak256('ownerOf(uint256)')) ^
    *   bytes4(keccak256('approve(address,uint256)')) ^
    *   bytes4(keccak256('getApproved(uint256)')) ^
    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
    */

    mapping(bytes4 => bool) internal supportedInterfaces;

    mapping (uint256 => address) internal tokenOwner;

    mapping(address => uint8[]) internal ownedTokens;

    mapping (uint256 => address) internal tokenApprovals;

    mapping (address => mapping (address => bool)) internal operatorApprovals;

    uint32[] ownedTokensIndex;

    using SafeMath for uint256;
    using AddressUtils for address;
    using Strings for string;

    constructor() public {
        _registerInterface(InterfaceId_ERC165);
        _registerInterface(InterfaceId_ERC721);
    }

    function supportsInterface(bytes4 _interfaceId) external view returns (bool) {
        return supportedInterfaces[_interfaceId];
    }

    function balanceOf(address _owner) view returns (uint256){
        return ownedTokens[_owner].length;
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = tokenOwner[_tokenId];
        require(owner != address(0));
        return owner;
    }

    function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool){
        address owner = ownerOf(_tokenId);
        // Disable solium check because of
        // https://github.com/duaraghav8/Solium/issues/175
        // solium-disable-next-line operator-whitespace
        return (_spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender));
    }

    modifier canTransfer(uint256 _tokenId) {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _;
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) payable canTransfer(_tokenId){
        require(_from != address(0));
        require(_to != address(0));

        clearApproval(_from, _tokenId);
        removeTokenFrom(_from, _tokenId);
        addTokenTo(_to, _tokenId);

        emit Transfer(_from, _to, _tokenId);
    }

    function checkAndCallSafeTransfer(address _from, address _to, uint256 _tokenId, bytes _data) internal returns (bool){
        if (!_to.isContract()) {
            return true;
        }
        bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
        return (retval == ERC721_RECEIVED);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) payable{
        transferFrom(_from, _to, _tokenId);

        require(checkAndCallSafeTransfer(_from, _to, _tokenId, data));
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) payable{
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    function clearApproval(address _owner, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _owner);
        if (tokenApprovals[_tokenId] != address(0)) {
            tokenApprovals[_tokenId] = address(0);
        }
    }

    function removeTokenFrom(address _from, uint256 _tokenId) internal {
        require(ownerOf(_tokenId) == _from);
        tokenOwner[_tokenId] = address(0);


        uint32 tokenIndex = ownedTokensIndex[_tokenId];
        uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
        uint8 lastToken = ownedTokens[_from][lastTokenIndex];

        ownedTokens[_from][tokenIndex] = lastToken;
        ownedTokens[_from][lastTokenIndex] = 0;

        ownedTokens[_from].length--;
        ownedTokensIndex[_tokenId] = 0;
        ownedTokensIndex[lastToken] = tokenIndex;
    }

    function addTokenTo(address _to, uint256 _tokenId) internal {
        require(tokenOwner[_tokenId] == address(0));
        tokenOwner[_tokenId] = _to;

        uint256 length = ownedTokens[_to].length;
        
        require(length == uint32(length));
        ownedTokens[_to].push(uint8(_tokenId));

        ownedTokensIndex[_tokenId] = uint32(length);
    }

    function approve(address _approved, uint256 _tokenId) external payable{
        address owner = ownerOf(_tokenId);
        require(_approved != owner);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender));

        tokenApprovals[_tokenId] = _approved;
        emit Approval(owner, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external{
        require(_operator != msg.sender);
        operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) public view returns (address) {
        return tokenApprovals[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) public view returns (bool){
        return operatorApprovals[_owner][_operator];
    }

    function _registerInterface(bytes4 _interfaceId) internal {
        require(_interfaceId != 0xffffffff);
        supportedInterfaces[_interfaceId] = true;
    }

    function () payable{
        require(false);
    }
}

