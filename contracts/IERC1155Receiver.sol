// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//721 uzum enq harcnel stacoghin vercnum es tokeny te che, ev spasum enq vor selector` 4byte
interface IERC1155Receiver {
    function onERC1155Received(
        address operator,
        address from,
        uint id,
        uint amount,
        bytes calldata data
    ) external returns(bytes4);

//es el paketi hamar uzum enq harcnel stacoghin vercnum es tokeny te che, ev spasum enq vor selector` 4byte
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint[] calldata ids,
        uint[] calldata amounts,
        bytes calldata data
    ) external returns(bytes4);
}