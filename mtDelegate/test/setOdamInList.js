module.exports = function(callback) {

	var MTDelegate = artifacts.require("./MTDelegate.sol");

	MTDelegate.at("0xb6D3Dd4Dea55deCe97B32A4eFd64AeED7187aD5F").then(function(instance){

		instance.updateContract("0x26dbab25195c1a7f6a3240db8e5b2fb91294d4f8", 10000 * 1000000000000000000);

	});

}