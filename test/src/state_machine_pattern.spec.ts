import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect, use } from "chai";
import { Contract, BigNumber, Signer } from "ethers";
import { parseEther } from "ethers/lib/utils";
import hre, { ethers } from "hardhat";


describe("State Machine Pattern", function () {

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

    const DepositLock = await ethers.getContractFactory("DepositLock", owner);
    demo = await DepositLock.deploy();

    hre.tracer.nameTags[demo.address] = "Payment-TOKEN";
  });

  it("Bid Ether", async function () {
    await demo.deposit(({ value: parseEther("2") }))
    await demo.nextStage()
    await expect(demo.deposit(({ value: parseEther("2") }))).to.be.reverted
    await demo.nextStage()
    await demo.withdraw()
  })

})