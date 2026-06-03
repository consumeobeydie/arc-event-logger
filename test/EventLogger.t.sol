// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../src/EventLogger.sol";

contract EventLoggerTest is Test {
    EventLogger eventLogger;
    address owner;
    address user;

    function setUp() public {
        owner = address(this);
        user = address(0x1234);
        eventLogger = new EventLogger();
    }

    function testInitialLogCount() public view {
        assertEq(eventLogger.getLogCount(), 0);
    }

    function testLogMessage() public {
        eventLogger.logMessage("Hello Arc!");
        assertEq(eventLogger.getLogCount(), 1);
    }

    function testGetLog() public {
        eventLogger.logMessage("Hello Arc!");
        (address sender, string memory message, uint256 timestamp) = eventLogger.getLog(0);
        assertEq(sender, address(this));
        assertEq(message, "Hello Arc!");
        assertGt(timestamp, 0);
    }

    function testMessageLoggedEvent() public {
        vm.expectEmit(true, true, true, true);
        emit EventLogger.MessageLogged(address(this), "Hello Arc!", block.timestamp);
        eventLogger.logMessage("Hello Arc!");
    }

    function testClearLogs() public {
        eventLogger.logMessage("Hello Arc!");
        eventLogger.logMessage("Building on Arc!");
        eventLogger.clearLogs();
        assertEq(eventLogger.getLogCount(), 0);
    }

    function testOnlyOwnerCanClear() public {
        eventLogger.logMessage("Hello Arc!");
        vm.prank(user);
        vm.expectRevert("Only owner can clear logs");
        eventLogger.clearLogs();
    }
}
