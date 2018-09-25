var testCoin = artifacts.require("./TestCoin.sol");

module.exports = function(deployer) {
  deployer.deploy(testCoin);
};