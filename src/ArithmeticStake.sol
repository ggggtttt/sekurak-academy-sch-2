pragma solidity ^0.7.6;

contract ArithmeticStake {

    address public owner;
    address public signer;
    uint256 public totalStaked; 
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lockTime;

    constructor () {
        owner = msg.sender;
        signer = msg.sender;
    }

    //User will not be able to transfer his fund for 15 days.
    function stake() external payable {
        totalStaked += msg.value; 
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 15 days;
    }

    function increaseLockTime(uint256 _timeinseconds) external {
        if (lockTime[msg.sender] > 0) {
            lockTime[msg.sender] = lockTime[msg.sender] + _timeinseconds;
        }
    }

    function unstake(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "insufficient funds");
        require(block.timestamp > lockTime[msg.sender], "lock time not expired");
        require(totalStaked - address(this).balance == 0, "requirement mismatch");
        
        balances[msg.sender] -= _amount;
        totalStaked -= _amount;

        (bool success,) = msg.sender.call{value: _amount}("");
        if (!success) revert();
    }

    function changeOwner(address newOwner) external {
        require(owner != msg.sender, "not an owner");
        owner = newOwner;
    }

    function emergencyWithdraw() external {
        if (owner == msg.sender) {
            (bool success,) = msg.sender.call{value: address(this).balance}("");
                if (!success) revert();
            return;
        }
        revert();
    }

    function unstakeWithSignature(uint256 _amount, bytes32 _secret, bytes32 _r, bytes32 _s, uint8 _v) external  {
        require(balances[msg.sender] >= _amount, "insufficient funds");
        require(totalStaked - address(this).balance == 0, "requirement mismatch");

        bytes32 hash = keccak256(abi.encodePacked(_amount, _secret, msg.sender));
        address _signer = ecrecover(hash, _v, _r, _s);

        if (signer != _signer) {
            revert("Invalid Signature");
        }
        
        totalStaked -= _amount;
        (bool success,) = msg.sender.call{value: _amount}("");
        if (!success) revert();
    }

    receive() external payable {}
}