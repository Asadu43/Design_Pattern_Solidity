import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect, use } from "chai";
import { Contract, BigNumber, Signer } from "ethers";
import { parseEther } from "ethers/lib/utils";
import hre, { ethers } from "hardhat";


describe("Pull Payment Token", function () {

  let signers: Signer[];

  let demo: Contract;
  let user: any;
  let owner: any;
  let user2:any;
  let user3: any;

  before(async () => {
    [owner, user, user2, user3] = await ethers.getSigners();

    hre.tracer.nameTags[await owner.address] = "ADMIN";
    hre.tracer.nameTags[await user.address] = "USER1";

    const Auction = await ethers.getContractFactory("Auction", owner);
    demo = await Auction.deploy();

    hre.tracer.nameTags[demo.address] = "Payment-TOKEN";
  });

  it("Bid Ether", async function () {
    console.log(demo.functions)
    await demo.connect(user).bid(({value:parseEther("1")}))
    await expect( demo.connect(user2).bid(({value:parseEther("1")}))).to.be.revertedWith("More Ether Require")
    await demo.connect(user2).bid(({value:parseEther("1.3")}))
  })

  it("Withdraw Ether", async function () {
   await expect( demo.connect(owner).withdrawRefund()).to.be.revertedWith("Don't Have Ether")
    await demo.connect(user).withdrawRefund()
  })
})