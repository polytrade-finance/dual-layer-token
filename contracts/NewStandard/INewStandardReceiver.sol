// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface INewStandardReceiver is IERC165 {
    function onNewStandardReceived(
        address operator,
        address from,
        uint256 mainId,
        uint256 subId,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    function onNewStandardBatchReceived(
        address operator,
        address from,
        uint256[] calldata mainIds,
        uint256[] calldata subIds,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}
