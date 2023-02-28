// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

/**
 * @dev Required interface of the NewStandard compliant contract
 */
interface INewStandard {
    /**
     * @dev Emitted when `value` tokens of token type `subId` of category `mainId`
     * are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 mainId,
        uint256 subId,
        uint256 value
    );

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] mainIds,
        uint256[] subIds,
        uint256[] values
    );

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(
        address indexed account,
        address indexed operator,
        bool approved
    );

    /**
     * @dev Emitted when the URI for token of category `mainId` changes from `oldValue` to `newValue`,
     * if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `mainId`, the standard
     * https://eips.ethereum.org/EIPS/eip-new-standard#metadata-extensions[guarantees]
     * that `newValue` will equal the value
     * returned by {NewStandardMetadataURI-uri}.
     */
    event URI(string oldValue, string newValue, uint256 indexed mainId);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Transfers `amount` tokens of token type `subId` of category `mainId` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `subId` of category `mainId` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {INewStandardReceiver-onNewStandardReceived}
     * and return the acceptance magic value.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes calldata data
    ) external;

    /**
     * @dev xref:ROOT:NewStandard.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `mainIds`, `subIds` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {INewStandardReceiver-onNewStandardBatchReceived}
     * and return the acceptance magic value.
     */
    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata mainIds,
        uint256[] calldata subIds,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;

    /**
     * @dev Returns the amount of tokens of token category `mainId` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOfMain(
        address account,
        uint256 mainId
    ) external view returns (uint256);

    /**
     * @dev Returns the amount of tokens of token type `subId` of category `mainId` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOfSub(
        address account,
        uint256 mainId,
        uint256 subId
    ) external view returns (uint256);

    /**
     * @dev xref:ROOT:NewStandard.adoc#batch-operations[Batched] version of {balanceOfMain}.
     *
     * Requirements:
     *
     * - `accounts` and `mainIds` must have the same length.
     */
    function balanceOfBatchMain(
        address[] calldata accounts,
        uint256[] calldata mainIds
    ) external view returns (uint256[] memory);

    /**
     * @dev xref:ROOT:NewStandard.adoc#batch-operations[Batched] version of {balanceOfSub}.
     *
     * Requirements:
     *
     * - `accounts`, `mainIds` and `subIds` must have the same length.
     */
    function balanceOfBatchSub(
        address[] calldata accounts,
        uint256[] calldata mainIds,
        uint256[] calldata subIds
    ) external view returns (uint256[] memory);

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(
        address account,
        address operator
    ) external view returns (bool);
}
