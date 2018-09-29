module.exports = function(callback) {

	var MTDelegate = artifacts.require("./MTDelegate.sol");

	MTDelegate.at("0x68fade61a964b242e218c1485de6bd78e1d5c56c").then(function(instance){

		instance.updateContract("0xf4c7fbb5e00df2dadd333bee22aafb690f7ff644", 1000000 * 1000000000000000000);

	});

}