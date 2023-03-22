// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "../NewStandard.sol";
import "../extensions/NewStandardBurnable.sol";
import "../extensions/NewStandardPausable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract NewStandardPresetMinterPauser is
    Context,
    AccessControlEnumerable,
    NewStandardBurnable,
    NewStandardPausable
{
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    constructor(string memory uri) NewStandard(uri) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        _setupRole(MINTER_ROLE, _msgSender());
        _setupRole(PAUSER_ROLE, _msgSender());
    }

    function mint(
        address to,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes memory data
    ) public virtual {
        require(
            hasRole(MINTER_ROLE, _msgSender()),
            "NewStandardPresetMinterPauser: must have minter role to mint"
        );

        _mint(to, mainId, subId, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory mainIds,
        uint256[] memory subIds,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual {
        require(
            hasRole(MINTER_ROLE, _msgSender()),
            "NewStandardPresetMinterPauser: must have minter role to mint"
        );

        _mintBatch(to, mainIds, subIds, amounts, data);
    }

    function pause() public virtual {
        require(
            hasRole(PAUSER_ROLE, _msgSender()),
            "NewStandardPresetMinterPauser: must have pauser role to pause"
        );
        _pause();
    }

    function unpause() public virtual {
        require(
            hasRole(PAUSER_ROLE, _msgSender()),
            "NewStandardPresetMinterPauser: must have pauser role to unpause"
        );
        _unpause();
    }

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(AccessControlEnumerable, NewStandard)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory mainIds,
        uint256[] memory subIds,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override(NewStandard, NewStandardPausable) {
        super._beforeTokenTransfer(
            operator,
            from,
            to,
            mainIds,
            subIds,
            amounts,
            data
        );
    }
}
