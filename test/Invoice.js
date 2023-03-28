const { expect } = require("chai");
const { ethers } = require("hardhat");
const { invoice1 } = require("./data");

describe("Invoice", async function () {
  let InvoiceNFT;

  let owner;

  beforeEach("Deployments", async function () {
    [owner] = await ethers.getSigners();
    const DLTFactory = await ethers.getContractFactory("InvoiceNFT");

    InvoiceNFT = await DLTFactory.deploy(
      "Polytrade DLT",
      "PLT",
      "https://ipfs.io/ipfs"
    );

    await InvoiceNFT.createInvoice(owner.address, "/token1", invoice1);
  });

  describe("Should reflect balances", async function () {
    it("Should increase balances after creating invoice", async function () {
      const totalMainIds = InvoiceNFT.totalMainIds();

      expect(await InvoiceNFT.totalSupply()).to.equal(
        ethers.utils.parseEther("10000")
      );

      expect(await InvoiceNFT.mainTotalSupply(totalMainIds)).to.equal(
        ethers.utils.parseEther("10000")
      );

      expect(await InvoiceNFT.subTotalSupply(totalMainIds, 1)).to.equal(
        ethers.utils.parseEther("10000")
      );

      expect(await InvoiceNFT.totalMainIds()).to.equal(1);
      expect(await InvoiceNFT.totalSubIds(totalMainIds)).to.equal(1);

      expect(
        await InvoiceNFT.mainBalanceOf(owner.address, totalMainIds)
      ).to.equal(ethers.utils.parseEther("10000"));

      expect(
        await InvoiceNFT.subBalanceOf(owner.address, totalMainIds, 1)
      ).to.equal(ethers.utils.parseEther("10000"));
    });

    it("Check Invoice Properties", async function () {
      expect(await InvoiceNFT.tokenURI(1)).to.equal(
        "https://ipfs.io/ipfs/token1"
      );

      const metadata = await InvoiceNFT.getInvoice(1);

      expect(metadata.initialMetadata.factoringFee).to.equal(10);
      expect(metadata.initialMetadata.discountFee).to.equal(10);
      expect(metadata.initialMetadata.lateFee).to.equal(10);
      expect(metadata.initialMetadata.bankChargesFee).to.equal(10);
      expect(metadata.initialMetadata.additionalFee).to.equal(10);
      expect(metadata.initialMetadata.gracePeriod).to.equal(10);
      expect(metadata.initialMetadata.advanceFee).to.equal(10);
      expect(metadata.initialMetadata.dueDate).to.equal(
        new Date("2022-11-12").getTime() / 1000
      );
      expect(metadata.initialMetadata.invoiceDate).to.equal(
        new Date("2022-10-10").getTime() / 1000
      );
      expect(metadata.initialMetadata.fundsAdvancedDate).to.equal(
        new Date("2022-10-13").getTime() / 1000
      );
      expect(metadata.initialMetadata.invoiceAmount).to.equal(
        ethers.utils.parseEther("10000")
      );
    });
  });
});
