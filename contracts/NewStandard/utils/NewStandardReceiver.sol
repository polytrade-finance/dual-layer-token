// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "../INewStandardReceiver.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

abstract contract NewStandardReceiver is ERC165, INewStandardReceiver {
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(INewStandardReceiver).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}
