
module.exports = function(callback) {

	var odam = artifacts.require("./odam.sol");

	odam.at("0xf4c7fbb5e00df2dadd333bee22aafb690f7ff644").then(function(instance){
		instance.upgroundDelegateAddress("0x68fade61a964b242e218c1485de6bd78e1d5c56c");
	})

}
