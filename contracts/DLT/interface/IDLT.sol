// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IDLT is IERC165 {
    /**
     * @dev Emitted when `subId` token is transferred from `sender` to `recipient`.
     */
    event Transfer(
        address indexed sender,
        address indexed recipient,
        uint256 indexed mainId,
        uint256 subId,
        uint256 amount,
        bytes data
    );

    /**
     * @dev Emitted when `spender` enables `spender` to manage the `subId` token.
     */
    event Approval(
        address indexed spender,
        uint256 indexed mainId,
        uint256 indexed subId,
        uint256 amount
    );

    /**
     * @dev Emitted when `spender` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(
        address indexed spender,
        address indexed operator,
        bool approved
    );

    event URI(string oldValue, string newValue, uint256 indexed mainId);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any subId owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes calldata data
    ) external returns (bool);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits an {Approval} event.
     */
    function approve(
        address spender,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) external;

    /**
     * @dev Returns the amount of tokens in existed subId.
     */
    function totalSupply(
        uint256 mainId,
        uint256 subId
    ) external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account` in subId.
     */
    function balanceOf(
        address account,
        uint256 mainId,
        uint256 subId
    ) external view returns (uint256);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(
        address owner,
        address spender,
        uint256 mainId,
        uint256 subId
    ) external view returns (uint256);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool);
}
