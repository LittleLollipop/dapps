pragma solidity ^0.5.0;

contract BadgeShadow{

  BadgeShadow badge;

  constructor() public {
      badge = new Badge(0x7F188ae034F8CcA9d5F6a03D35Fa02302060Df82)
  }

  function balanceOf(address _owner) view returns (uint256){
      return badge.balanceOf(_owner)
  }

  function ownerOf(uint256 _tokenId) public view returns (address) {
      return badge.ownerOf(_tokenId)
  }

  function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool){
      return badge.isApprovedOrOwner(_spender, _tokenId)
  }

  function getApproved(uint256 _tokenId) public view returns (address) {
      return badge.getApproved(_tokenId)
  }

  function isApprovedForAll(address _owner, address _operator) public view returns (bool){
      return badge.isApprovedForAll(_owner, _operator)
  }

  function tokenSLogoURI() view returns (string){
      return badge.tokenSLogoURI()
  }

  function tokenBLogoURI() view returns (string){
      return badge.tokenBLogoURI()
  }

  function tokenSLogoBGURI() view returns (string){
      return badge.tokenSLogoBGURI()
  }

  function tokenBLogoBGURI() view returns (string){
      return badge.tokenBLogoBGURI()
  }

  function tokenBGURI() view returns (string){
      return badge.tokenBGURI()
  }

  function tokenURI(uint256 _tokenId) view returns (string){
      return badge.tokenURI(_tokenId)
  }

  function name(uint256 _tokenId) view returns (string){
      return badge.name(_tokenId)
  }

  function tokenByIndex(uint256 _index) external view returns (uint256){
      return badge.tokenByIndex(_index)
  }

  function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256){
      return badge.tokenOfOwnerByIndex(_owner, _index)
  }

}
