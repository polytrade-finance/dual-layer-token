// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IDLTUpgradeable.sol";

/**
 * @title DLT Standard, optional enumeration extension
 */
interface IDLTEnumerableUpgradeable is IDLTUpgradeable {
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
    function totalMainSupply(uint256 mainId) external view returns (uint256);

    /**
     * @dev Returns the total supply of sub ids for each main Ids.
     */
    function totalSubSupply(
        uint256 mainId,
        uint256 subId
    ) external view returns (uint256);

    /**
     * @dev Returns array of all sub ids for a main id
     */
    function getSubIds(uint256 mainId) external view returns (uint256[] memory);

    /**
     * @dev Returns total sub id balance of owner for each main id
     */
    function subIdBalanceOf(
        address owner,
        uint256 mainId
    ) external view returns (uint256);
}
