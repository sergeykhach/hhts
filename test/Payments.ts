import { loadFixture, ethers, expect, time } from "./setup";
import type { Payments } from "../typechain-types";

describe("Payments", function() {
  async function deploy() {
    const [ owner, receiver ] = await ethers.getSigners();

    const Factory = await ethers.getContractFactory("Payments");
    const payments: Payments = await Factory.deploy({
      value: ethers.utils.parseUnits("100", "ether") //deployi momentin contarcti vra 100 eth enq dnum
    });

    return { owner, receiver, payments }
  }

  it("should allow to send and receive payments", async function() {
    const { owner, receiver, payments } = await loadFixture(deploy);

    const amount = ethers.utils.parseUnits("2", "ether"); //asum enq 2 eth vercru
    const nonce = 1; //arajin tx-na

    //inchpes message formirovat anenq vonc vorSC-um nayir taky
    const hash = ethers.utils.solidityKeccak256(
      ["address", "uint256", "uint256", "address"],//typern enq talsi bankomaty
      [receiver.address, amount, nonce, payments.address] //recivery pti tx-ani qani vor stacoghna kanchum claim funkcian teche hashery chen brni irar
    ); //hash- stacanq aranc prefixi

    // console.log('hash -->', ethers.utils.solidityKeccak256(
    //   ["string", "bytes32"],
    //   ["\x19Ethereum Signed Message:\n32", hash]
    // )); // stegh kpcnum enq prfixy

    //minchev stoargrely sa petqy, vor patrastenq storagrutyan
    const messageHashBin = ethers.utils.arrayify(hash);
    //storagrum enq, owneri anunic u talis enq verevi ptrastvac heshy
    const signature = await owner.signMessage(messageHashBin);
    console.log(signature) //stegh prefixy petq chi, qani vor verevum da avtomat anum ethersum

    const tx = await payments.connect(receiver).claim(amount, nonce, signature);
    await tx.wait();

    expect(tx).to.changeEtherBalance(receiver, amount);
  });
});
