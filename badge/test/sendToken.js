module.exports = function(callback) {

	var GenesisBadge = artifacts.require("./GenesisBadge.sol");
	var account1 = "0xc1AC4c791c0745debE5Fafe8766d7F540fa876C6"; 

	GenesisBadge.at("0x0656b144b1b94bc354d1f52afa912904790ec627").then(function(instance){
		instance.safeTransferFrom(account1, "0x6a9F813fb3e6a8f7013dabD1695bAE1d49aE8481", 1).then(function(res){
			console.log(JSON.stringify(res));
		});
	});


}