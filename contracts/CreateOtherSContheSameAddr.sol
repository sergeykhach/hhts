//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;
//taki commentnery nuynSK nuyn addr-i vra dnelna, heto ayl commetnerum ka tearber SK-i nuyn hasceum dnelu mekhanizmy
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
    
    function deploy() external {
       // address to = address(
       // new Target{salt: SALT}()
       // );

       address targetCreator = address(
        new TargetCreator{salt: SALT}()
        );
        // 0xffF3aB3867FC09a5715337934C07e349C6780A10
        

        emit Deployed(targetCreator);
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

contract TargetCreator { //proxina nerqevum xosum enq
    address parent;

    event TargetDeployed(address to);

    constructor() {
        parent = msg.sender;
    }
//teargetna deploy anum aranc Salt creatov
    function deployTarget() external {
        address target = address(
            new Target()
        );
        // 0x4a752bef9DbEB1233982C9C252eB3675E25bfd59
        //0x4a752bef9DbEB1233982C9C252eB3675E25bfd59

        emit TargetDeployed(target);
    }

//es el NT-n eli aranc salr
//es nuyn banery karanq anenq assembly-ov instructionov ogtagorcelov OPcode create, vory yndunum a kamayakan BYtecode...
    function deployNewTarget() external {
        address newTarget = address(
            new NewTarget()
        );
        // 0xdbdACC32C5E98615768BC3296a38f51CA9f98195

//0xfB4bA16B8F9Dd1ac8D55b6cc8222B01178e55832

//0xfB4bA16B8F9Dd1ac8D55b6cc8222B01178e55832
        emit TargetDeployed(newTarget);
    }

//jnjum enq heto vor noric deploy
    function destroy() external {
        selfdestruct(payable(parent));
    }
}

contract Target {
    address parent; //cnoghi hascen
    uint public a; 

    constructor() {
        parent = msg.sender; //stegh dnum enq
    }
//hanum enq poghery
    function withdraw() external {
        (bool ok, ) = parent.call{value: address(this).balance}("");
        require(ok, "failed!"); //stegh cnoghin a ugharkum 
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

//takiny qaylerna lriv urish contract deploy anelu nuyn hasceyi
//1.deploy factoryii
//2.vory ira hertin ptii promejutochni contract sarqi proxy`TargetCreator, ogtagorcelov create2 fn
//3.heto sa ir hertin, pti sovorakan creat-ov sarqi Target
//4.heto es Targety kjnkenq u sra teghy kdnenq NewTargety
//5.Patcary ena vor craeaty yndunum a erku parametr`
// 1. nonce
// 2. deployer address, ev baytkody tegh kapchuni ibr te bayc,
//6.erb vor Target Creatory sarqi Target u heto el New target pti urish nonce lini,
//7.Bayc ete Target creatory nuynpes jnjvi self destructov 
//8 u heto noric sarqvi create erkusov uremn Nonce zbroshen klini
//9 u menq kkaroghananq Target Creatory vra create funkcia sarqenq u u lyuboy drugoy baytcode dnenq , qani vory noncenuyny klini u hascen
//aysinqn senc kareli a cuyc tal urish SK heto teghy ayl dnel u xabel
//sxema
// Factory --> (create2) TargetCreator --> (create) Target
// create:
// 1. nonce
// 2. deployer address

contract NewTarget { //nor urish contract
    address public parent;
    uint public a;

    constructor() {
        parent = msg.sender;
    }

    function withdraw(address _to) external {
        (bool ok, ) = _to.call{value: address(this).balance}("");
        require(ok, "failed to withdraw!"); //stgeh lyuboyin ov sghmi :)
    }

    function setA(uint _a) external {
        a = _a;
    }

    receive() external payable {}
}
