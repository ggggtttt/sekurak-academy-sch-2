// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import {Test, console} from "forge-std/Test.sol";
import {AlternativeArithmeticStake} from "../src/AlternativeArithmeticStake.sol";

contract AlternativeArithmeticStakeTest is Test {
    address user1;
    address user2;
    address owner;
    uint256 signerPrivateKey;
    AlternativeArithmeticStake arithmeticStake;

    function setUp() public {
        signerPrivateKey = 0xabc123;
        user1 = vm.addr(1);
        user2 = vm.addr(2);
        owner = vm.addr(signerPrivateKey);
        vm.prank(owner);
        arithmeticStake = new AlternativeArithmeticStake();
        vm.deal(user1, 1 ether);
        vm.deal(user2, 1 ether);
    }

    function test_flowAlternativeArithmeticStake() public {
        vm.prank(user1);
        arithmeticStake.stake{value: 1 ether}();

        vm.warp(block.timestamp + 15 days + 1);

        vm.prank(owner);
        arithmeticStake.blackListStaker(user1, true);

        vm.startPrank(user1);
        arithmeticStake.renounceRole(arithmeticStake.BLACKLISTED_ROLE(), user1);
        vm.stopPrank();

        vm.prank(user1);
        arithmeticStake.unstake(1 ether);
    }

}
