pragma solidity ^0.4.23;


import "./ManagerContract.sol";
import "./Logger.sol";

contract ERC20 {
    function balanceOf(address who)view public returns (uint256);
    function allowance(address owner,address spender)view public returns (uint256);
    function transfer(address to,uint256 value)public returns (bool);
    function transferFrom(address from,address to,uint256 value)public returns (bool);
    function approve(address spender,uint256 value)public returns (bool);
}

contract Delegate {
  function callTransfer(address contract_address, address from, address to, uint256 value) public returns (bool);
  function multisend(address _tokenAddr, address from, address[] dests, uint256[] values) public returns(bool);
  function multisendSelf(address _tokenAddr, address[] dests, uint256[] values) public returns(bool);
}

contract MTDelegate is ManagerContract, Delegate, Logger {
    
  mapping(address => mapping(address => uint256)) internal contracts;    

  function updateContract(address contract_address, address token_address, uint256 _permission) public restricted {
    contracts[contract_address][token_address] = _permission;
  }

  function permissionOf(address contract_address, address token_address) constant returns (uint256 permission) {
    return contracts[contract_address][token_address];
  }

  function checkPermission (address contract_address, address token_address, uint256 _value) returns(bool res) {
    return contracts[contract_address][token_address] >= _value && _value >= 0;
  }
    
  function callTransfer(address contract_address,address from,address to,uint256 value) public returns(bool){

    bool result = false;
    uint state;
    if(checkPermission(msg.sender, contract_address, value)){
      state = 2;
      log("callTransfer state", state);

      ERC20 token = ERC20(contract_address);
      result = token.transferFrom(from, to, value);

      log("transferFrom state", result);
    }else{
      state = 1;
      log("callTransfer state", state);
    }

    return result;
  }

  function multisendSelf(address _tokenAddr, address[] dests, uint256[] values) public returns(bool){

    uint256 maxValue = 0;
    uint state; 

    log("multisend token", _tokenAddr);
    log("multisend dests", dests.length);
    log("multisend values", values.length);
    for(uint v = 0; v < values.length; v++){
      if(maxValue < values[v]){
        maxValue = values[v];
      }
    }

    if(checkPermission(msg.sender, _tokenAddr, maxValue)){
      state = 2;
      log("multisend state", state);

      ERC20 token = ERC20(_tokenAddr);

      for (uint i = 0; i < dests.length; i++){
        require(token.transfer(dests[i], values[i]));
      }
      
      return true;
    }else{

      state = 1;
      log("multisend state", state);
      return false;
    }
  }

  function multisend(address _tokenAddr, address from, address[] dests, uint256[] values) public returns(bool){

    uint256 maxValue = 0;
    uint state; 

    log("multisend token", _tokenAddr);
    log("multisend from", from);
    log("multisend dests", dests.length);
    log("multisend values", values.length);
    for(uint v = 0; v < values.length; v++){
      if(maxValue < values[v]){
        maxValue = values[v];
      }
    }

    if(checkPermission(msg.sender, _tokenAddr, maxValue)){
      state = 2;
      log("multisend state", state);

      ERC20 token = ERC20(_tokenAddr);

      for (uint i = 0; i < dests.length; i++){
        require(token.transferFrom(from, dests[i], values[i]));
      }
      
      return true;
    }else{

      state = 1;
      log("multisend state", state);
      return false;
    }
  }

  function () payable{
    require(false);
  }
  
}