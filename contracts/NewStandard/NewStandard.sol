// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "./INewStandard.sol";
import "./INewStandardReceiver.sol";
import "./extensions/INewStandardMetadataURI.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

contract NewStandard is Context, ERC165, INewStandard, INewStandardMetadataURI {
    using Address for address;

    mapping(uint256 => mapping(address => uint256)) private _mainBalances;

    mapping(uint256 => mapping(uint256 => mapping(address => uint256)))
        private _subBalances;

    mapping(address => mapping(address => bool)) private _operatorApprovals;

    string private _uri;

    constructor(string memory uri_) {
        _setURI(uri_);
    }

    function setApprovalForAll(
        address operator,
        bool approved
    ) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "NewStandard: caller is not token owner or approved"
        );
        _safeTransferFrom(from, to, mainId, subId, amount, data);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory mainIds,
        uint256[] memory subIds,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override {
        require(
            from == _msgSender() || isApprovedForAll(from, _msgSender()),
            "NewStandard: caller is not token owner or approved"
        );
        _safeBatchTransferFrom(from, to, mainIds, subIds, amounts, data);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(INewStandard).interfaceId ||
            interfaceId == type(INewStandardMetadataURI).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function uri(uint256) public view virtual override returns (string memory) {
        return _uri;
    }

    function balanceOfMain(
        address account,
        uint256 mainId
    ) public view virtual override returns (uint256) {
        require(
            account != address(0),
            "NewStandard: address zero is not a valid owner"
        );
        return _mainBalances[mainId][account];
    }

    function balanceOfSub(
        address account,
        uint256 mainId,
        uint256 subId
    ) public view virtual override returns (uint256) {
        require(
            account != address(0),
            "NewStandard: address zero is not a valid owner"
        );
        return _subBalances[mainId][subId][account];
    }

    function balanceOfBatchMain(
        address[] memory accounts,
        uint256[] memory mainIds
    ) public view virtual override returns (uint256[] memory) {
        require(
            accounts.length == mainIds.length,
            "NewStandard: accounts and ids length mismatch"
        );

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOfMain(accounts[i], mainIds[i]);
        }

        return batchBalances;
    }

    function balanceOfBatchSub(
        address[] memory accounts,
        uint256[] memory mainIds,
        uint256[] memory subIds
    ) public view virtual override returns (uint256[] memory) {
        require(
            accounts.length == mainIds.length &&
                accounts.length == subIds.length,
            "NewStandard: accounts and ids length mismatch"
        );

        uint256[] memory batchBalances = new uint256[](accounts.length);

        for (uint256 i = 0; i < accounts.length; ++i) {
            batchBalances[i] = balanceOfSub(accounts[i], mainIds[i], subIds[i]);
        }

        return batchBalances;
    }

    function isApprovedForAll(
        address account,
        address operator
    ) public view virtual override returns (bool) {
        return _operatorApprovals[account][operator];
    }

    function _safeTransferFrom(
        address from,
        address to,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "NewStandard: transfer to the zero address");

        address operator = _msgSender();
        uint256[] memory mainIds = _asSingletonArray(mainId);
        uint256[] memory subIds = _asSingletonArray(subId);
        uint256[] memory amounts = _asSingletonArray(amount);

        _beforeTokenTransfer(
            operator,
            from,
            to,
            mainIds,
            subIds,
            amounts,
            data
        );

        uint256 fromBalanceMain = _mainBalances[mainId][from];
        uint256 fromBalanceSub = _subBalances[mainId][subId][from];
        require(
            fromBalanceSub >= amount,
            "NewStandard: insufficient balance for transfer"
        );
        unchecked {
            _mainBalances[mainId][from] = fromBalanceMain - amount;
            _subBalances[mainId][subId][from] = fromBalanceSub - amount;
        }
        _mainBalances[mainId][to] += amount;
        _subBalances[mainId][subId][to] += amount;

        emit TransferSingle(operator, from, to, mainId, subId, amount);

        _afterTokenTransfer(operator, from, to, mainIds, subIds, amounts, data);

        _doSafeTransferAcceptanceCheck(
            operator,
            from,
            to,
            mainId,
            subId,
            amount,
            data
        );
    }

    function _safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory mainIds,
        uint256[] memory subIds,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(
            amounts.length == mainIds.length && amounts.length == subIds.length,
            "NewStandard: ids and amounts length mismatch"
        );
        require(to != address(0), "NewStandard: transfer to the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(
            operator,
            from,
            to,
            mainIds,
            subIds,
            amounts,
            data
        );

        for (uint256 i = 0; i < mainIds.length; ++i) {
            uint256 mainId = mainIds[i];
            uint256 subId = subIds[i];
            uint256 amount = amounts[i];

            uint256 fromBalanceMain = _mainBalances[mainId][from];
            uint256 fromBalanceSub = _subBalances[mainId][subId][from];
            require(
                fromBalanceSub >= amount,
                "NewStandard: insufficient balance for transfer"
            );
            unchecked {
                _mainBalances[mainId][from] = fromBalanceMain - amount;
                _subBalances[mainId][subId][from] = fromBalanceSub - amount;
            }
            _mainBalances[mainId][to] += amount;
            _subBalances[mainId][subId][to] += amount;
        }

        emit TransferBatch(operator, from, to, mainIds, subIds, amounts);

        _afterTokenTransfer(operator, from, to, mainIds, subIds, amounts, data);

        _doSafeBatchTransferAcceptanceCheck(
            operator,
            from,
            to,
            mainIds,
            subIds,
            amounts,
            data
        );
    }

    function _setURI(string memory newuri) internal virtual {
        _uri = newuri;
    }

    function _mint(
        address to,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "NewStandard: mint to the zero address");

        address operator = _msgSender();
        uint256[] memory mainIds = _asSingletonArray(mainId);
        uint256[] memory subIds = _asSingletonArray(subId);
        uint256[] memory amounts = _asSingletonArray(amount);

        _beforeTokenTransfer(
            operator,
            address(0),
            to,
            mainIds,
            subIds,
            amounts,
            data
        );

        _mainBalances[mainId][to] += amount;
        _subBalances[mainId][subId][to] += amount;
        emit TransferSingle(operator, address(0), to, mainId, subId, amount);

        _afterTokenTransfer(
            operator,
            address(0),
            to,
            mainIds,
            subIds,
            amounts,
            data
        );

        _doSafeTransferAcceptanceCheck(
            operator,
            address(0),
            to,
            mainId,
            subId,
            amount,
            data
        );
    }

    function _mintBatch(
        address to,
        uint256[] memory mainIds,
        uint256[] memory subIds,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        require(to != address(0), "NewStandard: mint to the zero address");
        require(
            mainIds.length == amounts.length && subIds.length == amounts.length,
            "NewStandard: ids and amounts length mismatch"
        );

        address operator = _msgSender();

        _beforeTokenTransfer(
            operator,
            address(0),
            to,
            mainIds,
            subIds,
            amounts,
            data
        );

        for (uint256 i = 0; i < mainIds.length; i++) {
            _mainBalances[mainIds[i]][to] += amounts[i];
            _subBalances[mainIds[i]][subIds[i]][to] += amounts[i];
        }

        emit TransferBatch(operator, address(0), to, mainIds, subIds, amounts);

        _afterTokenTransfer(
            operator,
            address(0),
            to,
            mainIds,
            subIds,
            amounts,
            data
        );

        _doSafeBatchTransferAcceptanceCheck(
            operator,
            address(0),
            to,
            mainIds,
            subIds,
            amounts,
            data
        );
    }

    function _burn(
        address from,
        uint256 mainId,
        uint256 subId,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "NewStandard: burn from the zero address");

        address operator = _msgSender();
        uint256[] memory mainIds = _asSingletonArray(mainId);
        uint256[] memory subIds = _asSingletonArray(subId);
        uint256[] memory amounts = _asSingletonArray(amount);

        _beforeTokenTransfer(
            operator,
            from,
            address(0),
            mainIds,
            subIds,
            amounts,
            ""
        );

        uint256 fromBalanceMain = _mainBalances[mainId][from];
        uint256 fromBalanceSub = _subBalances[mainId][subId][from];

        require(
            fromBalanceSub >= amount || fromBalanceMain >= amount,
            "NewStandard: burn amount exceeds balance"
        );
        unchecked {
            _mainBalances[mainId][from] = fromBalanceMain - amount;
            _subBalances[mainId][subId][from] = fromBalanceSub - amount;
        }

        emit TransferSingle(operator, from, address(0), mainId, subId, amount);

        _afterTokenTransfer(
            operator,
            from,
            address(0),
            mainIds,
            subIds,
            amounts,
            ""
        );
    }

    function _burnBatch(
        address from,
        uint256[] memory mainIds,
        uint256[] memory subIds,
        uint256[] memory amounts
    ) internal virtual {
        require(from != address(0), "NewStandard: burn from the zero address");
        require(
            mainIds.length == amounts.length && subIds.length == amounts.length,
            "NewStandard: ids and amounts length mismatch"
        );

        address operator = _msgSender();

        _beforeTokenTransfer(
            operator,
            from,
            address(0),
            mainIds,
            subIds,
            amounts,
            ""
        );

        for (uint256 i = 0; i < mainIds.length; i++) {
            uint256 mainId = mainIds[i];
            uint256 subId = subIds[i];
            uint256 amount = amounts[i];

            uint256 fromBalanceMain = _mainBalances[mainId][from];
            uint256 fromBalanceSub = _subBalances[mainId][subId][from];
            require(
                fromBalanceSub >= amount || fromBalanceMain >= amount,
                "NewStandard: burn amount exceeds balance"
            );
            unchecked {
                _mainBalances[mainId][from] = fromBalanceMain - amount;
                _subBalances[mainId][subId][from] = fromBalanceSub - amount;
            }
        }

        emit TransferBatch(
            operator,
            from,
            address(0),
            mainIds,
            subIds,
            amounts
        );

        _afterTokenTransfer(
            operator,
            from,
            address(0),
            mainIds,
            subIds,
            amounts,
            ""
        );
    }

    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(
            owner != operator,
            "NewStandard: setting approval status for self"
        );
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory mainIds,
        uint256[] memory subIds,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        operator;
        from;
        to;
        mainIds;
        subIds;
        amounts;
        data;
    }

    function _afterTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory mainIds,
        uint256[] memory subIds,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual {
        operator;
        from;
        to;
        mainIds;
        subIds;
        amounts;
        data;
    }

    function _doSafeTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256 mainId,
        uint256 subId,
        uint256 amount,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try
                INewStandardReceiver(to).onNewStandardReceived(
                    operator,
                    from,
                    mainId,
                    subId,
                    amount,
                    data
                )
            returns (bytes4 response) {
                if (
                    response !=
                    INewStandardReceiver.onNewStandardReceived.selector
                ) {
                    revert("NewStandard: NewStandardReceiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert(
                    "NewStandard: transfer to non-NewStandardReceiver implementer"
                );
            }
        }
    }

    function _doSafeBatchTransferAcceptanceCheck(
        address operator,
        address from,
        address to,
        uint256[] memory mainIds,
        uint256[] memory subIds,
        uint256[] memory amounts,
        bytes memory data
    ) private {
        if (to.isContract()) {
            try
                INewStandardReceiver(to).onNewStandardBatchReceived(
                    operator,
                    from,
                    mainIds,
                    subIds,
                    amounts,
                    data
                )
            returns (bytes4 response) {
                if (
                    response !=
                    INewStandardReceiver.onNewStandardBatchReceived.selector
                ) {
                    revert("NewStandard: NewStandardReceiver rejected tokens");
                }
            } catch Error(string memory reason) {
                revert(reason);
            } catch {
                revert(
                    "NewStandard: transfer to non-NewStandardReceiver implementer"
                );
            }
        }
    }

    function _asSingletonArray(
        uint256 element
    ) private pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](1);
        array[0] = element;

        return array;
    }
}
