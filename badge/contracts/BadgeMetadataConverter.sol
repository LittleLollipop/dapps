pragma solidity ^0.4.23;

interface MetadataConverter {
  function tokenURI(uint256 _tokenId) view returns (string);  
  function name(uint256 _tokenId) view returns (string);
    function tokenSLogoURI() view returns (string);
    function tokenBLogoURI() view returns (string);
    function tokenSLogoBGURI() view returns (string);
    function tokenBLogoBGURI() view returns (string);
    function tokenBGURI() view returns (string);
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

/**
 * The Badge contract does this and that...
 */
contract BadgeMetadataConverter {

    using Strings for string;
    
    function tokenURI(uint256 _tokenId) view returns (string){
    
      return Strings.strConcat(
            "https://cdn.mytoken.org/badge_gb_",
            Strings.uint2str(_tokenId),".png"
        );
    }
    
    function name(uint256 _tokenId) view returns (string){
      return "";
    }
    
    function tokenSLogoURI() view returns (string){
        return "https://cdn.mytoken.org/badge_gb_logo_s.png";
    }
    
    function tokenBLogoURI() view returns (string){
        return "https://cdn.mytoken.org/badge_gb_logo_b.png";
    }
    
    function tokenSLogoBGURI() view returns (string){
        return "https://cdn.mytoken.org/badge_gb_logo_s_bg.png";
    }
    
    function tokenBLogoBGURI() view returns (string){
        return "https://cdn.mytoken.org/badge_gb_logo_b_bg.png";
    }
    
    function tokenBGURI() view returns (string){
        return "https://cdn.mytoken.org/badge_gb_bg.png";
    }


}


