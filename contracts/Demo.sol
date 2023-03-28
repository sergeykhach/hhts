// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./AccessControl.sol"; //podrubayem

contract Demo is AccessControl { //jarangum enq
    bool paused;
//optimizaciayi  hamar karanq keccaky hashvenq nor dnenq
    bytes32 public constant WITHDRAWER_ROLE = keccak256(bytes("WITHDRAWER_ROLE"));///ayly der orinak sagh pogheryyy karavercni
    bytes32 public constant MINTER_ROLE = keccak256(bytes("MINTER_ROLE")); //togharkoghi der

    constructor(address _withdrawer) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender); //ogtvelov jarang-ic _podcherkov super admin enq nshanakum

        _grantRole(WITHDRAWER_ROLE, _withdrawer); //stegh el dery talis enq

        _setRoleAdmin(MINTER_ROLE, WITHDRAWER_ROLE); //dery talis es angam vereviny
    }

//amen meki 
    function withdraw() external onlyRole(WITHDRAWER_ROLE) {
        payable(msg.sender).transfer(address(this).balance);
    }

    function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        paused = true;
    }
}
