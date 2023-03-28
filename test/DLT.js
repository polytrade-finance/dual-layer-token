const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DLT", async function () {
  let DLT;

  let owner;
  let user1;

  beforeEach("Deployments", async function () {
    [owner, user1] = await ethers.getSigners();
    const DLTFactory = await ethers.getContractFactory("DLT");

    DLT = await DLTFactory.deploy("Polytrade DLT", "PLT");

    await DLT.mint(owner.address, ethers.utils.parseEther("10000"));
  });

  describe("Should reflect balances", async function () {
    it("Should increase balances after minting", async function () {
      expect(await DLT.totalSupply()).to.equal(
        ethers.utils.parseEther("10000")
      );

      expect(await DLT.mainTotalSupply(1)).to.equal(
        ethers.utils.parseEther("10000")
      );

      expect(await DLT.subTotalSupply(1, 1)).to.equal(
        ethers.utils.parseEther("10000")
      );

      expect(await DLT.totalMainIds()).to.equal(1);
      expect(await DLT.totalSubIds(1)).to.equal(1);

      expect(await DLT.mainBalanceOf(owner.address, 1)).to.equal(
        ethers.utils.parseEther("10000")
      );

      expect(await DLT.subBalanceOf(owner.address, 1, 1)).to.equal(
        ethers.utils.parseEther("10000")
      );
    });

    it("Should decrease balances after burning", async function () {
      await DLT.burn(owner.address, 1, 1, ethers.utils.parseEther("10000"));

      expect(await DLT.totalSupply()).to.equal(0);

      expect(await DLT.mainTotalSupply(1)).to.equal(0);

      expect(await DLT.subTotalSupply(1, 1)).to.equal(0);

      expect(await DLT.totalMainIds()).to.equal(1);
      expect(await DLT.totalSubIds(1)).to.equal(1);

      expect(await DLT.mainBalanceOf(owner.address, 1)).to.equal(0);

      expect(await DLT.subBalanceOf(owner.address, 1, 1)).to.equal(0);
    });

    it("Should transfer balances after transferFrom", async function () {
      await DLT.approve(user1.address, 1, 1, ethers.utils.parseEther("10000"));

      expect(await DLT.allowance(owner.address, user1.address, 1, 1)).to.equal(
        ethers.utils.parseEther("10000")
      );

      expect(
        await DLT.connect(user1).transferFrom(
          owner.address,
          user1.address,
          1,
          1,
          ethers.utils.parseEther("5000"),
          1 // byte
        )
      )
        .to.emit(DLT, "Transfer")
        .withArgs(
          owner.address,
          user1.address,
          1,
          1,
          ethers.utils.parseEther("5000"),
          1
        );

      expect(await DLT.allowance(owner.address, user1.address, 1, 1)).to.equal(
        ethers.utils.parseEther("5000")
      );

      expect(await DLT.mainBalanceOf(user1.address, 1)).to.equal(
        ethers.utils.parseEther("5000")
      );

      expect(await DLT.subBalanceOf(user1.address, 1, 1)).to.equal(
        ethers.utils.parseEther("5000")
      );

      expect(await DLT.mainBalanceOf(owner.address, 1)).to.equal(
        ethers.utils.parseEther("5000")
      );

      expect(await DLT.subBalanceOf(owner.address, 1, 1)).to.equal(
        ethers.utils.parseEther("5000")
      );
    });

    it("Set Approval for all", async function () {
      expect(await DLT.setApprovalForAll(owner.address, user1.address, true))
        .to.emit(DLT, "ApprovalForAll")
        .withArgs(owner.address, user1.address, true);

      expect(await DLT.isApprovedForAll(owner.address, user1.address));
    });

    it("Should revert on enter wrong arguments", async function () {
      await expect(
        DLT.mint(ethers.constants.AddressZero, ethers.utils.parseEther("10000"))
      ).to.be.revertedWith("DLT: mint to the zero address");

      await expect(
        DLT.burn(
          ethers.constants.AddressZero,
          1,
          1,
          ethers.utils.parseEther("10000")
        )
      ).to.be.revertedWith("DLT: burn from the zero address");

      await expect(
        DLT.burn(owner.address, 1, 1, ethers.utils.parseEther("20000"))
      ).to.be.revertedWith("DLT: insufficient balance");

      await DLT.approve(user1.address, 1, 1, ethers.utils.parseEther("10000"));
      await expect(
        DLT.connect(user1).transferFrom(
          owner.address,
          user1.address,
          1,
          1,
          ethers.utils.parseEther("20000"),
          1 // byte
        )
      ).to.be.revertedWith("DLT: insufficient allowance");

      await DLT.approve(user1.address, 1, 1, ethers.utils.parseEther("20000"));
      await expect(
        DLT.connect(user1).transferFrom(
          owner.address,
          user1.address,
          1,
          1,
          ethers.utils.parseEther("20000"),
          1 // byte
        )
      ).to.be.revertedWith("DLT: insufficient balance for transfer");

      await expect(
        DLT.connect(user1).transferFrom(
          owner.address,
          ethers.constants.AddressZero,
          1,
          1,
          ethers.utils.parseEther("20000"),
          1 // byte
        )
      ).to.be.revertedWith("DLT: transfer to the zero address");

      await expect(
        DLT.connect(owner).setApprovalForAll(owner.address, owner.address, true)
      ).to.be.revertedWith("DLT: approve to caller");

      await expect(
        DLT.connect(owner).approve(
          user1.address,
          1,
          1,
          ethers.constants.MaxInt256
        )
      );

      await expect(
        DLT.connect(owner).approve(
          ethers.constants.AddressZero,
          1,
          1,
          ethers.utils.parseEther("10000")
        )
      ).to.be.revertedWith("DLT: approve to the zero address");
    });
  });
});
