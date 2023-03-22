// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/utils/Strings.sol";
import "../NewStandard.sol";

abstract contract NewStandardURIStorage is NewStandard {
    using Strings for uint256;

    string private _baseURI = "";

    mapping(uint256 => string) private _tokenURIs;

    function uri(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        string memory tokenURI = _tokenURIs[tokenId];

        return
            bytes(tokenURI).length > 0
                ? string(abi.encodePacked(_baseURI, tokenURI))
                : super.uri(tokenId);
    }

    function _setURI(uint256 tokenId, string memory tokenURI) internal virtual {
        string memory oldTokenURI = uri(tokenId);
        _tokenURIs[tokenId] = tokenURI;
        emit URI(oldTokenURI, uri(tokenId), tokenId);
    }

    function _setBaseURI(string memory baseURI) internal virtual {
        _baseURI = baseURI;
    }
}
