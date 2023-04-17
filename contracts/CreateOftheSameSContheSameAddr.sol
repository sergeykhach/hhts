//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

//1.deploy enq anum factorin nakhapes inch vor salt talov orinak "test"
//2. heto factorry i meji deploy funkciayov  deploy enq anum targey t contracty
//3. calc addresov hashvum enq expected hascen u stugum enq vor hamynkni pastaci deploy eghac hasceyi het log-i meji 0-n
//4.mer hasceic pogh enq ugharkum targetin, tenum enq vor balancy poxvela, set enq anum a u tugum enq vor call a anum grvac tivy
//5. destroy enq anum contracty u tenum enq vor el chi kanchum a 
//6.ba poghery vonc vercnenq, mnac vren? che ete salt-ov u bayt codov deploy enq anum karanq nuyn hasceyi vra noric anenq
//7.deployed contractin kpnelu hamar hascen grum enq anuny chisht dnum enq u sghmum ataddress
//8.jnjum enq deploy arac contracty, 
//9.noric sghmum enq factoryii deploy funckian u qani vory aghy nuyn a bytcodey nuyn a"contracticc karum enq meji getbytcodefuncov stanal" uremn nuyn hasceyi vra kani
// 10. ogharkac poghy mnac bayc a-n jnjvec , statey jnjvum a ameka

contract Factory {
    bytes32 immutable SALT;//create2 hamar pti salt unenanq

    event Deployed(address to);

    constructor(string memory _salt) { //imt contracti mej
        SALT = bytes32(bytes(_salt)); //talis enq end aghy
    }
//exp addr 0x40E27e2E34D0cC047B9a4f101313F9F1a29c6e98
//actual addrs 0x40E27e2E34D0cC047B9a4f101313F9F1a29c6e98
  //0xd3bAd72046C61aDC2D59993F104704733AF4776A
  //0xd3bAd72046C61aDC2D59993F104704733AF4776A
//0xd3bAd72046C61aDC2D59993F104704733AF4776A
    
    function deploy() external {
        address to = address(
        new Target{salt: SALT}()
        );

       // address targetCreator = address(
       //     new TargetCreator{salt: SALT}()
       // );
        // 0xffF3aB3867FC09a5715337934C07e349C6780A10
        

        emit Deployed( to);
    }
//taki funkciyov hashvum enq hascen
    function calcAddr() external view returns(address) {
        bytes32 h = keccak256(
            abi.encodePacked(
                bytes1(0xff), //vercvum a 1 bayt ays 16 nishanoc hasceic
                address(this), //ova deploy anum stegh ays smart contracty
                SALT, //aghy
                keccak256(getBytecode()) //hash arac ayn contracti bayt cody vory petqa deploy anel
            )
        );

        return address(uint160(uint256(h))); //veradardznum enq ayn hascen vory stanum enq 
        //hashi himan vra tiv enq artadrum, dra arajin 20byty=160bit addressna
    }

//target contracti bytecodnenq stanum
    function getBytecode() public pure returns(bytes memory) {
        bytes memory bc = type(Target).creationCode;//code enqstanum

        return abi.encodePacked(bc); //upakovka enq anum u bytes 
    }

//stegh mi hat el withdraw funkcia petqa dnel


   // receive() external payable {}
}

contract Target {
    address parent; //cnoghi hascen
    uint public a; 

    constructor() {
        parent = msg.sender; //stegh dnum enq
    }
//hanu enq poghery
    function withdraw() external {
        (bool ok, ) = parent.call{value: address(this).balance}("");
        require(ok, "failed!");
    }
//uzum em haskanam selfdestruct aneluc heto a-n kmna te chi mna
    function setA(uint _a) external {
        a = _a;
    }
//jnjum enq contracty ev poghy ugharkum enq cnoghin
    function destroy() external {
        selfdestruct(payable(parent));
    }
//vor pogh karananq gcenq
    receive() external payable {}
}
