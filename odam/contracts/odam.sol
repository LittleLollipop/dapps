pragma solidity ^0.4.23;

// import "./oraclizeAPI_0.5.sol";

// import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

import "./ManagerContract.sol";

import "./Logger.sol";

contract Delegate {
	function callTransfer(address contract_address, address from, address to, uint256 value) public returns (bool);
	function multisend(address _tokenAddr, address from, address[] dests, uint256[] values) public returns(bool);
	function multisendSelf(address _tokenAddr, address[] dests, uint256[] values) public returns(bool);
}

/**
 * The Game contract does this and that...
 */
contract Game is Logger{

	Odam internal odam;

	address internal nextGameContract;
	
	uint internal nextGamePalyerNumber;
	
	uint256 internal nextGameTicket;

	Game[] internal finishedGames;
	
	uint256 internal opendNumber;
	
	uint internal gamesNumber;

	address internal owner;

	mapping ( uint256 => address ) internal token;

	mapping ( uint256 => uint ) internal palyerNumber;

	mapping ( uint256 => uint256 ) internal ticket; 

	mapping ( uint256 => bool ) internal finished;

	mapping ( uint256 => bool ) internal opened;

	mapping ( uint256 => address[] ) internal palyers;

	mapping ( uint256 => uint[] ) internal prizeNumber;

	mapping ( uint256 => address ) internal last;

	mapping ( uint256 => uint ) internal finishedNumber;

	mapping ( uint256 => bytes32 ) internal finishedHash1;

	mapping ( uint256 => bytes32 ) internal finishedHash2;

	mapping ( uint256 => address ) internal gameManager;

	mapping ( uint256 => address[] ) internal prizePalyers;

	mapping ( uint256 => uint256[] ) internal prize;

	constructor (Odam _odam, address _owner) {
		odam = _odam;
		owner = _owner;
		opendNumber = 0;
	}

	createGame(address _token, uint _palyerNumber, uint256 _ticket, Odam _odam){



		token = _token;
		palyerNumber = _palyerNumber;
		ticket = _ticket;
		finished = false;
		gameManager = msg.sender;
		opened = false;
		log("owner", owner);
	}

	modifier restricted() {
    	if (msg.sender == gameManager) _;
  	}

	function isFinished(uint256 gameid) returns(bool res){
		return finished[gameid];
	}
	
	function getTicket(uint256 gameId) returns(uint256 res) {
		return ticket[ganmeId];
	}

	function getToken(uint256 gameId) returns(address res) {
		return token[gameId];
	}
	
	function getPlayNumber (uint256 gameId) returns(uint res) {
		return palyerNumber[gameId];
	}

	function getProgress (uint256 gameId) returns(uint res) {
		return palyers[gameId].length;
	}
	
	function getPrizePalyers (uint256 gameId) returns(address[] res) {
		return prizePalyers[gameId];
	}
	
	function getPrize (uint256 gameId) returns(uint256[] res) {
		return prize[gameId];
	}
	
	function isOpened (uint256 gameId) returns(bool res) {
		return opened[gameId];
	}

	function addPalyer(uint256 gameId, address palyer) restricted{
		
		palyers[gameId].push(palyer);	
	}

	function checkPrize (uint256 gameId) restricted returns(bool res){

		if(palyers[gameId].length >= palyerNumber[gameId]){
			finished[gameId] = true;
			finishedNumber[gameId] = block.number + 10;
			finishedHash1[gameId] = block.blockhash(block.number - 10);
		}
		return finished[gameId];
	}
	

	function openPrize (uint256 gameId, address _address) returns(bool res){

		if(opened[gameId])
			return;
				
		log("checkBlock", block.number);
		log("finishedNumber", finishedNumber);
		if(finishedNumber[gameId] < block.number){
			
			finishedHash2[gameId] = block.blockhash(block.number - 1);

			last[gameId] = _address;

			return random(gameId);
		}

		return false;
	}

	function random (uint256 gameId) returns(bool res){

		bytes memory finishedHashInfo = new bytes(64);
		for(uint i = 0; i < 32; i++){
			finishedHashInfo[i] = finishedHash1[gameId][i];
			finishedHashInfo[i + 32] = finishedHash2[gameId][i];
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

		prizeNumber[gameId].push(randomNumber1);
		prizeNumber[gameId].push(randomNumber2);
		prizeNumber[gameId].push(randomNumber3);
		prizeNumber[gameId].push(randomNumber4);
		prizeNumber[gameId].push(randomNumber5);

		return sendPrize();
	}

    function sendPrize (uint256 gameId) returns(bool res) {
    	log("last", last);
		log("owner", owner);

		prizePalyers[gameId].push(palyers[gameId][prizeNumber[0]]);
		prizePalyers[gameId].push(palyers[gameId][prizeNumber[1]]);
		prizePalyers[gameId].push(palyers[gameId][prizeNumber[2]]);
		prizePalyers[gameId].push(palyers[gameId][prizeNumber[3]]);
		prizePalyers[gameId].push(palyers[gameId][prizeNumber[4]]);
    	
		// prizePalyers[5] = last;
		// prizePalyers[6] = owner;

		prize[gameId].push(ticket[gameId] * palyerNumber[gameId] / 2);
		prize[gameId].push(ticket[gameId] * palyerNumber[gameId] / 10);
		prize[gameId].push(ticket[gameId] * palyerNumber[gameId] / 10);
		prize[gameId].push(ticket[gameId] * palyerNumber[gameId] / 10);
		prize[gameId].push(ticket[gameId] * palyerNumber[gameId] / 10);

		// prize[5] = ticket * palyerNumber / 20;
		// prize[6] = ticket * palyerNumber / 20;

		opened[gameId] = true;

		return true;
    }
    
    function canJoin (uint256 gameid) returns(bool res) {
    	return gamesNumber >= gameId && !isFinished(gameid);
    }
    
    
}


/**
 * One day and a millionaire
 */
contract Odam is ManagerContract, Logger{

	event JoinGame(address indexed _from, uint indexed _gameId);


	mapping(uint256 => Game) games;
	Delegate delegate;
	address delegateAddress;


	constructor() public {
    	
  	}

	function upgroundDelegateAddress (address new_delegate) public restricted returns(bool res)  {
		delegateAddress = new_delegate;
		delegate = Delegate(delegateAddress);
	}
	

	// function createGameAndJoin (address _contract, uint256 palyerNumber, uint256 ticket) returns(bool res) {
	// 	if(createGame(_contract, palyerNumber, ticket)){
	// 		joinGame(gamesNumber - 1);
	// 	}
	// 	return false;
	// }
	
	function joinGameNow (uint256 roomNumber){

		uint gameid = games[roomNumber].gamesNumber - 1;
		require(joinGame(roomNumber, gameid) == 1);
		emit JoinGame(msg.sender, gameid);
	}
	
	function getGameNumber () public returns(uint256 res) {
		return gamesNumber;
	}

	function isFinished(uint gameId) returns(bool res){
		return games[gameId].isFinished();
	}
	
	function getTicket(uint gameId) returns(uint256 res) {
		return games[gameId].getTicket();
	}

	function getToken(uint gameId) returns(address res) {
		return games[gameId].getToken();
	}
	
	function getPlayNumber (uint gameId) returns(uint res) {
		return games[gameId].getPlayNumber();
	}

	function getProgress (uint gameId) returns(uint res) {
		return games[gameId].getProgress();
	}
	
	function getPrizePalyers (uint gameId) returns(address[] res) {
		return games[gameId].getPrizePalyers();
	}
	
	function getPrize (uint gameId) returns(uint256[] res) {
		return games[gameId].getPrize();
	}
	
	function isOpened (uint gameId) returns(bool res) {
		return games[gameId].isOpened();
	}

	function joinGame (uint256 roomNumber, uint256 gameId) returns(uint8 res) {
		
		uint joinState;

		if(games[roomNumber].canJoin(gameId)){}
			if(!delegate.callTransfer(games[roomNumber].getToken(gameId), msg.sender, delegateAddress, games[roomNumber].getTicket(gameId))){
				joinState = 3;
				log("joinState", joinState);
				return 3;
			}
			games[roomNumber].addPalyer(gameId, msg.sender);

			if(games[roomNumber].checkPrize(gameId)){
				finishedGames.push(games[gameId]);
				createGame(nextGameContract, nextGamePalyerNumber, nextGameTicket);
			}

		// 	bool openOnce = false;
		// 	for(uint i = opendNumber; i < finishedGames.length && !openOnce; i++){
		// 		log("checkPrize", i);
		// 		if(!finishedGames[i].isOpened()){
		// 			log("openGanme", i);
		// 			if(finishedGames[i].openPrize(msg.sender)){

		// 				if(sendPrize (finishedGames[i].getToken(), finishedGames[i].getPrizePalyers(), finishedGames[i].getPrize())){
		// 					opendNumber = i;
		// 					openOnce = true;
		// 				}
						
		// 			}
		// 		}
		// 	}
			
		// 	joinState = 1;
		// 	log("joinState", joinState);
		// 	return 1;
		// }
		
		// joinState = 2;
		// log("joinState", joinState);
		// return 2;
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

