// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "./NewStandardReceiver.sol";

contract NewStandardHolder is NewStandardReceiver {
    function onNewStandardReceived(
        address,
        address,
        uint256,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onNewStandardReceived.selector;
    }

    function onNewStandardBatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onNewStandardBatchReceived.selector;
    }
}
