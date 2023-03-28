// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import { DLT } from "../DLT/DLT.sol";
import { IInvoice } from "./interface/IInvoice.sol";

contract Invoice is IInvoice, DLT {
    /**
     * @dev Mapping will be indexing the metadata for each AssetNFT by its Asset Number
     */
    mapping(uint256 => Metadata) private _metadata;

    constructor(string memory name, string memory symbol) DLT(name, symbol) {}
}
