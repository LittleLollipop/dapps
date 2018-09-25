pragma solidity ^0.4.23;

// import "./oraclizeAPI_0.5.sol";

// import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

import "./ManagerContract.sol";

import "./Logger.sol";

contract Delegate {
	function callTransfer(address contract_address, address from, address to, uint256 value) public returns (bool);
	function multisend(address _tokenAddr, address[] dests, uint256[] values) public;
}

/**
 * The Game contract does this and that...
 */
contract Game{

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

	constructor (address _token, uint _palyerNumber, uint256 _ticket, Odam _odam, address _owner) {
		
		token = _token;
		palyerNumber = _palyerNumber;
		ticket = _ticket;
		finished = false;
		odam = _odam;
		owner = _owner;
		gameManager = msg.sender;
		opened = false;
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
	

	function openPrize (address _address) {

		if(opened)
			return;
				
		if(finishedNumber < block.number){
			
			finishedHash2 = block.blockhash(block.number - 1);

			last = _address;

			random();
		}

		
	}

	function random (){

		bytes memory finishedHashInfo = new bytes(64);
		for(uint i = 0; i < 32; i++){
			finishedHashInfo[i] = finishedHash1[i];
			finishedHashInfo[i + 32] = finishedHash2[i];
		}
		bytes32 finishedHash = keccak256(finishedHashInfo);
		
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

		prizeNumber.push(randomNumber1);
		prizeNumber.push(randomNumber2);
		prizeNumber.push(randomNumber3);
		prizeNumber.push(randomNumber4);
		prizeNumber.push(randomNumber5);

		sendPrize();
	}

	// function random (){
		// uint N = 10; // number of random bytes we want the datasource to return
  //       uint delay = 0; // number of seconds to wait before the execution takes place
  //       uint callbackGas = 200000; // amount of gas we want Oraclize to set for the callback function
  //       bytes32 queryId = oraclize_newRandomDSQuery(delay, N, callbackGas);
	// }
	
	
	// function __callback(bytes32 _queryId, string _result, bytes _proof){ 
 //    	if (msg.sender != oraclize_cbAddress()) revert();
        
 //        if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
 //            // the proof verification has failed, do we need to take any action here? (depends on the use case)
 //        } else {
                       
 //            string storage prize1 = bytes(_result)[0] + bytes(_result)[1];
 //            string storage prize2 = bytes(_result)[2] + bytes(_result)[3];
 //            string storage prize3 = bytes(_result)[4] + bytes(_result)[5];
 //            string storage prize4 = bytes(_result)[6] + bytes(_result)[7];
 //            string storage prize5 = bytes(_result)[8] + bytes(_result)[9];

 //            uint randomNumber1 = uint(sha3(prize1)) % palyers.size;//It should never be greater than 2^(8*N), where N is the number of random bytes we had asked the datasource to return
 // 			prizeNumber.push(randomNumber1);

	// 		uint randomNumber2 = uint(sha3(prize2)) % palyers.size;//It should never be greater than 2^(8*N), where N is the number of random bytes we had asked the datasource to return
 // 			prizeNumber.push(randomNumber2);

 // 			uint randomNumber3 = uint(sha3(prize3)) % palyers.size;//It should never be greater than 2^(8*N), where N is the number of random bytes we had asked the datasource to return
 // 			prizeNumber.push(randomNumber3);

 // 			uint randomNumber4 = uint(sha3(prize4)) % palyers.size;//It should never be greater than 2^(8*N), where N is the number of random bytes we had asked the datasource to return
 // 			prizeNumber.push(randomNumber4);

 // 			uint randomNumber5 = uint(sha3(prize5)) % palyers.size;//It should never be greater than 2^(8*N), where N is the number of random bytes we had asked the datasource to return
 // 			prizeNumber.push(randomNumber5);

 // 			sendPrize();
 //        }
 //    }

    function sendPrize () {
    	address[] memory prizePalyers = new address[](7);

    	prizePalyers[0] = prizePalyers[prizeNumber[0]];
    	prizePalyers[1] = prizePalyers[prizeNumber[1]];
    	prizePalyers[2] = prizePalyers[prizeNumber[2]];
    	prizePalyers[3] = prizePalyers[prizeNumber[3]];
    	prizePalyers[4] = prizePalyers[prizeNumber[4]];
		prizePalyers[5] = last;
		prizePalyers[6] = owner;

		uint256[] memory prize = new uint256[](7);
		prize[0] = ticket * palyerNumber / 2;
		prize[1] = ticket * palyerNumber / 10;
		prize[2] = ticket * palyerNumber / 10;
		prize[3] = ticket * palyerNumber / 10;
		prize[4] = ticket * palyerNumber / 10;
		prize[5] = ticket * palyerNumber / 20;
		prize[6] = ticket * palyerNumber / 20;

		odam.sendPrize(token, prizePalyers, prize, this);

		opened = true;
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

			for(uint i = opendNumber; i <= finishedGames.length; i++){
				if(!finishedGames[i].isOpened()){
					finishedGames[i].openPrize(msg.sender);
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

	function createGame (address _contract, uint palyerNumber, uint256 ticket) public restricted returns(bool res) {
		
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
	
	function sendPrize (address token,  address[] dests, uint256[] values, Game game){

		for(uint i = finishedGames.length; i >= 0; i--){
			if(finishedGames[i] == game){
				opendNumber = i;
				delegate.multisend(token, dests, values);
				return;
			}
		}
	}
	

	function isContract(address addr) returns (bool) {
    	uint size;
    	assembly { size := extcodesize(addr) }
    	log("Contract Size", size);
    	return size > 0;
  	}

}

