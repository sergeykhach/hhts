import { loadFixture, ethers, expect, time } from "./setup";
import { BigNumber } from "ethers";

describe("Sample", function() {
  async function deploy() {
    const [ owner ] = await ethers.getSigners();

    const Factory = await ethers.getContractFactory("Sample");
    const sample = await Factory.deploy();
    await sample.deployed(); 

    return { owner, sample } //deploy func-i veradardzy
  }

  //spomogatilni funkcia, vory kardalu static, arg addr ev sloti hamary
  async function getAt(addr: string, slot: number | string | BigNumber ){
    //takinov karum enq ughigh kardanq sloty smart contractic 
   return await ethers.provider.getStorageAt(addr, slot);
  }

  it("checks state", async function() {
    const { sample } = await loadFixture(deploy); //stanum u veragrum enq
   
    //takinov asum enq vor mer hetaqrqrogh slot pos hashvum enq keccakov
    //bayc qani vro dinamik massivi erku andam unenq uzum enq irar hajordogh erku 
    //slotnery tenanq dra hamar big number enq sarqum vor karananq gumarenq 1 hexadecimal, 16nishanoc tvery
    const pos = ethers.BigNumber.from(
      ethers.utils.solidityKeccak256(
      ["uint256"],
      [1]
      )
    );
    //ev sa mez ktani ayn sloti hamar bignumber sarqac vortegh gtnvum mer dinamik massivi arajin elementy
    
    const nextPos = pos.add(ethers.BigNumber.from(1)); //avelacnum enq 1 pos-in vor hajord slotnel tenanq vortegh dinamik masivi hajord andamna 20-y 
    const slots = [0, 1, 2, pos, nextPos ]; //slotnery array-i mej enq drel
    slots.forEach(async (slot) => { //amen mekov ancnum enq 
      console.log(slot.toString(), "==>", await getAt(sample.address, slot)); //u visualizacia en q anum
    }); //sloty saarqum enq string slot.toString() vor big numberic togh stananq
  });
});