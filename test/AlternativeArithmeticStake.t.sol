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
        owner = vm.addr(signerPrivateKey);
        user1 = vm.addr(1);
        user2 = vm.addr(2);
        vm.prank(owner);
        arithmeticStake = new AlternativeArithmeticStake();
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
    }

    function test_flowAlternativeArithmeticStake() public {
        assertEq(address(arithmeticStake).balance, 0);

        vm.prank(user1);
        arithmeticStake.stake{value: 5 ether}();

        vm.prank(user2);
        arithmeticStake.stake{value: 5 ether}();

        assertEq(address(arithmeticStake).balance, 10 ether);
    }
}
