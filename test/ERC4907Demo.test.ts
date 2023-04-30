import { loadFixture, ethers, expect, time } from "./setup";
import { ERC4907Demo } from "../typechain-types";

describe("ERC4907", function() {
  async function deploy() {
    const [ user1, user2 ] = await ethers.getSigners();
//inchpes misht factori enq patrastel
    const Factory = await ethers.getContractFactory("ERC4907Demo");
    const nft: ERC4907Demo = await Factory.deploy("MyToken", "MTK");

    return { nft, user1, user2 }//user1 terna, user2 arendatory
  }

  it("should work", async function() {
    const { nft, user1, user2 } = await loadFixture(deploy);

    const tokenId = 1; //arajin NFT
    const u1_addr = user1.address;//harmar linelu hamar
    const u2_addr = user2.address;

    await nft.mint(tokenId, u1_addr); //obarot enq mtcnum ownery user 1 -na

    //expires enq sarqum okrugleni mili 
    //asum enq kloracru vercnum enq yntacik data vremeni, heto vercnum em metkan getTime-ov(milivarkyanov)
    //dra ahamar bajanum em 1000-i+800varkyannel expiri hamar
    const expires = Math.floor(new Date().getTime() / 1000) + 800;

    //user enq dnum arandatorin user2
    await nft.setUser(tokenId, u2_addr, expires);

    //stugummenq vro NFT userof da user2 hascena
    expect(await nft.userOf(tokenId)).to.eq(u2_addr);
    
    //isk ow
    expect(await nft.ownerOf(tokenId)).to.eq(u1_addr);

    //hardhati helpern enq ogtagorcum avelacnu enq jamanaky
    await time.increase(1200);

    //vor expire ancni stugenq arden usery zroyakan hascena
    expect(await nft.userOf(tokenId)).to.eq(
      //dra hamar ogtagorcum enq ethersi constanty vory zroyakan a
      ethers.constants.AddressZero
    );
  });
});
