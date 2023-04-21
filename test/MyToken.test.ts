import { loadFixture, ethers, SignerWithAddress, expect } from "./setup";
import type { MyToken, Proxy} from "../typechain-types";

interface ERC2612PermitMessage { //tip danniner vor nerqevi promisov veradardzvuma
  owner: string;
  spender: string;
  value: number | string;
  nonce: number | string;
  deadline: number | string;
}

interface RSV { //tip danniner vor nerqevi promisov veradardzvuma
  r: string;
  s: string;
  v: number;
}

//domain separatori interface
interface Domain {
  name: string; //tokeni anuny
  version: string; //versian
  chainId: number; //harhati chanid-n kdnenq stegh
  verifyingContract: string; //contracty vory varifikacia anum es storagrutyuuny
}

//nerqevum enq kirarum nuyndzev inch permitu sagh anum enq 
//https://eips.ethereum.org/EIPS/eip-712 vor imananq inch enq storagrum
function createTypedERC2612Data(message: ERC2612PermitMessage, domain: Domain) {
  return {
    types: {
      Permit: [//sagh tegheri typna permit
        { name: "owner", type: "address" },
        { name: "spender", type: "address" },
        { name: "value", type: "uint256" },//partadir a uint256 
        { name: "nonce", type: "uint256" },
        { name: "deadline", type: "uint256" },
      ]
    },
    primaryType: "Permit", 
    domain, //senc sagh kpcnum enq
    message,
  };
}

//esel storgrutyuny maseri bajanelu hamara taky ka
function splitSignatureToRSV(signature: string): RSV {
  const r = '0x' + signature.substring(2).substring(0, 64);
  const s = '0x' + signature.substring(2).substring(64, 128);
  const v = parseInt(signature.substring(2).substring(128, 130), 16);

  return { r, s, v };
}

async function signERC2612Permit(
  token: string, //hascen adressy ts-um stringa
  owner: string, //hascen
  spender: string, //hascen
  value: string | number,
  deadline: number,
  nonce: number,
  signer: SignerWithAddress //ov vor storagruma, ays tipy importa arvum a verevic
): Promise<ERC2612PermitMessage & RSV> {//veradardznum a promis, vortegh klini hetevyal tip dannyx
  const message: ERC2612PermitMessage = {//message
    owner,
    spender,
    value,
    nonce,
    deadline,
  };
//domain separatory interfacum bacatraca verevum
  const domain: Domain = {
    name: "MyToken",
    version: "1",
    chainId: 1337,
    verifyingContract: token,//tokenna mer veryfing contracty
  };

  //typedata 
  const typedData = createTypedERC2612Data(message, domain);

  console.log(typedData);

  //storagrutyun enq steghcum
  const rawSignature = await signer._signTypedData(//eth-i ays funcneneq ugharkum
    typedData.domain,
    typedData.types,
    typedData.message
  );//arden unenq storagrac messagy vor karanq ugharkenq

  //bayc storagrutyuny pti maserov ugharkenq usti split enq anum
  const sig = splitSignatureToRSV(rawSignature); 

  return { ...sig, ...message };//veradardznum enq ayd masery u , ayn message vor storagrel enq
}

describe("MyToken", function() {
  async function deploy() {
    const [ user1, user2 ] = await ethers.getSigners();//owner spender

    const Factory = await ethers.getContractFactory("MyToken");//spasenq factory-in
    const token: MyToken = await Factory.deploy();//deploy eghav

    const PFactory = await ethers.getContractFactory("Proxy");//proxi SC vor ogtagorcum enq demonstarciayi hamar
    const proxy: Proxy = await PFactory.deploy();//es el deploy

    return { token, proxy, user1, user2 }
  }

  it("should permit", async function() {//test enq anum
    const { token, proxy, user1, user2 } = await loadFixture(deploy);

    const tokenAddr = token.address;//veragrum enq vor hesht lini
    const owner = user1.address;
    const spender = user2.address;
    const amount = 15;//poxancelu enq 15 token
    const deadline = Math.floor(Date.now() / 1000) + 1000;//nerka pahi milivarkyannery kloracnum enq u gumarumm enq 1000vrk nerka pahic
    const nonce = 0; //bolor noncery sksum en 0-ic

    //hima piti kanchenq taki func-y(verevum nkragrvac a) poxancelov anhrajesht infon
    const result = await signERC2612Permit(
      tokenAddr,
      owner,
      spender,
      amount,
      deadline,
      nonce,
      user1 //signer inqy pti storagri chnayac karauinq ev metamaskov storagreinq
    );

    console.log(result);// tenanq inch eghav

    //tx enq anum u asum enq vor cherez proxi uzum em user 2-ov kpnem senderov vor inqy gas caxsi, 
    //u vorprszi ed bardacnenq cherez proxi enq ed anum vor cuyc tanq vor stragrac messagy kara ov ases ugharki
    const tx = await proxy.connect(user2).doSend(
      tokenAddr,
      owner,
      spender,
      amount,
      deadline,
      result.v,
      result.r,
      result.s,
    );
    await tx.wait(); //spasum enq lini
//stugenq vor nonce mecacela owneri hamar
    console.log("NONCES", await token.nonces(owner));
//tenum enq vor ownery spenderin irakanaum aloow a arel
    console.log("ALLOWANCE BEFORE", await token.allowance(owner, spender));
//perevod enq anu user2-na anum owneric ir ogtin kvercni 10 token
    const transferTx = await token.connect(user2).transferFrom(owner, spender, 10);
    await transferTx.wait(); //spasecinq eghav
//asuma test user2-i balancy petqa 10 tokenov lini
    await expect(transferTx).to.changeTokenBalance(token, user2, 10);

    console.log("ALLOWANCE AFTER", await token.allowance(owner, spender));
  });
});