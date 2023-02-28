import { ethers } from "hardhat";
import { utils } from "ethers";

function n18(amount: string) {
  return utils.parseUnits(amount, "ether");
}

async function increaseTime(duration: number) {
  await ethers.provider.send("evm_increaseTime", [duration]);
  await ethers.provider.send("evm_mine", []);
}

module.exports = {
  n18,
  increaseTime,
};
