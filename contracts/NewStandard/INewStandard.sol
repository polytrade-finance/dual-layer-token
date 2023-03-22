// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface INewStandard is IERC165 {
    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 mainId,
        uint256 subId,
        uint256 value
    );

    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] mainIds,
        uint256[] subIds,
        uint256[] values
    );

    event ApprovalForAll(
        address indexed account,
        address indexed operator,
        bool approved
    );

    event URI(string oldValue, string newValue, uint256 indexed mainId);

    function setApprovalForAll(address operator, bool approved) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes calldata data
    ) external;

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata mainIds,
        uint256[] calldata subIds,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;

    function balanceOfMain(
        address account,
        uint256 mainId
    ) external view returns (uint256);

    function balanceOfSub(
        address account,
        uint256 mainId,
        uint256 subId
    ) external view returns (uint256);

    function balanceOfBatchMain(
        address[] calldata accounts,
        uint256[] calldata mainIds
    ) external view returns (uint256[] memory);

    function balanceOfBatchSub(
        address[] calldata accounts,
        uint256[] calldata mainIds,
        uint256[] calldata subIds
    ) external view returns (uint256[] memory);

    function isApprovedForAll(
        address account,
        address operator
    ) external view returns (bool);
}
