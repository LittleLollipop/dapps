
module.exports = function(callback) {

	var Odam = artifacts.require("./Odam.sol");

	Odam.at("0x7b01765bc471fd2320f4dbd9456cde6e953a238e").then(function(instance){
		instance.createGame("0xe5220d366eb04a4df050023ea6c8515f6347c384", 10, 1000 * 1000000000000000).then(function(res){
			console.log(JSON.stringify(res));

		});
	})

}