
module.exports = function(callback) {

	var Odam = artifacts.require("./Odam.sol");

	Odam.at("0x9514d37789ab2c9d700525b687086da07f274d1f").then(function(instance){
		instance.createGame("0x0656b144b1b94bc354d1f52afa912904790ec627", 10, 1000 * 1000000000000000).then(function(res){
			console.log(JSON.stringify(res));
			instance.upgroundNextGameInfo("0x0656b144b1b94bc354d1f52afa912904790ec627", 10, 1000 * 1000000000000000).then(function(res){
				console.log(JSON.stringify(res));
			})
		});
	})

}