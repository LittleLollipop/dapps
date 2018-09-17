pragma solidity ^0.4.23;

// import "./oraclizeAPI_0.5.sol";

// import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

import "./ManagerContract.sol";


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

	address[] palyers;

	uint[] prizeNumber;

	address last;

	Odam odam;

	uint finishedNumber;

	bytes32 finishedHash1;

	bytes32 finishedHash2;

	constructor (address _token, uint _palyerNumber, uint256 _ticket, Odam _odam) {
		
		token = _token;
		palyerNumber = _palyerNumber;
		ticket = _ticket;
		finished = false;
		odam = _odam;
	}

	function checkPrize () returns(bool res){
		if(palyers.length >= palyerNumber){
			finished = true;
			finishedNumber = block.number() + 10;
			finishedHash1 = block.blockhash(block.number() - 10);
		}
		return finished;
	}
	
	function openPrize (address _address) {
				
		if(finishedNumber < block.number()){
			
			finishedHash2 = block.blockhash(block.number() - 1);

			last = _address;

			random();
		}

		
	}

	function random (){

		bytes32 finishedHash = sha3(finishedHash1 + finishedHash2);
		
		string storage prize1 = uint(finishedHash[0] + finishedHash[1] + finishedHash[2]);
		string storage prize2 = uint(finishedHash[3] + finishedHash[4] + finishedHash[5]);
		string storage prize3 = uint(finishedHash[6] + finishedHash[7] + finishedHash[8]);
		string storage prize4 = uint(finishedHash[9] + finishedHash[10] + finishedHash[11]);
		string storage prize5 = uint(finishedHash[12] + finishedHash[13] + finishedHash[14]);

		uint randomNumber1 = uint(sha3(prize1)) % palyers.size;
		uint randomNumber2 = uint(sha3(prize2)) % palyers.size;
		uint randomNumber3 = uint(sha3(prize3)) % palyers.size;
		uint randomNumber4 = uint(sha3(prize4)) % palyers.size;
		uint randomNumber5 = uint(sha3(prize5)) % palyers.size;

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
    	address[] storage prizePalyers;
		prizePalyers.push(prizePalyers[prizeNumber[0]]);
		prizePalyers.push(prizePalyers[prizeNumber[1]]);
		prizePalyers.push(prizePalyers[prizeNumber[2]]);
		prizePalyers.push(prizePalyers[prizeNumber[3]]);
		prizePalyers.push(prizePalyers[prizeNumber[4]]);
		prizePalyers.push(last);
		prizePalyers.push(odam.owner);

		uint256[] storage prize;
		prize.push(ticket * palyerNumber / 2);
		prize.push(ticket * palyerNumber / 10);
		prize.push(ticket * palyerNumber / 10);
		prize.push(ticket * palyerNumber / 10);
		prize.push(ticket * palyerNumber / 10);
		prize.push(ticket * palyerNumber / 20);
		prize.push(ticket * palyerNumber / 20);

		odam.sendPrize(token, prizePalyers, prize);
    }
    
}


/**
 * One day and a millionaire
 */
contract Odam is ManagerContract{


	Game[] finishedGames = [];
	mapping(uint => Game) games;
	uint gamesNumber;
	Delegate delegate;
	address delegateAddress;

	address nextGameContract;
	uint nextGamePalyerNumber;
	uint256 nextGameTicket;
	
	function upgroundDelegateAddress (address new_delegate) public restricted returns(bool res)  {
		delegateAddress = new_delegate;
		delegate = Delegate(delegateAddress);
	}
	

	function createGameAndJoin (address _contract, uint palyerNumber, uint256 ticket) returns(bool res) {
		if(createGame(owner, _contract, palyerNumber, ticket)){
			joinGame(gamesNumber - 1);
		}
		return false;
	}
	
	function joinGame (uint gameId) returns(bool res) {
		if(gamesNumber >= gameId && !games[gameId].finished){
			delegate.callTransfer(games[gameId]._contract, msg.sender, delegateAddress, games[gameId].ticket);
			games[gameId].palyers.push(msg.sender);

			if(games[gameId].checkPrize()){
				finishedGames.push(games[gameId]);
				createGame(nextGameContract, nextGamePalyerNumber, nextGameTicket);
			}



			return true;
		}
		return false;
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
		
		if(isContract(_contract)){

			Game new_game = Game(_contract, palyerNumber, ticket);

			games[gamesNumber] = new_game;

			gamesNumber++;

			return true;
		}

		return false;
	}
	
	function sendPrize (address token,  address[] dests, uint256[] values, Game game){

		for(int i = games.size; i >= 0; i--){
			if(games[i] == game){
				delegate.multisend(address, dests, values);
				return;
			}
		}
	}
	

	function isContract(address addr) returns (bool) {
    	uint size;
    	assembly { size := extcodesize(addr) }
    	return size > 0;
  	}

}

