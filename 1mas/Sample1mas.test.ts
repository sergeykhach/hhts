import { loadFixture, ethers, expect, time } from "../test/setup";

describe("Sample", function() {
  async function deploy() {
    const [ owner ] = await ethers.getSigners();

    const Factory = await ethers.getContractFactory("Sample");
    const sample = await Factory.deploy();
    await sample.deployed(); 

    return { owner, sample } //deploy func-i veradardzy
  }

  //spomogatilni funkcia, vory kardalu static, arg addr ev sloti hamary
  async function getAt(addr: string, slot: number){
    //takinov karum enq ughigh kardanq sloty smart contractic 
   return await ethers.provider.getStorageAt(addr, slot);
  }

  it("checks state", async function() {
    const { sample } = await loadFixture(deploy); //stanum u veragrum enq
    const slots = [0, 1, 2]; //slotnery array-i mej enq drel
    slots.forEach(async (slot) => { //amen mekov ancnum enq 
      console.log(slot, "==>", await getAt(sample.address, slot)); //u visualizacia en q anum
    });
  });
});