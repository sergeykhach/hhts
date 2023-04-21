// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./ERC20.sol"; //import enq anum
import "./ERC20Permit.sol";//standartn u permity

contract MyToken is ERC20, ERC20Permit { //asum enq vor jarangum enq
    address private owner; //popoxakan enq sahmanum

    modifier onlyOwner() { //modifier
        require(msg.sender == owner);
        _;
    }
//anpayman constructory mejic deligate enq anum erku cnoghnerin el, MyToken ev versian(1teg)
//vortev yndegh el dalshe probsheni pti lini constructory mej
    constructor() ERC20("MyToken", "MTK") ERC20Permit("MyToken") {
        owner = msg.sender; //ownerin enq hastatum
        _mint(msg.sender, 100 * 10 ** decimals());//100tokeni emit enq anum, pastaci decimely havasar a 0-
    }

    function mint(address to, uint amount) public onlyOwner {
        _mint(to, amount);
    }
}