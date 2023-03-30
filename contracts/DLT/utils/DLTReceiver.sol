// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { IDLTReceiver } from "../interface/IDLTReceiver.sol";

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
