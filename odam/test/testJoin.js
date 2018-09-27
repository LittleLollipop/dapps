module.exports = function(callback) {

	var Odam = artifacts.require("./Odam.sol");

	Odam.at("0x52980ff52ea5b0ae469ae6279d6d942db9e140c6").then(function(instance){
		instance.testJoinGame(0).then(function(res){
			console.log(JSON.stringify(res));

		});
	})

}