// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IDLT {
    /**
     * @dev Emitted when `subId` token is transferred from `sender` to `recipient`.
     */
    event Transfer(
        address indexed sender,
        address indexed recipient,
        uint256 indexed mainId,
        uint256 subId,
        uint256 amount
    );

    /**
        The `spender` argument of an account/contract that is approved to make the transfer (SHOULD be msg.sender).
        The `sender` argument of the holder whose balance is decreased.
        The `recipient` argument of the recipient whose balance is increased.
        The `mainIds` argument MUST be the list of mainIds being transferred.
        The `subIds` argument MUST be the list of subIds being transferred.
        The `amounts` argument MUST be the list of number of tokens
        When minting/creating tokens, the `sender` argument MUST be set to `0x0`.
        When burning/destroying tokens, the `recipient` argument MUST be set to `0x0`.                
    */
    event TransferBatch(
        address indexed spender,
        address indexed sender,
        address indexed recipient,
        uint256[] mainIds,
        uint256[] subIds,
        uint256[] amounts
    );

    /**
     * @dev Emitted when `owner` enables `spender` to manage the `subId` token.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 mainId,
        uint256 subId,
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
    function safeTransferFrom(
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
    ) external returns (bool);

    /**
     * @dev Returns the amount of whole tokens.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns The total supply of all tokens of a given mainId.
     */
    function mainTotalSupply(uint256 mainId) external view returns (uint256);

    /**
     * @dev Returns The total supply of tokens with a given mainId and subId
     */
    function subTotalSupply(
        uint256 mainId,
        uint256 subId
    ) external view returns (uint256);

    /**
     * @dev Returns Total number of unique mainId value.
     */
    function totalMainIds() external view returns (uint256);

    /**
     * @dev Returns Total number of unique subId values that have been  given for a mainId.
     */
    function totalSubIds(uint256 mainId) external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account` in subId.
     */
    function subBalanceOf(
        address account,
        uint256 mainId,
        uint256 subId
    ) external view returns (uint256);

    /**
     *
     * Requirements:
     *
     * - `accounts` and `mainIds` and `subIds` must have the same length.
     */
    function balanceOfBatch(
        address[] memory accounts,
        uint256[] memory mainIds,
        uint256[] memory subIds
    ) external view returns (uint256[] memory);

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
