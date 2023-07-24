// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import { DLTUpgradeable } from "./DLTUpgradeable.sol";
import { DLTEnumerableUpgradeable } from "./extensions/DLTEnumerableUpgradeable.sol";
import { DLTPermitUpgradeable } from "./extensions/DLTPermitUpgradeable.sol";

contract TestDLTUpgradeable is
    Initializable,
    DLTUpgradeable,
    DLTEnumerableUpgradeable,
    DLTPermitUpgradeable
{
    function initialize(
        string memory name,
        string memory symbol,
        string memory version
    ) public initializer {
        __DLT_init(name, symbol);
        __DLTPermit_init(name, version);
    }

    // solhint-disable-next-line ordering
    function initDLT(string memory name, string memory symbol) external {
        __DLT_init(name, symbol);
    }

    function initDLTUnchained(
        string memory name,
        string memory symbol
    ) external {
        __DLT_init_unchained(name, symbol);
    }

    function initDLTPermit(string memory name, string memory version) external {
        __DLTPermit_init(name, version);
    }

    function initDLTPermitUnchained(
        string memory name,
        string memory version
    ) external {
        __DLTPermit_init_unchained(name, version);
    }

    // solhint-disable-next-line ordering
    function mint(
        address account,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) external {
        _safeMint(account, mainId, subId, amount);
    }

    function burn(
        address account,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) external {
        _burn(account, mainId, subId, amount);
    }

    function transfer(
        address sender,
        address recipient,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) external {
        _transfer(sender, recipient, mainId, subId, amount);
    }

    function allow(
        address sender,
        address recipient,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) external {
        _approve(sender, recipient, mainId, subId, amount);
    }

    function _mint(
        address recipient,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) internal virtual override(DLTUpgradeable, DLTEnumerableUpgradeable) {
        super._mint(recipient, mainId, subId, amount);
    }

    function _burn(
        address recipient,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) internal virtual override(DLTUpgradeable, DLTEnumerableUpgradeable) {
        super._burn(recipient, mainId, subId, amount);
    }
}
