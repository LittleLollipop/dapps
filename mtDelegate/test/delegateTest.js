module.exports = function(callback) {

	var MTDelegate = artifacts.require("./MTDelegate.sol");
	var account1 = "0xc1AC4c791c0745debE5Fafe8766d7F540fa876C6"; 
	var account2 = "0xbbb74d6612266E5D2463Fcc2A1874e1A37BF4Ee2";
	var account3 = "0x1a1bA41eb37127AF584E9B9cC262fBFA2EC3889b";

	MTDelegate.at("0xb6D3Dd4Dea55deCe97B32A4eFd64AeED7187aD5F").then(function(instance){


		instance.updateContract(account1, 10000 * 1000000000000000000).then(function(res){
			console.log(res);
			var res = instance.callTransfer("0x9514d37789ab2C9D700525b687086dA07F274D1f",account2,account3,10 ** 18).then(function(){
				console.log(res);
			});
		});


	});

}