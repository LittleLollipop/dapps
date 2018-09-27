module.exports = function(callback) {

	var MTDelegate = artifacts.require("./MTDelegate.sol");

	MTDelegate.at("0x68fade61a964b242e218c1485de6bd78e1d5c56c").then(function(instance){

		instance.updateContract("0x9514d37789ab2c9d700525b687086da07f274d1f", 10000 * 1000000000000000000);

	});

}