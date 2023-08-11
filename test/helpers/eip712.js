const ethSigUtil = require("@metamask/eth-sig-util");
const { expect } = require("chai");
const { ethers } = require("hardhat");

const hexRegex = /[A-Fa-fx]/g;

const toBN = (n) => BigInt(toHex(n, 0));

const toHex = (n, numBytes) => {
  const asHexString =
    typeof n === "bigint"
      ? ethers.toBeHex(n).slice(2)
      : typeof n === "string"
      ? hexRegex.test(n)
        ? n.replace(/0x/, "")
        : Number(n).toString(16)
      : Number(n).toString(16);
  return `0x${asHexString.padStart(numBytes * 2, "0")}`;
};

const calculateDLTPermitHash = (params) => {
  const PermitTypeString =
    "Permit(address owner,address spender,uint256 mainId,uint256 subId,uint256 amount,uint256 nonce,uint256 deadline)";

  const permitTypeHash = ethers.id(PermitTypeString);

  const derivedPermitHash = ethers.keccak256(
    "0x" +
      [
        permitTypeHash.slice(2),
        params.owner.slice(2).padStart(64, "0"),
        params.spender.slice(2).padStart(64, "0"),
        ethers.toBeHex(toBN(params.mainId)).slice(2).padStart(64, "0"),
        ethers.toBeHex(toBN(params.subId)).slice(2).padStart(64, "0"),
        ethers.toBeHex(toBN(params.amount)).slice(2).padStart(64, "0"),
        ethers.toBeHex(toBN(params.nonce)).slice(2).padStart(64, "0"),
        ethers.toBeHex(toBN(params.deadline)).slice(2).padStart(64, "0"),
      ].join("")
  );

  return derivedPermitHash;
};

const validateRecoveredAddress = (
  expectAddress,
  domainSeparator,
  hash,
  signature
) => {
  const digest = ethers.keccak256(
    `0x1901${domainSeparator.slice(2)}${hash.slice(2)}`
  );
  const recoveredAddress = ethers.recoverAddress(digest, signature);
  expect(recoveredAddress).to.be.equal(expectAddress);
};

async function domainSeparatorCal(name, version, chainId, verifyingContract) {
  const EIP712Domain = [
    { name: "name", type: "string" },
    { name: "version", type: "string" },
    { name: "chainId", type: "uint256" },
    { name: "verifyingContract", type: "address" },
  ];
  return (
    "0x" +
    ethSigUtil.TypedDataUtils.hashStruct(
      "EIP712Domain",
      { name, version, chainId, verifyingContract },
      { EIP712Domain },
      "V4"
    ).toString("hex")
  );
}

module.exports = {
  toBN,
  toHex,
  calculateDLTPermitHash,
  validateRecoveredAddress,
  domainSeparatorCal,
};
