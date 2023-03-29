// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { DLT } from "./DLT.sol";
import { IDLTReceiver } from "./interface/IDLTReceiver.sol";

contract TestDLT is DLT {
    constructor(string memory name, string memory symbol) DLT(name, symbol) {
        name;
        symbol;
    }

    function mint(
        address account,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) external {
        _safeMint(account, mainId, subId, amount);
    }

    function burn(
        address account,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) external {
        _burn(account, mainId, subId, amount);
    }

    function transfer(
        address sender,
        address recipient,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) external {
        _transfer(sender, recipient, mainId, subId, amount);
    }

    function allow(
        address sender,
        address recipient,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) external {
        _approve(sender, recipient, mainId, subId, amount);
    }
}

contract DLTReceiver is IDLTReceiver {
    function onDLTReceived(
        address operator,
        address from,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes calldata data
    ) external returns (bytes4) {
        operator;
        from;
        mainId;
        subId;
        amount;
        data;
        return IDLTReceiver.onDLTReceived.selector;
    }
}

contract DLTNonReceiver {
    constructor() {
        block.timestamp;
    }
}

contract DLTReceiverRevertable is IDLTReceiver {
    constructor() {
        block.timestamp;
    }

    function onDLTReceived(
        address operator,
        address from,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes calldata data
    ) external returns (bytes4) {
        operator;
        from;
        mainId;
        subId;
        amount;
        data;

        revert("DLTReceiverRevertable");
    }
}
