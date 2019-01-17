pragma solidity ^0.5.0;

contract ManagerContract {
  address public owner;

  constructor() public {
    owner = msg.sender;
  }

  modifier restricted() {
    if (msg.sender == owner) _;
  }

  function upgrade(address new_address) public restricted {
    owner = new_address;
  }
}
