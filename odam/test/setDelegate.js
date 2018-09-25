
module.exports = function(callback) {

	var odam = artifacts.require("./odam.sol");

	odam.at("0x879ce599e21980126186797343d82af23cb81a53").then(function(instance){
		instance.upgroundDelegateAddress("0xb6D3Dd4Dea55deCe97B32A4eFd64AeED7187aD5F");
	})

}
