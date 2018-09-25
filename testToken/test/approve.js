
module.exports = function(callback) {

	var delegate = "0xb6D3Dd4Dea55deCe97B32A4eFd64AeED7187aD5F";
	var TestCoin = artifacts.require("./TestCoin.sol");
	var account1 = "0xc1AC4c791c0745debE5Fafe8766d7F540fa876C6"; 
	var account2 = "0xbbb74d6612266E5D2463Fcc2A1874e1A37BF4Ee2";
	var account3 = "0x1a1bA41eb37127AF584E9B9cC262fBFA2EC3889b";
	var account4 = "0xb30E31Cf0aaE9D39a6211a350fFd19D791A4015A";
	var account5 = "0x7b8d33FE892f4192F8B3A5980308ce9FbD82BeDF";
	var account6 = "0xa7D1b26D70C85630393EA2176cd53906cc977dE4";
	var account7 = "0x2D9cD751e320e71295C7791271Ac3DA9020A406E";
	var account8 = "0x8b83EC35d612cDCaDb00e5645f5a30d0b5666786";
	var account9 = "0xEE5bBe5348E6995d6eCAfC51f69e939C5446D657";
	var account10 = "0x615962aEc1c4C104Ee3d100de3c56B3E40491BDb"; 

	TestCoin.at("0x9514d37789ab2C9D700525b687086dA07F274D1f").then(function(instance){

    	instance.approve(delegate, 10000 ** 18, {from: account1}).then(function(tx_id){
		 instance.approve(delegate, 10000 ** 18, {from: account2}).then(function(tx_id){
	 	  instance.approve(delegate, 10000 ** 18, {from: account3}).then(function(tx_id){
	 	   instance.approve(delegate, 10000 ** 18, {from: account4}).then(function(tx_id){
	 	    instance.approve(delegate, 10000 ** 18, {from: account5}).then(function(tx_id){
 	    	 instance.approve(delegate, 10000 ** 18, {from: account6}).then(function(tx_id){
    	 	  instance.approve(delegate, 10000 ** 18, {from: account7}).then(function(tx_id){
    	 	   instance.approve(delegate, 10000 ** 18, {from: account8}).then(function(tx_id){
    	 	  	instance.approve(delegate, 10000 ** 18, {from: account9}).then(function(tx_id){
    	 	  	 instance.approve(delegate, 10000 ** 18, {from: account10});
    	 	    });
    	 	   });
    	 	  });
 	    	 });
	 	    });
	 	   });
	 	  });
		 });
    	});


	});

}