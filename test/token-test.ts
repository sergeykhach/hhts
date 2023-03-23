import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers, upgrades } from "hardhat"; //upgrades plaginy hh configum piti lini

describe("Upgradeable token", function() {
  async function dep() {
    const [ deployer ] = await ethers.getSigners();//hanum enq arajin hashivy 0 indexov

    const NFTFactory = await ethers.getContractFactory("MyToken");//smart contracty gtnumm enq 
    const token = await upgrades.deployProxy(NFTFactory, [], {//deploy enq anum ham proxin(ira het el mycontracty) argery NFT factorin u initialayzi arg-y qani vor datark a mer mot datark array a  
      initializer: 'initialize',
     // kind: 'uups',//defaulty transparent patterna
    }); //tokenin dimeluc dimelu enq proxiin, vori mej 
    await token.deployed(); //arden deploy eghaca

    return { token, deployer }
  }

  it('works', async function() {
//dep nenq kancum, u stanum enq deployer hascen u token 
    const { token, deployer } = await loadFixture(dep);
//mint  enq anum kanchelov funkcian 123 uri-na
    const mintTx = await token.safeMint(deployer.address, "123abc");
    await mintTx.wait();

    //asum enq 1 NFT pti lini es ameni ardyunqum
    expect(await token.balanceOf(deployer.address)).to.eq(1);

    //sa el v2 - hamar
    const NFTFactoryv2 = await ethers.getContractFactory("MyTokenV2"); //nor versian
    const token2 = await upgrades.upgradeProxy(token.address, NFTFactoryv2); //ubgrade enq anum nor 

    expect(await token2.balanceOf(deployer.address)).to.eq(1); //stugum enq vor ankax v1-v2 popoxutyunic balanci 1 NFT mnuma
    expect(await token2.demo()).to.be.true; //en demo funkcian kontracti ashkhatuma
    console.log(token.address); //hascenery nuyna talu votev nuyn proxii hascena
    console.log(token2.address);
  });
});