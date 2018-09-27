
module.exports = function(callback) {

	var odam = artifacts.require("./odam.sol");

	odam.at("0x9514d37789ab2c9d700525b687086da07f274d1f").then(function(instance){
		instance.upgroundDelegateAddress("0x68fade61a964b242e218c1485de6bd78e1d5c56c");
	})

}
