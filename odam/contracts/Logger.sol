pragma solidity ^0.4.23;

//通过log函数重载，对不同类型的变量trigger不同的event，实现solidity打印效果，使用方法为：log(string name, var value)

contract Logger {
    event LogUint(string key, uint value);
    function log(string key, uint value) internal {
    emit LogUint(key, value);
    }
    
    event LogInt(string key, int value);
    function log(string key, int value) internal {
    emit LogInt(key, value);
    }
    
    event LogBytes(string key, bytes value);
    function log(string key, bytes value) internal {
    emit LogBytes(key, value);
    }
    
    event LogBytes32(string key, bytes32 value);
    function log(string key, bytes32 value) internal {
    emit LogBytes32(key, value);
    }

    event LogAddress(string key, address value);
    function log(string key, address value) internal {
    emit LogAddress(key, value);
    }

    event LogBool(string key, bool value);
    function log(string key, bool value) internal {
    emit LogBool(key, value);
    }

    event LogString(string key, string value);
    function log(string key, string value) internal {
    emit LogString(key, value);
    }

}