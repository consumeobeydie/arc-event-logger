// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract EventLogger {
    address public owner;
    uint256 public logCount;

    struct Log {
        address sender;
        string message;
        uint256 timestamp;
    }

    Log[] public logs;

    event MessageLogged(address indexed sender, string message, uint256 timestamp);
    event LogsCleared(address indexed clearedBy, uint256 totalCleared);

    constructor() {
        owner = msg.sender;
        logCount = 0;
    }

    function logMessage(string memory message) public {
        logs.push(Log({
            sender: msg.sender,
            message: message,
            timestamp: block.timestamp
        }));
        logCount++;
        emit MessageLogged(msg.sender, message, block.timestamp);
    }

    function getLog(uint256 index) public view returns (address, string memory, uint256) {
        require(index < logs.length, "Index out of bounds");
        Log memory log = logs[index];
        return (log.sender, log.message, log.timestamp);
    }

    function getLogCount() public view returns (uint256) {
        return logCount;
    }

    function clearLogs() public {
        require(msg.sender == owner, "Only owner can clear logs");
        uint256 total = logs.length;
        delete logs;
        logCount = 0;
        emit LogsCleared(msg.sender, total);
    }
}
