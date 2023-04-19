import * as dotenv from 'dotenv';
dotenv.config(); //mer masnavor banalin kardalu hamar

import { Wallet, utils } from "zksync-web3"; //koshelok u utilitner nshvac teghic  
import * as ethers from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { Deployer } from "@matterlabs/hardhat-zksync-deploy"; //vory petqa deploy ani

// npx hardhat deploy-zksync --script deploy --network zkTestnet
export default async function (hre: HardhatRuntimeEnvironment) {//poxancvum a hardhat runtime environment

  const PRIVATE_KEY = process.env.ZKS_PRIVATE_KEY || ""; //asum enq vercru banalin steghic
 
  if (!PRIVATE_KEY) { //ete chka asum enq avelacru
    throw new Error("Please set ZKS_PRIVATE_KEY in the environment variables.");
  }

  const wallet = new Wallet(PRIVATE_KEY); //nor koshelok
//karanq mnemonic el avelacnenq
  const deployer = new Deployer(hre, wallet); //en kashilyoky vory uzum es vori zakrity klyuchi vra unes dostup

  const artifact = await deployer.loadArtifact("DDemo"); //nor dzeva 

  const secret = 42;
//stegh gazi ginna harcnum 
  const deploymentFee = await deployer.estimateDeployFee(artifact, [secret]);
//vor heto goerliic dra krknapatiky vercni im koshelyokic
  const tx = await deployer.zkWallet.deposit({
    to: deployer.zkWallet.address,
    token: utils.ETH_ADDRESS,
    amount: deploymentFee.mul(2) //big number eth6-n -in ancneluc kdarna 
  });

  await tx.wait(); 

  const contract = await deployer.deploy(artifact, [secret]);
  const addr = contract.address;
  console.log(addr);
}//motavorapes senc deploy enq anum