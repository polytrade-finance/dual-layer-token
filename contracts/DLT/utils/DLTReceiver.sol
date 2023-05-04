// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { IDLTReceiver } from "../interfaces/IDLTReceiver.sol";

contract DLTReceiver is IDLTReceiver {
    function onDLTReceived(
        address operator,
        address from,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes calldata data
    ) external returns (bytes4) {
        return IDLTReceiver.onDLTReceived.selector;
    }

    function onDLTBatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        uint256[] memory,
        bytes calldata data
    ) external returns (bytes4) {
        return IDLTReceiver.onDLTBatchReceived.selector;
    }
}
