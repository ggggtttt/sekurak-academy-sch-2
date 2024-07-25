// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import {Test, console} from "forge-std/Test.sol";
import {GuessNumber} from "../src/GuessNumber.sol";
import {GuessNumberAttack} from "../src/GuessNumberAttack.sol";

contract GuessNumberTest is Test {
    address user1;
    address owner;
    GuessNumber guessNumber;

    function setUp() public {
        user1 = vm.addr(1);
        owner = vm.addr(2);
        vm.deal(user1, 1 ether);
        vm.deal(owner, 2 ether);
        vm.prank(owner);
        guessNumber = new GuessNumber{value: 2 ether}();
    }

    function test_flow1() public {
        vm.startPrank(user1);
        guessNumber.guessNumber{value: 0.01 ether}(1);
        GuessNumberAttack guessNumberAttack = new GuessNumberAttack(guessNumber);
        guessNumberAttack.guessNumberAttack{value: 0.01 ether}();
        vm.stopPrank();

        assertEq(user1.balance > 2 ether, true);
    }
}
