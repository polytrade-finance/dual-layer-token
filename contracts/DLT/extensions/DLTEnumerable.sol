// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../DLT.sol";
import "../interfaces/IDLTEnumerable.sol";

/*
 * @dev This implements an optional extension of {DLT} defined in the EIP 6960 that adds
 * enumerability of all the main ids and sub ids in the contract as well as total supply by each main ids and sub ids.
 */
abstract contract DLTEnumerable is DLT, IDLTEnumerable {
    uint256 private _totalMainIds;

    /**
     * @dev MappiArray of sub ids for each main ids
     */
    mapping(uint256 => uint256) private _totalSubIds;

    /**
     * @dev Mapping from mainId to total supply of main ids
     */
    mapping(uint256 => uint256) private _mainTotalSupply;

    /**
     * @dev Mapping from mainId to sub id to total supply of sub ids
     */
    mapping(uint256 => mapping(uint256 => uint256)) private _subTotalSupply;

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
     * @dev See {IDLTEnumerable-mainTotalSupply}.
     */
    function mainTotalSupply(
        uint256 mainId
    ) public view virtual returns (uint256) {
        return _mainTotalSupply[mainId];
    }

    /**
     * @dev See {IDLTEnumerable-subTotalSupply}.
     */
    function subTotalSupply(
        uint256 mainId,
        uint256 subId
    ) public view virtual returns (uint256) {
        return _subTotalSupply[mainId][subId];
    }

    /**
     * @dev See {IDLTEnumerable-subIds}.
     */
    function subIds(
        uint256 mainId
    ) public view virtual returns (uint256[] memory) {
        return _subIds[mainId];
    }

    /**
     * @dev See {IDLTEnumerable-totalSubIdBalance}.
     */
    function totalSubIdBalance(
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
    ) internal virtual override(DLT) {
        if (_mainTotalSupply[mainId] == 0) {
            ++_totalMainIds;
        }
        if (_subTotalSupply[mainId][subId] == 0) {
            ++_totalSubIds[mainId];
            uint256[] storage array = _subIds[mainId];
            _subIdIndex[mainId][subId] = array.length;
            array.push(subId);
        }
        _mainTotalSupply[mainId] += amount;
        _subTotalSupply[mainId][subId] += amount;
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
    ) internal virtual override(DLT) {
        super._burn(recipient, mainId, subId, amount);
        unchecked {
            _mainTotalSupply[mainId] -= amount;
            _subTotalSupply[mainId][subId] -= amount;
            // Overflow not possible: amount <= fromBalanceMain <= totalSupply.
        }
        if (_subTotalSupply[mainId][subId] == 0) {
            --_totalSubIds[mainId];
            uint256[] storage array = _subIds[mainId];
            uint256 subIdIndex = _subIdIndex[mainId][subId];
            uint256 lastSubId = array[array.length - 1];
            array[subIdIndex] = lastSubId;
            _subIdIndex[mainId][lastSubId] = subIdIndex;
            delete _subIdIndex[mainId][subId];
            array.pop();
        }
        if (_mainTotalSupply[mainId] == 0) {
            --_totalMainIds;
        }
    }
}
