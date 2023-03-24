import { loadFixture } from "@nomicfoundation/hardhat-network-helpers"; //zagrujat smart contracty
import { expect } from "chai"; //testeri hamar
import { ethers } from "hardhat";
import { Sample, Sample__factory } from "../typechain-types"; //haytnvuma copile aneluc heto,factorii mijocov karanq nayev arden deploy arac contarctneri het ashxatenq factorium nayev abi ka
//https://github.com/dethcrypto/TypeChain urish funkcianer el uni

//funkcia anonim vor pti mer sm contrakty nkaragri
describe("Sample", function() {
  async function deploy() {
    const [ deployer, user ] = await ethers.getSigners(); //hashinery arajin erku

    const SampleFactory = await ethers.getContractFactory("Sample");//ira mej parunakaum a obyekt vori mijocov deploy enq anelu, inqna bytecode chisht dzevov qashelu smart contracty ev deploy anelu localum u amen angma anjatvum 
    //karainq prosto greinq const sample=... ete cheinq uzum arden deploy arac contri het ashxatenq
    const sample: Sample = await SampleFactory.deploy();//spasum enq deploy
    await sample.deployed();//eghav deploy, cavoq srti asum stegh abi cehnq karum gtnenq bayc karogha karum enq artifactsnerum

    return { sample, deployer, user } //veradzardznum a 
  }

  it("allows to call get()", async function() {
    const { sample, deployer } = await loadFixture(deploy);//deploy enq anum u sampli(vory celi obyekta) vra akaranq bolor funkcianery kanchenq inch ka contractum 

    expect(await sample.get()).to.eq(42);//kanchum enq pti havasar lini 42
  });

  it("allows to call pay() and message()", async function() {
    const { sample, deployer } = await loadFixture(deploy);

    const value = 1000;
    const tx = await sample.pay("hi", {value: value});
    await tx.wait();

    expect(await sample.get()).to.eq(value);
    expect(await sample.message()).to.eq("hi");
  });//kanchum eqn pay funkcian u stugum enq ardyoq msg u valyun brnuma

  
  //hima el user hashivov ashxatum em deploy arac contracti het , kanchelov callmi funcian
  it("allows to call callMe()", async function() {
    const { sample, user } = await loadFixture(deploy);

    const sampleAsUser = Sample__factory.connect(sample.address, user);//deploy aracin em kpnum factory
    const tx = await sampleAsUser.callMe();//user accoutov
    await tx.wait();

    expect(await sampleAsUser.caller()).to.eq(user.address);//stugum enq ardyoq userov enq kpel
  });

  it("reverts call to callError() with Panic", async function() {
    const { sample, deployer } = await loadFixture(deploy);

    await expect(sample.callError()).to.be.revertedWithPanic();
  });//esa panicy berum konkret nor waffle-ov, sra hamar await teghy poxum a
});