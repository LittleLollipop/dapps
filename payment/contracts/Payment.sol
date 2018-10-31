pragma solidity ^0.4.23;

contract Delegate {
	function callTransfer(address contract_address, address from, address to, uint256 value) public returns (bool);
	function multisend(address _tokenAddr, address from, address[] dests, uint256[] values) public returns(bool);
	function multisendSelf(address _tokenAddr, address[] dests, uint256[] values) public returns(bool);
}

contract Payment is ManagerContract{

	event PayFor(address indexed _payer, uint256 indexed _project, uint256 _value, uint256 indexed data);
	event NewProject(uint256 indexed _project, address _receivable, uint256 _value, address _tokenAddress);

	mapping (uint256 => address) receivables;
	mapping (uint256 => uint256) values;
	mapping (uint256 => address) tokenAddresss;

	uint256 projectNumber = 0;

	Delegate delegate;
	address delegateAddress;

	function upgroundDelegateAddress (address new_delegate) public restricted {
		delegateAddress = new_delegate;
		delegate = Delegate(delegateAddress);
	}
	

	function createProject (address _receivable, uint256 _value, address _tokenAddress) public  restricted {
		receivables[projectNumber] = _receivable;
		values[projectNumber] = _value;
		tokenAddresss[projectNumber] = _tokenAddress;
		projectNumber++;
		NewProject(projectNumber-1, _receivable, _value, _tokenAddress);
	}
	
	function pay (uint256 _project, uint256 _value, uint256 data) public {
		

		require (delegate.callTransfer(tokenAddresss[_project], msg.sender, receivables[_project], _value));
		
		PayFor(msg.sender, _project, _value, data);
	}
	
	function pay (uint256 _project, uint256 data) public {
		
		require (delegate.callTransfer(tokenAddresss[_project], msg.sender, receivables[_project], values[_project]));
		
		PayFor(msg.sender, _project, values[_project], data);
	}
	

}