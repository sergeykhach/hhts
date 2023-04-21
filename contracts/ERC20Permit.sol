// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20Permit.sol";
import "./ERC20.sol"; //nabor bibliotek iz OZ crypto lucumner en
import "./utils/Counters.sol";
import "./crypto/ECDSA.sol";
import "./crypto/EIP712.sol";

abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
    using Counters for Counters.Counter;

//schetchit karucvac counter bibloyi himan vra, ed byblon tuyl a talis incriment anel
//ambogh tiv, aysinqn ays hasceyi tery ugharkel a aysqan message, skzbnapes 0-n    
    mapping(address => Counters.Counter) private _nonces;

//type hash tuyl a talsi storagreluc voch te tesnel hashy vor voch mi ban ahaskanali chi nch e storagrum,
//ayl texty bacac cuyca talsi inch es ttoragrum aveli manramasn EIP 712-i mej
// takinini strukturan asum enq permit a mejy es amen inch , probel chka
    bytes32 private constant _PERMIT_TYPEHASH = keccak256(
        "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
    );

//constry yndunum a mer tokeni anuny, heto delagate anum a
//EIP712-i constructorin tokeni anuny u versian, ka stegh karas nayes
    constructor(string memory name) EIP712(name, "1") {}

//glkh func
    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external virtual {
        //stugum enq vor deadliny, chi ancel
        require(block.timestamp <= deadline, "expired");
//vostanovit enq anum of-chainum storagracy vor tenanq chishta te che
        bytes32 structHash = keccak256(
            abi.encode(
                _PERMIT_TYPEHASH,//verevi typhashy vooretgh sagh infona
                owner,
                spender,
                value,
                _useNonce(owner), //nerqevum ka
                deadline
            )
        );
//chisht dzevov hash anum ogtagorcelov gradarannery, prefix ban
        bytes32 hash = _hashTypedDataV4(structHash);
//andamneri enq bajanum te ova storagrel, verakangnum enq, hascen
        address signer = ECDSA.recover(hash, v, r, s);
//stegh el stugum eenq ardyoq storagroghy ownerna
        require(signer == owner, "not an owner");
//sagh verevinov menq vstahanum enq vor chisht info a u storgrela dramapanaki tery,
 //    dra hamar spender tuyl enq talis value chap token caxsi
 //_approve funcy ka erc20-i mej, voric jarangum enq       
        _approve(owner, spender, value);
    }

//piti haghordi vor hertakan noncna owneri mot
    function nonces(address owner) external view returns(uint) {
        return _nonces[owner].current();
    }

//EIP712 - meji funkciayin a kanchum u veradardznum atakiny
    function DOMAIN_SEPARATOR() external view returns(bytes32) {
        return _domainSeparatorV4();

    }

//petqa hashivy vytashit ani u ayn mecacni, sranov apahovum enq vro mi soobhsenin mi qani angam chkanchi 
    function _useNonce(address owner) internal virtual returns(uint current) {
        Counters.Counter storage nonce = _nonces[owner];

        current = nonce.current();
//miahatov avelacnum enq
        nonce.increment();
    }
}