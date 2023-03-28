const { ethers } = require("hardhat");

const invoice1 = {
  factoringFee: 10,
  discountFee: 10,
  lateFee: 10,
  bankChargesFee: 10,
  additionalFee: 10,
  gracePeriod: 10,
  advanceFee: 10,
  dueDate: new Date("2022-11-12").getTime() / 1000,
  invoiceDate: new Date("2022-10-10").getTime() / 1000,
  fundsAdvancedDate: new Date("2022-10-13").getTime() / 1000,
  invoiceAmount: ethers.utils.parseEther("10000"),
};

module.exports = {
  invoice1,
};
