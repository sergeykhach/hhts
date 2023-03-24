// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC1155.sol";
//pahelu metadatanery, tokeni amen ID pti lini arandzin silka
interface IERC1155MetadataURI is IERC1155 {
    function uri(uint id) external view returns(string memory);
}
//open zep-i mej ka rasshireni vor tuyl a talis ayl tarber baner pahel