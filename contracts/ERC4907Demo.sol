// SPDX-License-Identifier: MIT

//For the testing purposes onli
//Sa Standarti ogtagorcman Demona NFT Arenda enq talis inch vor jamanakov

//https://eips.ethereum.org/EIPS/eip-4907 
pragma solidity ^0.8.0;

import "./ERC4907.sol";

contract ERC4907Demo is ERC4907 {
//constructory kynduni NFT- anuny ev symvoly, u heto prosto deligiruem ERC4907-iy
    constructor(string memory name, string memory symbol) ERC4907(name, symbol) {}
       // vor karananaq mint anenq nor NFT, stegh daje owner- stugum arac chi
       //owner petqa avelacnel
        function mint(uint256 tokenId, address to) public {
            _mint(to, tokenId);
    }
}