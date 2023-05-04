// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { IDLTReceiver } from "../interfaces/IDLTReceiver.sol";

contract DLTReceiverRevertable is IDLTReceiver {
    constructor() {}

    function onDLTReceived(
        address operator,
        address from,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes calldata data
    ) external returns (bytes4) {
        revert("DLTReceiverRevertable");
    }
}
