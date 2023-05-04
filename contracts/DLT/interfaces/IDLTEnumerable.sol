// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IDLT.sol";

/**
 * @title DLT Standard, optional enumeration extension
 */
interface IDLTEnumerable is IDLT {
    /**
     * @dev Returns the total number of main ids.
     */
    function totalMainIds() external view returns (uint256);

    /**
     * @dev Returns the total number of sub ids for each main Ids.
     */
    function totalSubIds(uint256 mainId) external view returns (uint256);

    /**
     * @dev Returns the total supply of main ids.
     */
    function mainTotalSupply(uint256 mainId) external view returns (uint256);

    /**
     * @dev Returns the total supply of sub ids for each main Ids.
     */
    function subTotalSupply(
        uint256 mainId,
        uint256 subId
    ) external view returns (uint256);

    /**
     * @dev Returns the array of all owner sub ids.
     */
    function ownedSubIds(
        uint256 mainId,
        address owner
    ) external view returns (uint256[] memory);

    /**
     * @dev Returns the array of all owner sub ids.
     */
    function ownedSubIdBalance(
        uint256 mainId,
        address owner
    ) external view returns (uint256);
}
