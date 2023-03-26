import { loadFixture, ethers, expect, time } from "./setup";
import type { LowkickStarter } from "../typechain-types";
import { Campaign__factory } from "../typechain-types";//hatuk obyekta vor heto petqa funker kanchenq

describe("LowkickStarter", function() {
  async function dep() {
    const [ owner, pledger ] = await ethers.getSigners(); //erku acc

    const LowkickStarterFactory = await ethers.getContractFactory("LowkickStarter");//glkhavor contracti deployi hamar factory enq sarqum
    const lowkick: LowkickStarter = await LowkickStarterFactory.deploy(); //heto deploy enq anum
    await lowkick.deployed(); //deploy eghav

    return { lowkick, owner, pledger } // veradardznum enq  sranq
  }

  it('allows to pledge and claim', async function() {
    const { lowkick, owner, pledger } = await loadFixture(dep);// heto kanchum enq dep funkcian u dra returnery veragrum enq constneri

    const endsAt = Math.floor(Date.now() / 1000) + 30; //mili varkyan JS-um isk blokchaynum varkyan , stegh kompi tevoghuntyun 30 vrk
    const startTx = await lowkick.start(1000, endsAt); //avarty
    await startTx.wait();//avertvec

    const campaignAddr = (await lowkick.campaigns(1)).targetContract; // stanum enq compain-i addr-na , vercvum a Campaings mappingic, 1 vortev arajina
    const campaignAsOwner = Campaign__factory.connect(
      campaignAddr,
      owner
    );// hima uzum em ed hascein kpnenq ustroitelic, stegh arden kpnum enq , stegh mer sm con i privyazkeqnen

    expect(await campaignAsOwner.endsAt()).to.eq(endsAt); // hima uzum enq vor avarti jamanaky chshtenq 

    const campaignAsPledger = Campaign__factory.connect(
      campaignAddr,
      pledger //hima pledgher acc-ic enq kpnum
    );

    const pledgeTx = await campaignAsPledger.pledge({value: 1500});//pojertv enq anum
    await pledgeTx.wait();//avartvec tx-y

    await expect(campaignAsOwner.claim()).to.be.reverted; //hima uzum enq 30 vrk chancac kara vclaim ani vercni pogher u rever t pti lini
    expect((await lowkick.campaigns(1)).claimed).to.be.false; //nayev pti tru chdarna

    await time.increase(40); //mecacnum enq jamanaky 40 varkyanov u mine anum nor datark blok , time helperov vory hasaneli a en tooboxi ogt-i jamanak
//yndegh urish  tarber helperner kan mine anel datark bloker, tarber acc-nero ashxatel ev ayln 
//ka nayev increaseTo()vortegh nshum enq en metka vrem. vor chapin uzum enq datark blok sarqenq 


//stugum enq vor claim kancheluc es mardkanc pogheri popoxutyuny chisht a linum te che
    await expect(() => campaignAsOwner.claim()).
      to.changeEtherBalances([campaignAsOwner, owner], [-1500, 1500]);

    expect((await lowkick.campaigns(1)).claimed).to.be.true; // mek el true a darnum
  });
});