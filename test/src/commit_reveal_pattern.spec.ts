import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect, use } from "chai";
import { Contract, BigNumber, Signer } from "ethers";
import { parseEther } from "ethers/lib/utils";
import hre, { ethers } from "hardhat";


describe.only("Commit Reveal Pattern", function () {

  let signers: Signer[];

  let demo: Contract;
  let user: any;
  let owner: any;
  let user2: any;
  let user3: any;

  before(async () => {
    [owner, user, user2, user3] = await ethers.getSigners();

    hre.tracer.nameTags[await owner.address] = "ADMIN";
    hre.tracer.nameTags[await user.address] = "USER1";

    const CommitReveal = await ethers.getContractFactory("CommitReveal", owner);
    demo = await CommitReveal.deploy();

    hre.tracer.nameTags[demo.address] = "Payment-TOKEN";
  });

  it("Commit Ether", async function () {
    console.log(demo.functions)
  })

})