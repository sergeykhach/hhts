import { loadFixture, ethers, expect, time } from "./setup";

describe("DutchAuction", function() {
  async function deploy() {
    const [ user ] = await ethers.getSigners();

    const Factory = await ethers.getContractFactory("DutchAuction");
    const auction = await Factory.deploy( //ete uzum enq constructorum arjeqner tanq stegh pti tanq
      1000000,
      1,
      "item"
    );
    await auction.deployed(); // block1

    return { auction, user } //deploy func-i veradardzy
  }

  it("allows to buy", async function() {
    const { auction, user } = await loadFixture(deploy); //stanum u veragrum enq

    await time.increase(60); // block2 //60 vrk, mecacnum enq jamanaky , timic(network helpersic) enq qashum yndegh liqy urish helpersner kan
//karanq mecacnenq balanc ban

    const latest = await time.latest(); // verjin blocki timstamy (helper)
    //hajordin asum enq senc pti lini
    const newLatest = latest + 1; // eli helper a, veradzr verjin blocko time stampy
    //asum enq him amine es anelu block timestampy kdnes verei gracy
    await time.setNextBlockTimestamp(newLatest); //asum enq verjin blocky vor mine anes dir ays timestampy
//u ayspisov menq gitenq te inch t.s linelu hajird blockin

//hima qani vor arden hstak gitenq timy hashvum enq vonc vor contractum
    const startPrice = await auction.startingPrice(); //skzbnakan gin
    const startAt = await auction.startAt();//erb a sksel aukciony
    //newlatesty normal tiva bayc blockkchaini het kapvac tveryy orinak startat-y big number a
    //ethers ethers.BigNumber-ov sovorakan tvic big number enq sarqum
    const elapsed = ethers.BigNumber.from(newLatest).sub(startAt); //inchqan a ancnel, qani vor big number a dra hamar -=sub, *=mul
    const discout = elapsed.mul(await auction.discountRate());//stanum enq inchqan poqracav
    const price = startPrice.sub(discout); //es pahi giny 

    const buyTx = await auction.buy({value: price.add(100)}); // 3block pordzum enq ughenq giny qani vor en jamanak erb gin enq uzum arden 3rblockna u jamanakai hetvanqov itemi giny mimqich el aynknum
  //u refundi stugelu hamar avel gumar en qdnum
    await buyTx.wait(); //spasum enq vor tx-lini

    expect(
      await ethers.provider.getBalance(auction.address)
    ).to.eq(price); //stugum enq 

    await expect(buyTx).to.changeEtherBalance(user, -price);
  });//stugum enq vor useri balancy poxvec caxsaci chap
});