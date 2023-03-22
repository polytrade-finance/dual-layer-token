// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "../NewStandard.sol";

abstract contract NewStandardSupply is NewStandard {
    mapping(uint256 => uint256) private _mainTotalSupply;

    mapping(uint256 => mapping(uint256 => uint256)) private _subTotalSupply;

    function mainTotalSupply(
        uint256 mainId
    ) public view virtual returns (uint256) {
        return _mainTotalSupply[mainId];
    }

    function subTotalSupply(
        uint256 mainId,
        uint256 subId
    ) public view virtual returns (uint256) {
        return _subTotalSupply[mainId][subId];
    }

    function mainExists(uint256 mainId) public view virtual returns (bool) {
        return NewStandardSupply.mainTotalSupply(mainId) > 0;
    }

    function subnExists(
        uint256 mainId,
        uint256 subId
    ) public view virtual returns (bool) {
        return NewStandardSupply.subTotalSupply(mainId, subId) > 0;
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory mainIds,
        uint256[] memory subIds,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        super._beforeTokenTransfer(
            operator,
            from,
            to,
            mainIds,
            subIds,
            amounts,
            data
        );

        if (from == address(0)) {
            for (uint256 i = 0; i < mainIds.length; ++i) {
                _mainTotalSupply[mainIds[i]] += amounts[i];
                _subTotalSupply[mainIds[i]][subIds[i]] += amounts[i];
            }
        }

        if (to == address(0)) {
            for (uint256 i = 0; i < mainIds.length; ++i) {
                uint256 mainId = mainIds[i];
                uint256 subId = subIds[i];
                uint256 amount = amounts[i];
                uint256 mainSupply = _mainTotalSupply[mainId];
                uint256 subSupply = _subTotalSupply[mainId][subId];
                require(
                    mainSupply >= amount && subSupply >= amount,
                    "NewStandard: burn amount exceeds totalSupply"
                );
                unchecked {
                    _mainTotalSupply[mainId] = mainSupply - amount;
                    _subTotalSupply[mainId][subId] = subSupply - amount;
                }
            }
        }
    }
}
