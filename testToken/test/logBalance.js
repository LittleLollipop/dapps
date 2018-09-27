module.exports = function(callback) {

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

	TestCoin.at("0x0656b144b1b94bc354d1f52afa912904790ec627").then(function(instance){

    	instance.balanceOf.call(account1).then(function(balance){
		 console.log(balance.toString());
		 instance.balanceOf.call(account2).then(function(balance){
	 	  console.log(balance.toString());
	 	  instance.balanceOf.call(account3).then(function(balance){
 	  	   console.log(balance.toString());
	 	   instance.balanceOf.call(account4).then(function(balance){
	 	    console.log(balance.toString());
	 	    instance.balanceOf.call(account5).then(function(balance){
	 	     console.log(balance.toString());
 	    	 instance.balanceOf.call(account6).then(function(balance){
 	    	  console.log(balance.toString());
    	 	  instance.balanceOf.call(account7).then(function(balance){
    	 	   console.log(balance.toString());
    	 	   instance.balanceOf.call(account8).then(function(balance){
    	 	    console.log(balance.toString());
    	 	  	instance.balanceOf.call(account9).then(function(balance){
    	 	  	 console.log(balance.toString());
    	 	  	 instance.balanceOf.call(account10).then(function(falance){
    	 	  	 	console.log(balance.toString());
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


	});

}