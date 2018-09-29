module.exports = function(callback) {

	var Odam = artifacts.require("./Odam.sol");


	Odam.at("0xf4c7fbb5e00df2dadd333bee22aafb690f7ff644").then(function(instance){
		
		instance.getGameNumber.call().then(function(res){
			console.log(res.toString());

			instance.isFinished.call(0).then(function(res){
				console.log("isFinished" + res.toString());
			});

			instance.getTicket.call(0).then(function(res){
				console.log("Ticket" + res.toString());
			});

			instance.getToken.call(0).then(function(res){
				console.log("Token" + res.toString());
			});

			instance.getPlayNumber.call(0).then(function(res){
				console.log("PlayNumber" + res.toString());
			});

			instance.getProgress.call(0).then(function(res){
				console.log("Progress" + res.toString());
			});

			instance.getPrizePalyers.call(0).then(function(res){
				console.log("PrizePalyers" + res.toString());
			});

			instance.getPrize.call(0).then(function(res){
				console.log("Prize" + res.toString());
			});

			instance.isOpened.call(0).then(function(res){
				console.log("Opened" + res.toString());
			});


		});

	});


}