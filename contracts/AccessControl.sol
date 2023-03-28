// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./IAccessControl.sol";

abstract contract AccessControl is IAccessControl {
    struct RoleData {
        mapping(address => bool) members; //ardyoq es hascen ed rolin patkanum a
        bytes32 adminRole; //verevi dery 
        // uint count;
    }

    mapping(bytes32 => RoleData) private _roles; //amboghjy mappingum amen mi derihash tesqov hamar ira structuran

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00; //super admin

    //miayn konkret roly kara inch vor ban ani
    modifier onlyRole(bytes32 role) {
        _checkRole(role); //deri stugum
        _;
    }

//ka ardyoq tenc der te voch
    function hasRole(bytes32 role, address account) public view virtual returns(bool) {
        return _roles[role].members[account]; //mappingov u structov stugum a
    }//returns bool

//ov a dery admin anum
    function getRoleAdmin(bytes32 role) public view returns(bytes32) {
        return _roles[role].adminRole; //asum enq es admin dery qo harcrac deri hmara
    }

//der enq talis
    function grantRole(bytes32 role, address account) public virtual onlyRole(getRoleAdmin(role)) {
        _grantRole(role, account); //deligate anum 
    }
//dery vercnum enq
    function revokeRole(bytes32 role, address account) public virtual onlyRole(getRoleAdmin(role)) {
        _revokeRole(role, account); //deligate
    }
//mardy otkaz a anum menak inqy iran, pti ushadir linel vor super adminy inqy ira vric chgci 
    function renounceRole(bytes32 role, address account) public virtual {
        require(account == msg.sender, "can only renounce for self");
        // if role == DEFAULT_ADMIN_ROLE && count < 2...
        _revokeRole(role, account); //deligate
    }


//slujebni stugum a der
    function _checkRole(bytes32 role) internal view virtual {
        _checkRole(role, msg.sender);//asum dery iniciatri hmar stugi
    }
//takiny ayl realizacian a arden erku argumentov
    function _checkRole(bytes32 role, address account) internal view virtual {
        if(!hasRole(role, account)) {
            revert("no such role!");
        } //stugum enq 
    }

//admin konkret deri hamar
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
        bytes32 prevAdminRole = getRoleAdmin(role);

        _roles[role].adminRole = adminRole; //asum enq nor admin a haytnvum = asminrol-in

        emit RoleAdminChanged(role, prevAdminRole, adminRole);
    }

//dery talis slujebni
    function _grantRole(bytes32 role, address account) internal virtual {
        if(!hasRole(role, account)) {
            _roles[role].members[account] = true;
            emit RoleGranted(role, account, msg.sender);
        }//stegh proverka chen qanum verevum enq arel
    }//superadminy Demoyi constructorum enq dnum vor deployic heto lini

//vercnum enq
    function _revokeRole(bytes32 role, address account) internal virtual {
        if(hasRole(role, account)) {
            _roles[role].members[account] = false;
            emit RoleRevoked(role, account, msg.sender);
        }
    }
}