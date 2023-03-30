const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DLT", async function () {
  let DLT;
  let DLTReceiver;
  let DLTNonReceiver;
  let DLTReceiverRevertable;
  let owner;
  let user1;

  before("Static Deployments", async function () {
    [owner, user1] = await ethers.getSigners();

    // ------------------------------------------------------------------
    const DLTReceiverFactory = await ethers.getContractFactory("DLTReceiver");
    DLTReceiver = await DLTReceiverFactory.deploy();

    // ------------------------------------------------------------------
    const DLTNonReceiverFactory = await ethers.getContractFactory(
      "DLTNonReceiver"
    );
    DLTNonReceiver = await DLTNonReceiverFactory.deploy();

    // ------------------------------------------------------------------
    const DLTReceiverRevertableFactory = await ethers.getContractFactory(
      "DLTReceiverRevertable"
    );
    DLTReceiverRevertable = await DLTReceiverRevertableFactory.deploy();
    // ------------------------------------------------------------------
  });

  beforeEach("Restart Deployment DLT at each test use case", async function () {
    // ------------------------------------------------------------------
    const DLTFactory = await ethers.getContractFactory("TestDLT");
    DLT = await DLTFactory.deploy("Polytrade DLT", "PLT");

    expect(await DLT.subBalanceOf(owner.address, 1, 1)).to.equal(
      ethers.utils.parseEther("0")
    );

    await DLT.mint(owner.address, 1, 1, ethers.utils.parseEther("10000"));

    expect(await DLT.subBalanceOf(owner.address, 1, 1)).to.equal(
      ethers.utils.parseEther("10000")
    );
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

    it("Should decrease balances after burning all balances", async function () {
      await DLT.burn(owner.address, 1, 1, ethers.utils.parseEther("10000"));

      expect(await DLT.totalSupply()).to.equal(0);

      expect(await DLT.mainTotalSupply(1)).to.equal(0);

      expect(await DLT.subTotalSupply(1, 1)).to.equal(0);

      expect(await DLT.totalMainIds()).to.equal(0);
      expect(await DLT.totalSubIds(1)).to.equal(0);

      expect(await DLT.mainBalanceOf(owner.address, 1)).to.equal(0);

      expect(await DLT.subBalanceOf(owner.address, 1, 1)).to.equal(0);
    });

    it("Should decrease balances after burning half of balances", async function () {
      await DLT.burn(owner.address, 1, 1, ethers.utils.parseEther("5000"));

      expect(await DLT.totalSupply()).to.equal(ethers.utils.parseEther("5000"));

      expect(await DLT.mainTotalSupply(1)).to.equal(
        ethers.utils.parseEther("5000")
      );

      expect(await DLT.subTotalSupply(1, 1)).to.equal(
        ethers.utils.parseEther("5000")
      );

      expect(await DLT.totalMainIds()).to.equal(1);
      expect(await DLT.totalSubIds(1)).to.equal(1);

      expect(await DLT.mainBalanceOf(owner.address, 1)).to.equal(
        ethers.utils.parseEther("5000")
      );

      expect(await DLT.subBalanceOf(owner.address, 1, 1)).to.equal(
        ethers.utils.parseEther("5000")
      );
    });

    it("Should transfer balances after safeTransferFrom and transferFrom", async function () {
      await DLT.approve(user1.address, 1, 1, ethers.utils.parseEther("10000"));

      expect(await DLT.allowance(owner.address, user1.address, 1, 1)).to.equal(
        ethers.utils.parseEther("10000")
      );

      expect(
        await DLT.connect(user1).safeTransferFrom(
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

      await expect(
        DLT.connect(user1).transferFrom(
          owner.address,
          user1.address,
          1,
          1,
          ethers.utils.parseEther("1000")
        )
      ).to.not.reverted;

      expect(await DLT.allowance(owner.address, user1.address, 1, 1)).to.equal(
        ethers.utils.parseEther("4000")
      );

      expect(await DLT.mainBalanceOf(user1.address, 1)).to.equal(
        ethers.utils.parseEther("6000")
      );

      expect(await DLT.subBalanceOf(user1.address, 1, 1)).to.equal(
        ethers.utils.parseEther("6000")
      );

      expect(await DLT.mainBalanceOf(owner.address, 1)).to.equal(
        ethers.utils.parseEther("4000")
      );

      expect(await DLT.subBalanceOf(owner.address, 1, 1)).to.equal(
        ethers.utils.parseEther("4000")
      );
    });

    it("Set Approval for all", async function () {
      expect(await DLT.setApprovalForAll(owner.address, user1.address, true))
        .to.emit(DLT, "ApprovalForAll")
        .withArgs(owner.address, user1.address, true);

      expect(await DLT.isApprovedForAll(owner.address, user1.address));
    });

    it("Should revert to mint for address zero", async function () {
      await expect(
        DLT.mint(
          ethers.constants.AddressZero,
          1,
          1,
          ethers.utils.parseEther("10000")
        )
      ).to.be.revertedWith("DLT: mint to the zero address");
    });

    it("Should revert to mint zero amount", async function () {
      await expect(DLT.mint(owner.address, 1, 1, 0)).to.be.revertedWith(
        "DLT: mint zero amount"
      );
    });

    it("Should revert transfer from zero address", async function () {
      await expect(
        DLT.transfer(
          ethers.constants.AddressZero,
          owner.address,
          1,
          1,
          ethers.utils.parseEther("10000")
        )
      ).to.be.revertedWith("DLT: transfer from the zero address");
    });

    it("Should revert to burn for address zero", async function () {
      await expect(
        DLT.burn(
          ethers.constants.AddressZero,
          1,
          1,
          ethers.utils.parseEther("10000")
        )
      ).to.be.revertedWith("DLT: burn from the zero address");
    });

    it("Should revert to burn amount greater than the current balance", async function () {
      await expect(
        DLT.burn(owner.address, 1, 1, ethers.utils.parseEther("20000"))
      ).to.be.revertedWith("DLT: insufficient balance");
    });

    it("Should revert to burn 0 amount", async function () {
      await expect(DLT.burn(owner.address, 1, 1, 0)).to.be.revertedWith(
        "DLT: burn zero amount"
      );
    });

    it("Should revert safeTransferFrom on amount greater than owner's balance", async function () {
      await DLT.approve(user1.address, 1, 1, ethers.utils.parseEther("20000"));
      await expect(
        DLT.connect(user1).safeTransferFrom(
          owner.address,
          user1.address,
          1,
          1,
          ethers.utils.parseEther("20000"),
          1 // byte
        )
      ).to.be.revertedWith("DLT: insufficient balance for transfer");
    });

    it("Should revert transferFrom on amount greater than owner's balance", async function () {
      await DLT.approve(user1.address, 1, 1, ethers.utils.parseEther("20000"));
      await expect(
        DLT.connect(user1).transferFrom(
          owner.address,
          user1.address,
          1,
          1,
          ethers.utils.parseEther("20000")
        )
      ).to.be.revertedWith("DLT: insufficient balance for transfer");
    });

    it("Should revert safeTransferFrom to address zero", async function () {
      await DLT.approve(user1.address, 1, 1, ethers.utils.parseEther("20000"));

      await expect(
        DLT.connect(user1).safeTransferFrom(
          owner.address,
          ethers.constants.AddressZero,
          1,
          1,
          ethers.utils.parseEther("20000"),
          1 // byte
        )
      ).to.be.revertedWith("DLT: transfer to the zero address");
    });

    it("Should revert transferFrom to address zero", async function () {
      await DLT.approve(user1.address, 1, 1, ethers.utils.parseEther("20000"));

      await expect(
        DLT.connect(user1).transferFrom(
          owner.address,
          ethers.constants.AddressZero,
          1,
          1,
          ethers.utils.parseEther("20000")
        )
      ).to.be.revertedWith("DLT: transfer to the zero address");
    });

    it("Should revert insufficient allowance methods", async function () {
      await DLT.approve(user1.address, 1, 1, ethers.utils.parseEther("10000"));
      await expect(
        DLT.connect(user1).safeTransferFrom(
          owner.address,
          user1.address,
          1,
          1,
          ethers.utils.parseEther("20000"),
          1 // byte
        )
      ).to.be.revertedWith("DLT: insufficient allowance");
    });

    it("Should revert setApprovalForAll to the caller", async function () {
      await expect(
        DLT.connect(owner).setApprovalForAll(owner.address, owner.address, true)
      ).to.be.revertedWith("DLT: approve to caller");
    });

    it("Should approve MaxInt256", async function () {
      expect(
        await DLT.connect(owner).approve(
          user1.address,
          1,
          1,
          ethers.constants.MaxInt256
        )
      );
    });

    it("Should revert on approve for address zero", async function () {
      await expect(
        DLT.connect(owner).approve(
          ethers.constants.AddressZero,
          1,
          1,
          ethers.utils.parseEther("10000")
        )
      ).to.be.revertedWith("DLT: approve to the zero address");
    });

    it("Should revert on approval greater than the balance", async function () {
      expect(
        await DLT.connect(owner).approve(
          user1.address,
          1,
          1,
          ethers.constants.MaxUint256
        )
      );

      await expect(
        DLT.connect(user1).safeTransferFrom(
          owner.address,
          user1.address,
          1,
          1,
          ethers.utils.parseEther("20000"),
          1 // byte
        )
      ).to.be.revertedWith("DLT: insufficient balance for transfer");
    });

    it("should revert approve from zero address", async function () {
      await expect(
        DLT.allow(
          ethers.constants.AddressZero,
          owner.address,
          1,
          1,
          ethers.utils.parseEther("10000")
        )
      ).to.be.revertedWith("DLT: approve from the zero address");
    });

    it("Should not revert on transfer to DLTReceiver implementer", async function () {
      await DLT.approve(user1.address, 1, 1, ethers.utils.parseEther("10000"));
      await expect(
        DLT.connect(user1).safeTransferFrom(
          owner.address,
          DLTReceiver.address,
          1,
          1,
          ethers.utils.parseEther("5000"),
          1 // byte
        )
      ).to.not.be.reverted;
    });

    it("Should revert on transfer to DLTNonReceiver implementer", async function () {
      await DLT.approve(user1.address, 1, 1, ethers.utils.parseEther("10000"));
      await expect(
        DLT.connect(user1).safeTransferFrom(
          owner.address,
          DLTNonReceiver.address,
          1,
          1,
          ethers.utils.parseEther("5000"),
          1 // byte
        )
      ).to.be.revertedWith("DLT: transfer to non DLTReceiver implementer");
    });

    it("Should not revert on mint to DLTReceiver implementer", async function () {
      await expect(
        DLT.mint(DLTReceiver.address, 1, 1, ethers.utils.parseEther("5000"))
      ).to.not.be.reverted;
    });

    it("Should revert on mint to DLTNonReceiver implementer", async function () {
      await expect(
        DLT.mint(DLTNonReceiver.address, 1, 1, ethers.utils.parseEther("5000"))
      ).to.be.revertedWith("DLT: transfer to non DLTReceiver implementer");
    });

    it("Should revert on mint to DLTReceiverRevertable implementer", async function () {
      await expect(
        DLT.mint(
          DLTReceiverRevertable.address,
          1,
          1,
          ethers.utils.parseEther("5000")
        )
      ).to.be.revertedWith("DLTReceiverRevertable");
    });
  });
});
