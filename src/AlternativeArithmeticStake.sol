pragma solidity ^0.8.0;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract AlternativeArithmeticStake is AccessControl {

    bytes32 public constant BLACKLISTED_ROLE = keccak256('BLACKLISTED_ROLE');

    address public signer;
    uint256 public totalStaked; 
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lockTime;

    constructor () {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        signer = msg.sender;
    }

    //User will not be able to transfer his fund for 15 days.
    function stake() external payable {
        totalStaked += msg.value; 
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 15 days;
        
    }
    function increaseLockTime(uint256 _timeinsecond) external {
        if (lockTime[msg.sender] > 0) {
            lockTime[msg.sender] = lockTime[msg.sender] + _timeinsecond;
        }
    }

    function unstake(uint256 _amount) external  {
        require(!hasRole(BLACKLISTED_ROLE, msg.sender), "blacklisted");
        require(balances[msg.sender] >= _amount, "insufficient funds");
        require(totalStaked - address(this).balance >= 0, "requirement mismatch");
        require(block.timestamp > lockTime[msg.sender], "lock time not expired");
        
        balances[msg.sender] -= _amount;
        totalStaked -= _amount;
        (bool success,) = msg.sender.call{value: _amount}("");
        if (!success) revert();
    }

    function blackListStaker(address user, bool toggle) external onlyRole(DEFAULT_ADMIN_ROLE)  {
        if (toggle) {
            _grantRole(BLACKLISTED_ROLE, user);
        } else {
            _revokeRole(BLACKLISTED_ROLE, user);
        }
    }

    function emergencyWithdraw() external onlyRole(DEFAULT_ADMIN_ROLE)  {
        (bool success,) = msg.sender.call{value: address(this).balance}("");
            if (!success) revert();
        return;
    }

    function unstakeWithSignature(uint256 _amount, bytes32 _secret, bytes32 _r, bytes32 _s, uint8 _v) external  {
        require(balances[msg.sender] >= _amount, "insufficient funds");
        require(totalStaked - address(this).balance >= 0, "requirement mismatch");

        bytes32 hash = keccak256(abi.encodePacked(_amount, _secret));
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