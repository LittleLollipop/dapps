pragma solidity ^0.5.0;

contract Logger {

    event LogUint(string key, uint value);
    function log(string memory key, uint value) internal {
    emit LogUint(key, value);
    }

    event LogInt(string key, int value);
    function log(string memory key, int value) internal {
    emit LogInt(key, value);
    }

    event LogBytes(string key, bytes value);
    function log(string memory key, bytes memory value) internal {
    emit LogBytes(key, value);
    }

    event LogBytes32(string key, bytes32 value);
    function log(string memory key, bytes32 value) internal {
    emit LogBytes32(key, value);
    }

    event LogAddress(string key, address value);
    function log(string memory key, address value) internal {
    emit LogAddress(key, value);
    }

    event LogBool(string key, bool value);
    function log(string memory key, bool value) internal {
    emit LogBool(key, value);
    }

    event LogString(string key, string value);
    function log(string memory key, string memory value) internal {
    emit LogString(key, value);
    }

}
