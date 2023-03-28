// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { DLT } from "./DLT.sol";

contract TestDLT is DLT {
    constructor(string memory name, string memory symbol) DLT(name, symbol) {
        name;
        symbol;
    }

    function mint(address account, uint256 amount) external {
        _mint(account, amount);
    }

    function burn(
        address account,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) external {
        _burn(account, mainId, subId, amount);
    }
}
