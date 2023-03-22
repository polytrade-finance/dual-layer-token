// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "../INewStandard.sol";

interface INewStandardMetadataURI is INewStandard {
    function uri(uint256 mainId) external view returns (string memory);
}
