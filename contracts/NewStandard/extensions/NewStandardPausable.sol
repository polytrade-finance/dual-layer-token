// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "../NewStandard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

abstract contract NewStandardPausable is NewStandard, Pausable {
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

        require(!paused(), "NewStandardPausable: token transfer while paused");
    }
}
