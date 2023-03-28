// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


interface IAccessControl {

//stegh rol enq talsi arajin toghy keccak enq anum pashtony u hashn enq pahum
    //erkrordy1 um enq talis
    //ova talis
    event RoleGranted(
      bytes32 indexed role, 
      address indexed account,
      address indexed sender
    );

//stegh roly het enq vercnum arajin toghy keccak enq anum pashtony u hashn enq pahum
    event RoleRevoked(
      bytes32 indexed role,
      address indexed account,
      address indexed sender
    );

//ete poxum enq admin dery ukazani deri hamar
//1` dery,2` ov er araj admin anum , 3` ova hima admin anelu
    event RoleAdminChanged(
      bytes32 indexed role,
      bytes32 indexed previousAdminRole,
      bytes32 indexed newAdminRole
    );


//ova admin inch vor deri hamar
    function getRoleAdmin(bytes32 role) external view returns(bytes32);

//der enq talis
    function grantRole(bytes32 role, address account) external;

//otzyv roli
    function revokeRole(bytes32 role, address account) external;

//ete mardy chi uzum ed dery kara otkaz ani sranov
    function renounceRole(bytes32 role, address account) external;
}