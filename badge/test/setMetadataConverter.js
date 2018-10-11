module.exports = function(callback) {

	var GenesisBadge = artifacts.require("./GenesisBadge.sol");
	var account1 = "0xc1AC4c791c0745debE5Fafe8766d7F540fa876C6"; 

	GenesisBadge.at("0x0656b144b1b94bc354d1f52afa912904790ec627").then(function(instance){
		instance.updateURIConverter("0x5d10b61fb0db080126157eedb1fcdd879ee3de36", {from: account1}).then(function(res){
			console.log(JSON.stringify(res));
		});
	});


}