// SPDX-License-Identifier: MIT
// https://eips.ethereum.org/EIPS/eip-4907

pragma solidity ^0.8.0;

interface IERC4907 {
    //sob, asum enq vor tokeniD(vory UINTa)-i hamar sahmanaum enq jamanakavor user, minchev nshvac metka vremeni
    event UpdateUser(uint indexed tokenId, address indexed user, uint64 expires);
//himnakan funkcia asum em talis em es NFT, es user-in minchev es datan
    function setUser(uint tokenId, address user, uint64 expires) external;
//stugum enq te ardyoq es BFT inch vor arendator uni kam arendatori hascen a galis kan 0yakan
    function userOf(uint tokenId) external view returns(address);
//stegh el nayum enq erba verjanum
    function userExpires(uint tokenId) external view returns(uint);
}