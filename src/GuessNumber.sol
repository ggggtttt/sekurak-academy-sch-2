pragma solidity ^0.8.0;

contract GuessNumber {

    constructor() payable {
        require(msg.value >= 2 ether, "not enough pot");
    }

    function guessNumber(uint256 number) external payable {
        require(msg.sender.code.length == 0);
        require(tx.origin == msg.sender);
        require(msg.value >= 0.01 ether, "not enough bet");

        if (1 == uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, number))) % 500){
            (bool success,) = msg.sender.call{value: address(this).balance}("");
            if (!success) revert();
        }
    }

}