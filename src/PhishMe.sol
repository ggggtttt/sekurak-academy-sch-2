pragma solidity ^0.8.0;

contract PhishMe {

    mapping(address => uint) public balances;

    function deposit() public payable {
        require(tx.origin == msg.sender, "not authorised");
        balances[msg.sender] += msg.value;
    }

    function transfer(address _from, address  _to, uint _amount) public {
        require(tx.origin == _from, "not authorised");
        require(balances[tx.origin] >= _amount, "not enough funds");

        balances[_to] += _amount;
        balances[tx.origin] -= _amount;

        (bool sent, ) = payable(_to).call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }

    function withdraw() public {
        uint balance = balances[tx.origin];
        require(balance > 0);

        (bool sent, ) = tx.origin.call{value: balance}("");
        require(sent, "Failed to send Ether");
        balances[tx.origin] = 0;

    }

    //Other functionality removed.
}