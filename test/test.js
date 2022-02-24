const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Arnen = await ethers.getContractFactory("Arnen");
    const arnen = await Arnen.deploy("");
    await arnen.deployed();

    expect(await arnen.saleIsActive()).to.equal(false);

    const openNftSale = await arnen.openNFTSale();

    // wait until the transaction is mined
    await openNftSale.wait();

    expect(await arnen.saleIsActive()).to.equal(true);
  });
});
