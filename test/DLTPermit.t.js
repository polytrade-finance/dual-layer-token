const { expect } = require("chai");
const { ethers } = require("hardhat");
const { splitSignature } = require("ethers/lib/utils");
const { time } = require("@nomicfoundation/hardhat-network-helpers");
const {
  domainSeparatorCal,
  calculateDLTPermitHash,
  validateRecoveredAddress,
} = require("./helpers/eip712");

describe("DLTPermit", async function () {
  let DLT;
  let initialHolder;
  let spender;
  let name;
  let symbol;
  let version;
  let domainSeparator;
  let signature;
  let params;
  let domainData;
  let permitType;

  before("Deployment DLT", async function () {
    [initialHolder, spender] = await ethers.getSigners();

    name = "DLTPermit";
    symbol = "DLTP";
    version = "1.0";
    // ------------------------------------------------------------------
    const DLTFactory = await ethers.getContractFactory("TestDLT");
    DLT = await DLTFactory.deploy(name, symbol, version);

    expect(await DLT.subBalanceOf(initialHolder.address, 1, 1)).to.equal(
      ethers.utils.parseEther("0")
    );

    await DLT.mint(
      initialHolder.address,
      1,
      1,
      ethers.utils.parseEther("10000")
    );
    domainSeparator = await DLT.DOMAIN_SEPARATOR();
    expect(await DLT.subBalanceOf(initialHolder.address, 1, 1)).to.equal(
      ethers.utils.parseEther("10000")
    );
  });

  it("initial nonce is 0", async function () {
    expect(await DLT.nonces(initialHolder.address)).to.be.equal("0");
  });

  it("domain separator", async function () {
    expect(domainSeparator).to.equal(
      await domainSeparatorCal(name, version, 31337, DLT.address)
    );
  });

  describe("permit", function () {
    const mainId = ethers.BigNumber.from("1");
    const subId = ethers.BigNumber.from("1");
    const amount = ethers.BigNumber.from("1000");
    const nonce = ethers.BigNumber.from("0");
    const deadline = ethers.constants.MaxUint256;
    const chainId = 31337;

    it("accepts owner signature", async function () {
      params = {
        owner: initialHolder.address,
        spender: spender.address,
        mainId,
        subId,
        amount,
        nonce,
        deadline,
      };
      domainData = {
        name,
        version,
        chainId,
        verifyingContract: DLT.address,
      };
      permitType = {
        Permit: [
          { name: "owner", type: "address" },
          { name: "spender", type: "address" },
          { name: "mainId", type: "uint256" },
          { name: "subId", type: "uint256" },
          { name: "amount", type: "uint256" },
          { name: "nonce", type: "uint256" },
          { name: "deadline", type: "uint256" },
        ],
      };
      signature = await initialHolder._signTypedData(
        { ...domainData, verifyingContract: DLT.address },
        permitType,
        {
          owner: initialHolder.address,
          spender: spender.address,
          mainId,
          subId,
          amount,
          nonce,
          deadline,
        }
      );

      // Validate Signature Offchain
      const hash = calculateDLTPermitHash(params);
      validateRecoveredAddress(
        initialHolder.address,
        domainSeparator,
        hash,
        signature
      );

      const { r, s, v } = splitSignature(signature);

      await DLT.permit(
        initialHolder.address,
        spender.address,
        mainId,
        subId,
        amount,
        deadline,
        v,
        r,
        s
      );

      expect(await DLT.nonces(initialHolder.address)).to.be.equal("1");
      expect(
        await DLT.allowance(initialHolder.address, spender.address, 1, 1)
      ).to.be.equal(amount);
    });

    it("rejects reused signature", async function () {
      const { r, s, v } = splitSignature(signature);

      await expect(
        DLT.permit(
          initialHolder.address,
          spender.address,
          mainId,
          subId,
          amount,
          deadline,
          v,
          r,
          s
        )
      ).to.be.revertedWithCustomError(DLT, "InvalidSignature");
    });

    it("rejects other signature", async function () {
      signature = await spender._signTypedData(
        { ...domainData, verifyingContract: DLT.address },
        permitType,
        {
          owner: initialHolder.address,
          spender: spender.address,
          mainId,
          subId,
          amount,
          nonce,
          deadline,
        }
      );

      const { r, s, v } = splitSignature(signature);

      await expect(
        DLT.permit(
          initialHolder.address,
          spender.address,
          mainId,
          subId,
          amount,
          deadline,
          v,
          r,
          s
        )
      ).to.be.revertedWithCustomError(DLT, "InvalidSignature");
    });

    it("rejects expired permit", async function () {
      const expiredDeadline = (await time.latest()) - 100;

      signature = await spender._signTypedData(
        { ...domainData, verifyingContract: DLT.address },
        permitType,
        {
          owner: initialHolder.address,
          spender: spender.address,
          mainId,
          subId,
          amount,
          nonce,
          deadline: expiredDeadline,
        }
      );

      const { r, s, v } = splitSignature(signature);

      await expect(
        DLT.permit(
          initialHolder.address,
          spender.address,
          mainId,
          subId,
          amount,
          expiredDeadline,
          v,
          r,
          s
        )
      ).to.be.revertedWithCustomError(DLT, "ExpiredSignature");
    });
  });
});
