pragma solidity ^0.4.23;

// import "./oraclizeAPI_0.5.sol";

// import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

import "./ManagerContract.sol";

import "./Logger.sol";

contract Delegate {
	function callTransfer(address contract_address, address from, address to, uint256 value) public returns (bool);
	function multisend(address _tokenAddr, address from, address[] dests, uint256[] values) public;
	function multisendSelf(address _tokenAddr, address[] dests, uint256[] values) public;
}

/**
 * The Game contract does this and that...
 */
contract Game is Logger{

	address token;

	uint palyerNumber;

	uint256 ticket; 

	bool finished;

	bool opened;

	address[] palyers;

	uint[] prizeNumber;

	address last;

	Odam odam;

	uint finishedNumber;

	bytes32 finishedHash1;

	bytes32 finishedHash2;

	address owner;

	address gameManager;

	address[] prizePalyers;

	uint256[] prize;

	constructor (address _token, uint _palyerNumber, uint256 _ticket, Odam _odam, address _owner) {
		
		token = _token;
		palyerNumber = _palyerNumber;
		ticket = _ticket;
		finished = false;
		odam = _odam;
		owner = _owner;
		gameManager = msg.sender;
		opened = false;
		log("owner", owner);
	}

	modifier restricted() {
    	if (msg.sender == gameManager) _;
  	}

	function isFinished() returns(bool res){
		return finished;
	}
	
	function getTicket() returns(uint256 res) {
		return ticket;
	}

	function getToken() returns(address res) {
		return token;
	}
	
	function addPalyer(address palyer) restricted{
		
		palyers.push(palyer);	
	}
	

	function checkPrize () restricted returns(bool res){

		if(palyers.length >= palyerNumber){
			finished = true;
			finishedNumber = block.number + 10;
			finishedHash1 = block.blockhash(block.number - 10);
		}
		return finished;
	}
	
	function isOpened () returns(bool res) {
		return opened;
	}
	

	function openPrize (address _address) returns(bool res){

		if(opened)
			return;
				
		log("checkBlock", block.number);
		log("finishedNumber", finishedNumber);
		if(finishedNumber < block.number){
			
			finishedHash2 = block.blockhash(block.number - 1);

			last = _address;

			return random();
		}

		return false;
	}

	function random () returns(bool res){

		bytes memory finishedHashInfo = new bytes(64);
		for(uint i = 0; i < 32; i++){
			finishedHashInfo[i] = finishedHash1[i];
			finishedHashInfo[i + 32] = finishedHash2[i];
		}
		bytes32 finishedHash = keccak256(finishedHashInfo);
		
		log("finishedHash", finishedHash);

		bytes memory prize1 = new bytes(3);
		prize1[0] = finishedHash[0];
		prize1[1] = finishedHash[1];
		prize1[2] = finishedHash[2];

		bytes memory prize2 = new bytes(3);
		prize2[0] = finishedHash[3];
		prize2[1] = finishedHash[4];
		prize2[2] = finishedHash[5];

		bytes memory prize3 = new bytes(3);
		prize3[0] = finishedHash[6];
		prize3[1] = finishedHash[7];
		prize3[2] = finishedHash[8];

		bytes memory prize4 = new bytes(3);
		prize4[0] = finishedHash[9];
		prize4[1] = finishedHash[10];
		prize4[2] = finishedHash[11];

		bytes memory prize5 = new bytes(3);
		prize5[0] = finishedHash[12];
		prize5[1] = finishedHash[13];
		prize5[2] = finishedHash[14];


		uint randomNumber1 = uint(keccak256(prize1)) % palyers.length;
		uint randomNumber2 = uint(keccak256(prize2)) % palyers.length;
		uint randomNumber3 = uint(keccak256(prize3)) % palyers.length;
		uint randomNumber4 = uint(keccak256(prize4)) % palyers.length;
		uint randomNumber5 = uint(keccak256(prize5)) % palyers.length;

		log("randomNumber1", randomNumber1);
		log("randomNumber2", randomNumber2);
		log("randomNumber3", randomNumber3);
		log("randomNumber4", randomNumber4);
		log("randomNumber5", randomNumber5);

		prizeNumber.push(randomNumber1);
		prizeNumber.push(randomNumber2);
		prizeNumber.push(randomNumber3);
		prizeNumber.push(randomNumber4);
		prizeNumber.push(randomNumber5);

		return sendPrize();
	}

    function sendPrize () returns(bool res) {
    	log("last", last);
		log("owner", owner);

		prizePalyers.push(palyers[prizeNumber[0]]);
		prizePalyers.push(palyers[prizeNumber[1]]);
		prizePalyers.push(palyers[prizeNumber[2]]);
		prizePalyers.push(palyers[prizeNumber[3]]);
		prizePalyers.push(palyers[prizeNumber[4]]);
    	
		// prizePalyers[5] = last;
		// prizePalyers[6] = owner;

		prize.push(ticket * palyerNumber / 2);
		prize.push(ticket * palyerNumber / 10);
		prize.push(ticket * palyerNumber / 10);
		prize.push(ticket * palyerNumber / 10);
		prize.push(ticket * palyerNumber / 10);

		// prize[5] = ticket * palyerNumber / 20;
		// prize[6] = ticket * palyerNumber / 20;

		opened = true;

		return true;
    }
    
    function getPrizeAddress () returns(address[] res){
    	return prizePalyers;
    }

    function getPrize () returns(uint256[] res) {
    	return prize;
    }
    
    
}


/**
 * One day and a millionaire
 */
contract Odam is ManagerContract, Logger{


	Game[] finishedGames;
	uint256 opendNumber;
	mapping(uint => Game) games;
	uint gamesNumber;
	Delegate delegate;
	address delegateAddress;

	address nextGameContract;
	uint nextGamePalyerNumber;
	uint256 nextGameTicket;
	
	constructor() public {
    	opendNumber = 0;
  	}

	function upgroundDelegateAddress (address new_delegate) public restricted returns(bool res)  {
		delegateAddress = new_delegate;
		delegate = Delegate(delegateAddress);
	}
	

	function createGameAndJoin (address _contract, uint256 palyerNumber, uint256 ticket) returns(bool res) {
		if(createGame(_contract, palyerNumber, ticket)){
			joinGame(gamesNumber - 1);
		}
		return false;
	}
	
	function joinGameNow () returns(uint8 res) {
		return joinGame(gamesNumber - 1);
	}
	

	function joinGame (uint256 gameId) returns(uint8 res) {
		
		uint joinState;
		if(gamesNumber >= gameId && !games[gameId].isFinished()){
			if(!delegate.callTransfer(games[gameId].getToken(), msg.sender, delegateAddress, games[gameId].getTicket())){
				
				joinState = 3;
				log("joinState", joinState);
				return 3;
			}
			games[gameId].addPalyer(msg.sender);

			if(games[gameId].checkPrize()){
				finishedGames.push(games[gameId]);
				createGame(nextGameContract, nextGamePalyerNumber, nextGameTicket);
			}

			for(uint i = opendNumber; i < finishedGames.length; i++){
				log("checkPrize", i);
				if(!finishedGames[i].isOpened()){
					log("openGanme", i);
					if(finishedGames[i].openPrize(msg.sender)){

						sendPrize (finishedGames[i].getToken(), finishedGames[i].getPrizeAddress(), finishedGames[i].getPrize());
						opendNumber = i;
					}
				}
			}
			
			joinState = 1;
			log("joinState", joinState);
			return 1;
		}
		
		joinState = 2;
		log("joinState", joinState);
		return 2;
	}
	
	function upgroundNextGameInfo (address _contract, uint palyerNumber, uint256 ticket) public restricted returns(bool res) {
		
		if(isContract(_contract)){

			nextGameContract = _contract;

			nextGamePalyerNumber = palyerNumber;

			nextGameTicket = ticket;

			return true;
		}

		return false;
	}

	function createGame (address _contract, uint palyerNumber, uint256 ticket) public returns(bool res) {
		
		uint state;

		if(isContract(_contract)){

			Game new_game = new Game(_contract, palyerNumber, ticket, this, owner);

			games[gamesNumber] = new_game;

			gamesNumber++;

			state = 1;
			log("createGame", state);

			return true;
		}

		state = 2;
		log("createGame", state);

		return false;
	}
	
	function sendPrize (address token,  address[] dests, uint256[] values){

		// log("do sendPrize token", token);
		// log("finishedGames.length", finishedGames.length);
		// for(uint i = finishedGames.length + 1; i > 0; i--){
		// 	log("findGame",i - 1);
		// 	if(finishedGames[i - 1] == game){
		// 		opendNumber = i - 1;
		// 		log("do multisend",i - 1);
				delegate.multisendSelf(token, dests, values);
		// 		return;
		// 	}
		// }
	}
	

	function isContract(address addr) returns (bool) {
    	uint size;
    	assembly { size := extcodesize(addr) }
    	log("Contract Size", size);
    	return size > 0;
  	}

	// function testJoinGame (uint256 gameId) returns(uint8 res) {
		
		// uint joinState;
		// if(gamesNumber >= gameId && !games[gameId].isFinished()){
		// 	if(!delegate.callTransfer(games[gameId].getToken(), msg.sender, delegateAddress, games[gameId].getTicket())){
				
		// 		joinState = 3;
		// 		log("joinState", joinState);
		// 		return 3;
		// 	}
			// games[gameId].addPalyer(msg.sender);

			// if(games[gameId].checkPrize()){
			// 	finishedGames.push(games[gameId]);
			// 	createGame(nextGameContract, nextGamePalyerNumber, nextGameTicket);
			// }

			// for(uint i = opendNumber; i < finishedGames.length; i++){
			// 	if(!finishedGames[i].isOpened()){
			// 		finishedGames[i].openPrize(msg.sender);
			// 	}
			// }
			
		// 	joinState = 1;
		// 	log("joinState", joinState);
		// 	return 1;
		// }
		
		// joinState = 2;
		// log("joinState", joinState);
		// return 2;
	// }

	// function testRandom (){

	// 	var finishedHash1 = block.blockhash(block.number - 1);

	// 	// log("hash1", finishedHash1);

	// 	var finishedHash2 = block.blockhash(block.number - 2);

	// 	// log("hash2", finishedHash2);

	// 	bytes memory finishedHashInfo = new bytes(64);
	// 	for(uint i = 0; i < 32; i++){
	// 		finishedHashInfo[i] = finishedHash1[i];
	// 		finishedHashInfo[i + 32] = finishedHash2[i];
	// 	}
	// 	bytes32 finishedHash = keccak256(finishedHashInfo);
		
	// 	log("hash", finishedHash);

	// 	bytes memory prize1 = new bytes(3);
	// 	prize1[0] = finishedHash[0];
	// 	prize1[1] = finishedHash[1];
	// 	prize1[2] = finishedHash[2];

	// 	log("prize1", prize1);

	// 	bytes memory prize2 = new bytes(3);
	// 	prize2[0] = finishedHash[3];
	// 	prize2[1] = finishedHash[4];
	// 	prize2[2] = finishedHash[5];

	// 	log("prize2", prize2);

	// 	bytes memory prize3 = new bytes(3);
	// 	prize3[0] = finishedHash[6];
	// 	prize3[1] = finishedHash[7];
	// 	prize3[2] = finishedHash[8];

	// 	log("prize3", prize3);

	// 	bytes memory prize4 = new bytes(3);
	// 	prize4[0] = finishedHash[9];
	// 	prize4[1] = finishedHash[10];
	// 	prize4[2] = finishedHash[11];

	// 	log("prize4", prize4);

	// 	bytes memory prize5 = new bytes(3);
	// 	prize5[0] = finishedHash[12];
	// 	prize5[1] = finishedHash[13];
	// 	prize5[2] = finishedHash[14];
		
	// 	log("prize5", prize5);


	// 	uint randomNumber1 = uint(keccak256(prize1)) % 100;
	// 	uint randomNumber2 = uint(keccak256(prize2)) % 100;
	// 	uint randomNumber3 = uint(keccak256(prize3)) % 100;
	// 	uint randomNumber4 = uint(keccak256(prize4)) % 100;
	// 	uint randomNumber5 = uint(keccak256(prize5)) % 100;

	// 	log("randomNumber1", randomNumber1);
	// 	log("randomNumber2", randomNumber2);
	// 	log("randomNumber3", randomNumber3);
	// 	log("randomNumber4", randomNumber4);
	// 	log("randomNumber5", randomNumber5);
		
	// }
}

