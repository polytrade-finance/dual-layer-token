// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

contract DLT is Context, ERC165 {
    using Address for address;

    string private _name;
    string private _symbol;

    uint256 private _totalSupply;

    mapping(uint256 => mapping(address => uint256)) private _mainBalances;

    mapping(uint256 => mapping(uint256 => mapping(address => uint256)))
        private _subBalances;

    mapping(address => mapping(address => bool)) private _operatorApprovals;

    mapping(address => mapping(address => mapping(uint256 => mapping(uint256 => uint256))))
        private _allowances;
}
