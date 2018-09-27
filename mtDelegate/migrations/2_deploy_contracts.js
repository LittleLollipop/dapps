var MTDelegate = artifacts.require("./MTDelegate.sol");
module.exports = function(deployer) {
	
  // deployer.deploy(ManagerContract);
  // deployer.link(ManagerContract, MTDelegate);
  	deployer.deploy(MTDelegate);
};
