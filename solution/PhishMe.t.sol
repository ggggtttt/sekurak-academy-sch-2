// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import {Test, console} from "forge-std/Test.sol";
import {PhishMe} from "../src/PhishMe.sol";
import {PhishMeAttack} from "../src/PhishMeAttack.sol";

contract PhishMeTest is Test {
    address user1;
    address user2;
    address owner;
    PhishMe phishMe;

    function setUp() public {
        user1 = vm.addr(1);
        user2 = vm.addr(2);
        owner = vm.addr(3);

        vm.deal(user1, 1 ether);
        vm.deal(user2, 2 ether);
        vm.startPrank(owner);
        phishMe = new PhishMe();
        vm.stopPrank();
    }

    function test_phishMe() public {
        vm.startPrank(user1, user1);
        phishMe.deposit{value: 1 ether}();
        vm.stopPrank();
        
        assertEq(address(phishMe).balance, 1 ether);

        vm.prank(user2);
        PhishMeAttack phishMeAttack = new PhishMeAttack(phishMe);

        vm.startPrank(user1, user1);
        phishMeAttack.transfer(user1, address(0), 11 ether);
        vm.stopPrank();

        assertEq(address(user2).balance, 3 ether);
    }
}
