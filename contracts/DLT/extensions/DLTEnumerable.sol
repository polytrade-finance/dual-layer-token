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

    /// MappiArray of sub ids for each main ids
    mapping(uint256 => uint256) private _totalSubIds;

    /// Mapping from mainId to total supply of main ids
    mapping(uint256 => uint256) private _mainTotalSupply;

    /// Mapping from mainId to sub id to total supply of sub ids
    mapping(uint256 => mapping(uint256 => uint256)) private _subTotalSupply;

    /// Mapping from main ids to address to array of sub ids
    mapping(uint256 => mapping(address => uint256[])) private _ownedSubIds;

    /// Mapping from subId to position in the _subIds array
    mapping(uint256 => uint256) private _subIdIndex;

    /**
     * @dev See {IDLTEnumerable-totalMainIds}.
     */
    function totalMainIds() public view virtual override returns (uint256) {
        return _totalMainIds;
    }

    /**
     * @dev See {IDLTEnumerable-totalSubIds}.
     */
    function totalSubIds(
        uint256 mainId
    ) public view virtual override returns (uint256) {
        return _totalSubIds[mainId];
    }

    /**
     * @dev See {IDLTEnumerable-mainTotalSupply}.
     */
    function mainTotalSupply(
        uint256 mainId
    ) public view virtual override returns (uint256) {
        return _mainTotalSupply[mainId];
    }

    /**
     * @dev See {IDLTEnumerable-subTotalSupply}.
     */
    function subTotalSupply(
        uint256 mainId,
        uint256 subId
    ) public view virtual override returns (uint256) {
        return _subTotalSupply[mainId][subId];
    }

    /**
     * @dev See {IDLTEnumerable-ownedSubIds}.
     */
    function ownedSubIds(
        uint256 mainId,
        address owner
    ) public view virtual override returns (uint256[] memory) {
        return _ownedSubIds[mainId][owner];
    }

    /**
     * @dev See {IDLTEnumerable-subIdBalance}.
     */
    function ownedSubIdBalance(
        uint256 mainId,
        address owner
    ) public view virtual override returns (uint256 totalBalance) {
        for (uint256 i = 0; i < _ownedSubIds[mainId][owner].length; i++) {
            totalBalance += _ownedSubIds[mainId][owner][i];
        }
        return totalBalance;
    }

    /**
     * @dev See {DLT-_beforeTokenTransfer}.
     */
    function _beforeTokenTransfer(
        address sender,
        address recipient,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes memory data
    ) internal virtual override {
        super._beforeTokenTransfer(
            sender,
            recipient,
            mainId,
            subId,
            amount,
            data
        );
        if (sender == address(0)) {
            if (_mainTotalSupply[mainId] == 0) {
                ++_totalMainIds;
            }
            if (_subTotalSupply[mainId][subId] == 0) {
                ++_totalSubIds[mainId];
            }
            _addToSubIds(mainId, subId, recipient);
            _mainTotalSupply[mainId] += amount;
            _subTotalSupply[mainId][subId] += amount;
        } else if (sender != recipient) {
            _addToSubIds(mainId, subId, recipient);
        }
    }

    /**
     * @dev See {DLT-_afterTokenTransfer}.
     */
    function _afterTokenTransfer(
        address sender,
        address recipient,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes memory data
    ) internal virtual override {
        super._afterTokenTransfer(
            sender,
            recipient,
            mainId,
            subId,
            amount,
            data
        );
        if (recipient == address(0)) {
            unchecked {
                _mainTotalSupply[mainId] -= amount;
                _subTotalSupply[mainId][subId] -= amount;
                // Overflow not possible: amount <= fromBalanceMain <= totalSupply.
            }
            _removeFromSubIds(mainId, subId, sender);
            if (_subTotalSupply[mainId][subId] == 0) {
                --_totalSubIds[mainId];
            }
            if (_mainTotalSupply[mainId] == 0) {
                --_totalMainIds;
            }
        } else if (recipient != sender) {
            _removeFromSubIds(mainId, subId, sender);
        }
    }

    function _addToSubIds(
        uint256 mainId,
        uint256 subId,
        address recipient
    ) private {
        if (_balances[mainId][recipient][subId] == 0) {
            uint256[] storage array = _ownedSubIds[mainId][recipient];
            _subIdIndex[subId] = array.length;
            array.push(subId);
        }
    }

    function _removeFromSubIds(
        uint256 mainId,
        uint256 subId,
        address sender
    ) private {
        if (_balances[mainId][sender][subId] == 0) {
            uint256[] storage array = _ownedSubIds[mainId][sender];
            uint256 subIdIndex = _subIdIndex[subId];
            uint256 lastSubId = array[array.length - 1];
            array[subIdIndex] = lastSubId;
            _subIdIndex[lastSubId] = subIdIndex;
            delete _subIdIndex[subId];
            array.pop();
        }
    }
}
