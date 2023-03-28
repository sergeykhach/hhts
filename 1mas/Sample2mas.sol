// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

//For testing purposes only S.K.
contract Sample {
    uint a = 123; // 0
    uint[] arr;   //1 --> main(length) /slot-um miayn ira erkarutyunna linelu urish voch mi ban
    //isk masivneri elemntneri teghy gtnelu hamar
    //pti gtnenq ed sloti p=1-in tvyal depqum hash-y
    //keccak256(p) => 0x... ay es hamari slotic ksksi ira andamnery
    //return bytes32 vort teghavorumy slotneri qanaky 0-2**256 

    constructor() {
        arr.push(10);
        arr.push(20);
    }
}