// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

//For testing purposes only!!!
//sarqum enq contract u ugharkum enq mer storagrun front enov vory hnaravorutyunkta
//urishin stanal pogh u gazy inqy vcharel mer storagrutyamb
//https://docs.soliditylang.org/en/v0.8.19/solidity-by-example.html stegh ka ed funkcionaly
//Alice only needs to send cryptographically signed messages off-chain (e.g. via email) to Bob and it is similar to writing checks.

//using ts instead of js in a page...and ethers.js instead of web3.js

contract Payments {
    address public owner; //ov ugharkel

    mapping(uint => bool) nonces; //hetevum enq noncerin vor erku angam chqashi pogh, ushadir nuyn kontracty vor eli deploy anenq chi hetevi
//orinak kara meky myusin transherov pogh ta yst ardyunqi
    constructor() payable{
        require(msg.value > 0); //asum enq vor petqa pogh gcac lini mejy skzbic
        owner = msg.sender; 
    }

//ays funkcian el piti kanchi poluchately
    function claim(uint amount, uint nonce, bytes memory signature) external { //poghi chapy, nonce ev storagrac soobsheniyan piti mutq ani kanchelu 
        require(!nonces[nonce], "Nonce already used!!!"); //stugum enq ardyoq nonce chi ogtagorcvel

        nonces[nonce] = true; //arden miangamic poxum enq statusy vor el chkarana kanchi

//aystegh petqa vossazdat anenq en soobsheniyan vor offchayn storagraca eghel
        bytes32 message = withPrefix(keccak256(abi.encodePacked( //keccakov u abi hash enq anum es pakety dimacinov el heto funkciayov prefix kavelacnenq qani vor tenc anum a soliditin isk stegh menq pti stananq en inch vor anum a
            msg.sender, //канchума астацогхы, ира хасцен
            amount, //gumari chapy
            nonce,
            address(this) //kontracti hascen
        )));

        require(
            recoverSigner(message, signature) == owner, "invalid signature!" //stacac storagrutyuny hamematum enq tiroj het ete nuyna apa ok
        );

        payable(msg.sender).transfer(amount); //ete sagh chisht a abres staci qo poghery
    //poghy cher stana ete gumary, kam nonce, kam storgrutyuny chisht chliner
    }
//verakangnum enq storagroghin
    function recoverSigner(bytes32 message, bytes memory signature) private pure returns(address){
       //raspokovat enq anum es ereq argumennery
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(signature);
    // solidity nerkarucvac funkcia vory tuyl a talis tenal ov a i skzbane storgrel ayd soobsheniyan, ete terna uremn sagh chishta
        return ecrecover(message, v, r, s); //veradardznum a hascen skzbnakan storagroghi
    }

//veredardznum a erku himnakan parametr r ev s ev mi hat erkrordakan v vorpeszi haskananaq kakaoy zakrytyy klyuch a ogtagiorcvel varifikacia anelu hamapatasxan tx-n
    function splitSignature(bytes memory signature) private pure returns(uint8 v, bytes32 r, bytes32 s) {
        require(signature.length == 65);// stugum enq vor storagrutyan erk 65byta (qani vor kazvac a 65*2=130 symbolneric);
    //hima memory gcac signatura ic qashum enq 

//assemblyn yuly mez stegh petqa vor chisht dzevov ktrtenq mer signaturan u hanenq en infon vor mez petq chi
        assembly {
            r := mload(add(signature, 32)) //asum enq ot nachala signatury arajanum es 32 bytes, u yndeghis sksum es kardal info
//ajsinqn arajin 32 byty bac enq toghnum qani vor ayntegh gtnvum a prefixy vory mez aydqan el petq chi, karanq kardanq yul-i mload funkcian , soliditylang.org-ic
            s := mload(add(signature, 64)) 
   //stegh sagh nuyn a bayc sksum enq 64-ic
   
   //v-n pti lini 1byte vorny nuyna inch uint
            v := byte(0, mload(add(signature, 96))) //sranov vercnum enq 0-indexov pastaci arajin byty
        }

        return (v, r, s);

    }

//slujebni funkcian a vory bytes 32 yndunum u veradarzdnum a standart solidity oficiali prefixy u irar het mi hat el hesh anum 
    function withPrefix(bytes32 _hash) private pure returns(bytes32) {
        return keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                _hash)
            );
    }


}

