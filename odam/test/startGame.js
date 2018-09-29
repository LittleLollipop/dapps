
module.exports = function(callback) {

	var Odam = artifacts.require("./Odam.sol");

	Odam.at("0xf4c7fbb5e00df2dadd333bee22aafb690f7ff644").then(function(instance){
		instance.createGame("0x0656b144b1b94bc354d1f52afa912904790ec627", 10, 10000 * 1000000000000000).then(function(res){
			console.log(JSON.stringify(res));
			instance.upgroundNextGameInfo("0x0656b144b1b94bc354d1f52afa912904790ec627", 10, 10000 * 1000000000000000).then(function(res){
				console.log(JSON.stringify(res));
			})
		});
	})

}