// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

/**
 * @title DLT token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from DLT asset contracts.
 */
interface IDLTReceiver {
    /**
     * @dev Whenever an {DLT} `subId` token is transferred to this contract via {IDLT-safeTransferFrom}
     * by `operator` from `sender`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient,
     *  the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IDLTReceiver.onDLTReceived.selector`.
     */
    function onDLTReceived(
        address operator,
        address from,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes calldata data
    ) external returns (bytes4);

    function onDLTBatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        uint256[] memory,
        bytes calldata data
    ) external returns (bytes4);
}
