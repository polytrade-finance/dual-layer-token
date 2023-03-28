// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import { DLT } from "../DLT/DLT.sol";
import { IERC165 } from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import { ERC165 } from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { IInvoice } from "./interface/IInvoice.sol";

contract InvoiceNFT is IERC165, IInvoice, DLT, AccessControl {
    string private _invoiceBaseURI = "https://ipfs.io/ipfs";

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    /**
     * @dev Mapping will be indexing the metadata for each AssetNFT by its Asset Number
     */
    mapping(uint256 => Metadata) private _metadata;

    constructor(
        string memory name,
        string memory symbol,
        string memory baseURI_
    ) DLT(name, symbol) {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(MINTER_ROLE, _msgSender());

        _setBaseURI(baseURI_);
    }

    /**
     * @dev Implementation of a mint function that uses the predefined _mint() function from DLT standard
     * @param receiver, Receiver address of the newly minted Category
     * @param initialMetadata, Struct of type InitialMetadata contains initial metadata need to be verified
     */
    function createInvoice(
        address receiver,
        string calldata newURI,
        InitialMetadata calldata initialMetadata
    ) external {
        require(hasRole(MINTER_ROLE, _msgSender()), "Need MINTER_ROLE");

        _mint(receiver, initialMetadata.invoiceAmount);

        _tokenURIs[totalMainIds()] = newURI;
        _metadata[totalMainIds()].initialMetadata = initialMetadata;
    }

    /**
     * @dev Implementation of a setter for the asset base URI
     * @param newBaseURI, String of the asset base URI
     */
    function setBaseURI(string calldata newBaseURI) external {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "Need DEFAULT_ADMIN_ROLE"
        );

        _setBaseURI(newBaseURI);
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _invoiceBaseURI;

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return "";
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(IERC165, ERC165, AccessControl)
        returns (bool)
    {
        return interfaceId == type(IERC165).interfaceId;
    }

    /**
     * @dev Implementation of a setter for the asset base URI
     * @param newBaseURI, String of the asset base URI
     */
    function _setBaseURI(string memory newBaseURI) private {
        string memory oldBaseURI = _invoiceBaseURI;
        _invoiceBaseURI = newBaseURI;
        emit InvoiceBaseURISet(oldBaseURI, newBaseURI);
    }
}
