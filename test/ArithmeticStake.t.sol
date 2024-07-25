// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;
pragma abicoder v2;

import {Test, console} from "forge-std/Test.sol";
import {ArithmeticStake} from "../src/ArithmeticStake.sol";

contract ArithmeticStakeTest is Test {
    address user1;
    address user2;
    address owner;
    uint256 signerPrivateKey;
    ArithmeticStake arithmeticStake;

    function setUp() public {
        signerPrivateKey = 0xabc123;
        owner = vm.addr(signerPrivateKey);
        user1 = vm.addr(1);
        user2 = vm.addr(2);
        vm.prank(owner);
        arithmeticStake = new ArithmeticStake();
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }

    function test_flowArithmeticStake() public {
    }

}
