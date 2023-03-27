// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

//wrong contract for testing purposes only S.K.
contract DutchAuction {
    uint private constant DURATION = 2 days;

    string public item; //apranqna 

    address payable public immutable seller; //imut consti mej en arjeq stanum
    uint public immutable startingPrice;
    uint public immutable startAt;
    uint public immutable expiresAt;
    uint public immutable discountRate;

    constructor(
        uint _startingPrice,
        uint _discountRate,
        string memory _item
    ) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        startAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;
        discountRate = _discountRate;

        require(_startingPrice >= _discountRate * DURATION, "starting price < min");

        item = _item;
    }

    function getPrice() public view returns (uint) {
        uint timeElapsed = block.timestamp - startAt;
        uint discount = discountRate * timeElapsed;
        return startingPrice - discount;
    } //info gorcogh gni

    function buy() external payable {
        require(block.timestamp < expiresAt, "auction expired"); //avartvac chi

        uint price = getPrice(); //giny chshtum enq
        require(msg.value >= price, "Not enought money"); // pti ugharkvac poghy pakas chlini gnic 

        uint refund = msg.value - price; //miangamic avel masyhet enq ugharkum
        if (refund > 0) { //ete ayn ka
            payable(msg.sender).transfer(refund);
        }
    }
}