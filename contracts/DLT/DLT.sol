// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import { Address } from "@openzeppelin/contracts/utils/Address.sol";
import { Context } from "@openzeppelin/contracts/utils/Context.sol";
import { ERC165 } from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import { IDLT } from "./interface/IDLT.sol";

contract DLT is Context, ERC165, IDLT {
    using Address for address;

    string private _name;
    string private _symbol;

    // Count
    uint256 private _totalMainIds;
    mapping(uint256 => uint256) private _totalSubIds;

    // Supply
    uint256 private _totalSupply;
    mapping(uint256 => uint256) private _mainTotalSupply;
    mapping(uint256 => mapping(uint256 => uint256)) private _subTotalSupply;

    // Balances
    mapping(uint256 => mapping(address => uint256)) private _mainBalances;

    mapping(uint256 => mapping(uint256 => mapping(address => uint256)))
        private _subBalances;

    mapping(address => mapping(address => bool)) private _operatorApprovals;

    mapping(address => mapping(address => mapping(uint256 => mapping(uint256 => uint256))))
        private _allowances;

    constructor(string memory name, string memory symbol) {
        _name = name;
        _symbol = symbol;
    }

    function approve(
        address spender,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) external returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, mainId, subId, amount);
        return true;
    }

    function mint(address account, uint256 amount) external returns (bool) {
        _mint(account, amount);
        return true;
    }

    function burn(
        address account,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) external returns (bool) {
        _burn(account, mainId, subId, amount);
        return true;
    }

    /**
     * @dev See {IDLT-transferFrom}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes calldata data
    ) external returns (bool) {
        address spender = _msgSender();
        _spendAllowance(sender, spender, mainId, subId, amount);
        _transfer(sender, recipient, mainId, subId, amount);
        data;
        return true;
    }

    function setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) external {
        require(owner != operator, "DLT: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    function mainBalanceOf(
        address account,
        uint256 mainId
    ) external view returns (uint256) {
        return _mainBalances[mainId][account];
    }

    function subBalanceOf(
        address account,
        uint256 mainId,
        uint256 subId
    ) external view returns (uint256) {
        return _subBalances[mainId][subId][account];
    }

    function allowance(
        address owner,
        address spender,
        uint256 mainId,
        uint256 subId
    ) external view returns (uint256) {
        return _allowance(owner, spender, mainId, subId);
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function mainTotalSupply(uint256 mainId) external view returns (uint256) {
        return _mainTotalSupply[mainId];
    }

    function subTotalSupply(
        uint256 mainId,
        uint256 subId
    ) external view returns (uint256) {
        return _subTotalSupply[mainId][subId];
    }

    function totalSubIds(uint256 mainId) external view returns (uint256) {
        return _totalSubIds[mainId];
    }

    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function totalMainIds() public view returns (uint256) {
        return _totalMainIds;
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = _allowance(owner, spender, mainId, subId);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "DLT: insufficient allowance");
            unchecked {
                _approve(
                    owner,
                    spender,
                    mainId,
                    subId,
                    currentAllowance - amount
                );
            }
        }
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "DLT: approve from the zero address");
        require(spender != address(0), "DLT: approve to the zero address");

        _allowances[owner][spender][mainId][subId] = amount;
        emit Approval(owner, spender, mainId, subId, amount);
    }

    /**
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "DLT: transfer from the zero address");
        require(recipient != address(0), "DLT: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, mainId, subId, amount);

        uint256 senderBalanceMain = _mainBalances[mainId][sender];
        uint256 senderBalanceSub = _subBalances[mainId][subId][sender];
        require(
            senderBalanceSub >= amount,
            "DLT: insufficient balance for transfer"
        );
        unchecked {
            _mainBalances[mainId][sender] = senderBalanceMain - amount;
            _subBalances[mainId][subId][sender] = senderBalanceSub - amount;
        }

        _mainBalances[mainId][recipient] += amount;
        _subBalances[mainId][subId][recipient] += amount;

        emit Transfer(sender, recipient, mainId, subId, amount, "");

        _afterTokenTransfer(sender, recipient, mainId, subId, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`
     *
     * Emits a {Transfer} event with `sender` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "DLT: mint to the zero address");

        uint256 newMainId = ++_totalMainIds;

        _beforeTokenTransfer(address(0), account, newMainId, 1, amount);

        unchecked {
            _totalSupply += amount;
            _mainTotalSupply[newMainId] += amount;
            _subTotalSupply[newMainId][1] += amount;

            ++_totalSubIds[newMainId];

            _mainBalances[newMainId][account] += amount;
            _subBalances[newMainId][1][account] += amount;
        }

        emit Transfer(address(0), account, newMainId, 1, amount, "");

        _afterTokenTransfer(address(0), account, newMainId, 1, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(
        address account,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) internal virtual {
        require(account != address(0), "DLT: burn from the zero address");

        uint256 fromBalanceSub = _subBalances[mainId][subId][account];
        require(fromBalanceSub >= amount, "DLT: insufficient balance");

        _beforeTokenTransfer(account, address(0), mainId, subId, amount);

        unchecked {
            _totalSupply -= amount;
            _mainTotalSupply[mainId] -= amount;
            _subTotalSupply[mainId][subId] -= amount;

            _mainBalances[mainId][account] -= amount;
            _subBalances[mainId][subId][account] -= amount;
            // Overflow not possible: amount <= fromBalanceMain <= totalSupply.
        }

        emit Transfer(account, address(0), mainId, subId, amount, "");

        _afterTokenTransfer(account, address(0), mainId, subId, amount);
    }

    function _allowance(
        address owner,
        address spender,
        uint256 mainId,
        uint256 subId
    ) internal view returns (uint256) {
        return _allowances[owner][spender][mainId][subId];
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `sender` and `recipient` are both non-zero, `amount` of ``sender``'s tokens
     * will be transferred to `recipient`.
     * - when `sender` is zero, `amount` tokens will be minted for `recipient`.
     * - when `recipient` is zero, `amount` of ``sender``'s tokens will be burned.
     * - `sender` and `recipient` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address sender,
        address recipient,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `sender` and `recipient` are both non-zero, `amount` of ``sender``'s tokens
     * has been transferred to `recipient`.
     * - when `sender` is zero, `amount` tokens have been minted for `recipient`.
     * - when `recipient` is zero, `amount` of ``sender``'s tokens have been burned.
     * - `sender` and `recipient` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address sender,
        address recipient,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) internal virtual {}
}
