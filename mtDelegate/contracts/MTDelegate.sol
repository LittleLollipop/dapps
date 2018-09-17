pragma solidity ^0.4.23;


import "./ManagerContract.sol";


contract ERC20 {
    function balanceOf(address who)view public returns (uint256);
    function allowance(address owner,address spender)view public returns (uint256);
    function transfer(address to,uint256 value)public returns (bool);
    function transferFrom(address from,address to,uint256 value)public returns (bool);
    function approve(address spender,uint256 value)public returns (bool);
}

contract Delegate {
	function callTransfer(address contract_address, address from, address to, uint256 value) public returns (bool);
	function multisend(address _tokenAddr, address[] dests, uint256[] values) public;
}

contract MTDelegate is ManagerContract, Delegate {
		
	mapping(address => uint256) contracts;		

	function updateContract(address contract_address, uint256 permission) public restricted {
		contracts[contract_address] = permission;
	}

	function permissionOf(address contract_address) constant returns (uint256 permission) {
    return contracts[contract_address];
  }

  function checkPermission (address contract_address, uint256 _value) returns(bool res) {
  	return contracts[contract_address] >= _value && _value >= 0;
  }
  	
  function callTransfer(address contract_address,address from,address to,uint256 value) public returns(bool){

    bool result = false;
    if(checkPermission(msg.sender, value)){
		  ERC20 token = ERC20(contract_address);
      result = token.transferFrom(from, to, value);
    }

    return result;
  }

  function multisend(address _tokenAddr, address[] dests, uint256[] values) public {

    uint256 maxValue = 0;

    for(uint v = values.length; v >= 0; v--){
      if(maxValue < values[v]){
        maxValue = values[v];
      }
    }

  	if(checkPermission(msg.sender, maxValue)){
  		ERC20 token = ERC20(_tokenAddr);
     		for (uint i = 0; i < dests.length; ++i){
        	require(token.transferFrom(msg.sender, dests[i], values[i]));
       	}
  		}
    }

}
