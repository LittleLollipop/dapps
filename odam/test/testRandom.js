
module.exports = function(callback) {

	var Odam = artifacts.require("./Odam.sol");

	Odam.at("0x9514d37789ab2c9d700525b687086da07f274d1f").then(function(instance){
		instance.testRandom().then(function(res){
			console.log(JSON.stringify(res));

		});
	})

}
