// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../DLTUpgradeable.sol";
import "../interfaces/IDLTEnumerableUpgradeable.sol";

/*
 * @dev This implements an optional extension of {DLT} defined in the EIP 6960 that adds
 * enumerability of all the main ids and sub ids in the contract as well as total supply by each main ids and sub ids.
 */
abstract contract DLTEnumerableUpgradeable is
    DLTUpgradeable,
    IDLTEnumerableUpgradeable
{
    uint256 private _totalMainIds;

    /**
     * @dev Mapping total sub ids for each main ids
     */
    mapping(uint256 => uint256) private _totalSubIds;

    /**
     * @dev Mapping from mainId to total supply of main ids
     */
    mapping(uint256 => uint256) private _totalMainSupply;

    /**
     * @dev Mapping from mainId to sub id to total supply of sub ids
     */
    mapping(uint256 => mapping(uint256 => uint256)) private _totalSubSupply;

    /**
     * @dev Mapping from main ids to array of sub ids
     */
    mapping(uint256 => uint256[]) private _subIds;

    /**
     * @dev Mapping from subId to position in the _subIds array
     */
    mapping(uint256 => mapping(uint256 => uint256)) private _subIdIndex;

    /**
     * @dev See {IDLTEnumerable-totalMainIds}.
     */
    function totalMainIds() public view virtual override returns (uint256) {
        return _totalMainIds;
    }

    /**
     * @dev See {IDLTEnumerable-totalSubIds}.
     */
    function totalSubIds(uint256 mainId) public view virtual returns (uint256) {
        return _totalSubIds[mainId];
    }

    /**
     * @dev See {IDLTEnumerable-totalMainSupply}.
     */
    function totalMainSupply(
        uint256 mainId
    ) public view virtual returns (uint256) {
        return _totalMainSupply[mainId];
    }

    /**
     * @dev See {IDLTEnumerable-totalSubSupply}.
     */
    function totalSubSupply(
        uint256 mainId,
        uint256 subId
    ) public view virtual returns (uint256) {
        return _totalSubSupply[mainId][subId];
    }

    /**
     * @dev See {IDLTEnumerable-getSubIds}.
     */
    function getSubIds(
        uint256 mainId
    ) public view virtual returns (uint256[] memory) {
        return _subIds[mainId];
    }

    /**
     * @dev See {IDLTEnumerable-subIdBalanceOf}.
     */
    function subIdBalanceOf(
        address owner,
        uint256 mainId
    ) public view virtual returns (uint256 totalBalance) {
        for (uint256 i = 0; i < _subIds[mainId].length; ) {
            uint256 subId = _subIds[mainId][i];
            totalBalance += _balances[mainId][owner][subId];
            unchecked {
                ++i;
            }
        }
        return totalBalance;
    }

    /**
     * @dev See {DLT-_mint}.
     * @dev Private function that updates total supply and amount of each ids after minting
     */
    function _mint(
        address recipient,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) internal virtual override(DLTUpgradeable) {
        if (_totalMainSupply[mainId] == 0) {
            ++_totalMainIds;
        }
        if (_totalSubSupply[mainId][subId] == 0) {
            ++_totalSubIds[mainId];
            uint256[] storage array = _subIds[mainId];
            _subIdIndex[mainId][subId] = array.length;
            array.push(subId);
        }
        _totalMainSupply[mainId] += amount;
        _totalSubSupply[mainId][subId] += amount;
        super._mint(recipient, mainId, subId, amount);
    }

    /**
     * @dev See {DLT-_burn}.
     * @dev Private function that updates total supply and amount of each ids after burning
     */
    function _burn(
        address recipient,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) internal virtual override(DLTUpgradeable) {
        super._burn(recipient, mainId, subId, amount);
        unchecked {
            _totalMainSupply[mainId] -= amount;
            _totalSubSupply[mainId][subId] -= amount;
            // Overflow/Underflow not possible: amount <= fromBalanceMain <= totalSupply
        }
        if (_totalSubSupply[mainId][subId] == 0) {
            --_totalSubIds[mainId];
            uint256[] storage array = _subIds[mainId];
            uint256 subIdIndex = _subIdIndex[mainId][subId];
            uint256 lastSubId = array[array.length - 1];
            array[subIdIndex] = lastSubId;
            _subIdIndex[mainId][lastSubId] = subIdIndex;
            delete _subIdIndex[mainId][subId];
            array.pop();
        }
        if (_totalMainSupply[mainId] == 0) {
            --_totalMainIds;
        }
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     */
    // solhint-disable-next-line ordering
    uint256[44] private __gap;
}
