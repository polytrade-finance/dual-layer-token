// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "../NewStandard.sol";

abstract contract NewStandardBurnable is NewStandard {
    function burn(
        address account,
        uint256 mainId,
        uint256 subId,
        uint256 value
    ) public virtual {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()),
            "NewStandard: caller is not token owner or approved"
        );

        _burn(account, mainId, subId, value);
    }

    function burnBatch(
        address account,
        uint256[] memory mainIds,
        uint256[] memory subIds,
        uint256[] memory values
    ) public virtual {
        require(
            account == _msgSender() || isApprovedForAll(account, _msgSender()),
            "NewStandard: caller is not token owner or approved"
        );

        _burnBatch(account, mainIds, subIds, values);
    }
}
