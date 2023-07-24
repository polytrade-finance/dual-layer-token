// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../DLTUpgradeable.sol";
import "../interfaces/IDLTPermitUpgradeable.sol";
import { Initializable } from "@openzeppelin/contracts/proxy/utils/Initializable.sol";

/**
 * @dev Implementation of the DLT Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's DLT allowance (see {IDLTUpgradeable-allowance}) by
 * presenting a message signed by the account.
 */
abstract contract DLTPermitUpgradeable is
    Initializable,
    DLTUpgradeable,
    IDLTPermitUpgradeable
{
    mapping(address => uint256) private _currentNonce;

    bytes32 private constant _EIP_712_DOMAIN_TYPEHASH =
        keccak256(
            abi.encodePacked(
                "EIP712Domain(",
                "string name,",
                "string version,",
                "uint256 chainId,",
                "address verifyingContract",
                ")"
            )
        );

    bytes32 private constant _PERMIT_TYPEHASH =
        keccak256(
            abi.encodePacked(
                "Permit(",
                "address owner,",
                "address spender,",
                "uint256 mainId,",
                "uint256 subId,",
                "uint256 amount,",
                "uint256 nonce,",
                "uint256 deadline",
                ")"
            )
        );

    // solhint-disable var-name-mixedcase
    bytes32 private _NAME_HASH;
    bytes32 private _VERSION_HASH;
    bytes32 internal _DOMAIN_SEPARATOR;

    error InvalidSignatureS(bytes32 s);
    error InvalidSignature();
    error InvalidSigner();
    error ExpiredSignature();

    // solhint-disable-next-line func-name-mixedcase
    function __DLTPermit_init(
        string memory name,
        string memory version
    ) internal onlyInitializing {
        __DLTPermit_init_unchained(name, version);
    }

    // solhint-disable-next-line func-name-mixedcase
    function __DLTPermit_init_unchained(
        string memory name,
        string memory version
    ) internal onlyInitializing {
        _NAME_HASH = keccak256(bytes(name));
        _VERSION_HASH = keccak256(bytes(version));
        _DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                _EIP_712_DOMAIN_TYPEHASH,
                _NAME_HASH,
                _VERSION_HASH,
                block.chainid,
                address(this)
            )
        );
    }

    /**
     * @dev See {IDLTPermitUpgradeable-DOMAIN_SEPARATOR}.
     */
    // solhint-disable-next-line func-name-mixedcase, ordering
    function DOMAIN_SEPARATOR() external view override returns (bytes32) {
        return _domainSeparatorV4();
    }

    /**
     * @dev See {IDLTPermitUpgradeable-permit}.
     */
    function permit(
        address owner,
        address spender,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public virtual {
        if (block.timestamp > deadline) revert ExpiredSignature();
        uint256 nonce = _useNonce(owner);
        bytes32 structHash = keccak256(
            abi.encode(
                _PERMIT_TYPEHASH,
                owner,
                spender,
                mainId,
                subId,
                amount,
                nonce,
                deadline
            )
        );

        bytes32 hash = _hashTypedDataV4(structHash);

        address signer = _recover(hash, v, r, s);
        if (signer != owner) revert InvalidSignature();

        _approve(owner, spender, mainId, subId, amount);
    }

    /**
     * @dev See {IDLTPermitUpgradeable-nonces}.
     */
    function nonces(
        address owner
    ) public view virtual override returns (uint256) {
        return _currentNonce[owner];
    }

    /**
     * @dev "Consume a nonce": return the current value and increment
     */
    function _useNonce(
        address owner
    ) internal virtual returns (uint256 current) {
        current = _currentNonce[owner];
        _currentNonce[owner]++;
    }

    /**
     * @dev Returns the domain separator
     */
    function _domainSeparatorV4() internal view returns (bytes32) {
        return _DOMAIN_SEPARATOR;
    }

    /**
     * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
     * function returns the hash of the fully encoded EIP712 message for this domain.
     */
    function _hashTypedDataV4(
        bytes32 structHash
    ) internal view virtual returns (bytes32) {
        return _toTypedDataHash(_domainSeparatorV4(), structHash);
    }

    /**
     * @dev Receives the `v`,`r` and `s` signature fields separately
     */
    function _recover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address) {
        if (
            uint256(s) >
            0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
        ) {
            revert InvalidSignatureS(s);
        }

        address signer = ecrecover(hash, v, r, s);
        if (signer == address(0)) {
            revert InvalidSigner();
        }

        return signer;
    }

    /**
     * @dev Returns an Ethereum Signed Typed Data, created from a
     * `domainSeparator` and a `structHash`. This produces hash corresponding
     * to the one signed with the
     * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
     * JSON-RPC method as part of EIP-712.
     *
     * See {_recover}.
     */
    function _toTypedDataHash(
        bytes32 domainSeparator,
        bytes32 structHash
    ) internal pure returns (bytes32 data) {
        /// @solidity memory-safe-assembly
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, "\x19\x01")
            mstore(add(ptr, 0x02), domainSeparator)
            mstore(add(ptr, 0x22), structHash)
            data := keccak256(ptr, 0x42)
        }
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     */
    uint256[44] private __gap;
}
