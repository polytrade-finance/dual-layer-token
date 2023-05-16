# DLT (Dual Layer Token) Standard 🛠️

Welcome to the Dual-Layer-Token (DLT) Standard, proposed under EIP-6960! 🎉

DLT is a versatile and efficient token standard for managing diverse digital assets in a clear and organized manner. 📚💼🏦

## Table of Contents 📑

- [About DLT](#about-dlt)
- [DLT vs. Existing Standards](#dlt-vs-existing-standards)
- [Interface Overview](#interface-overview)
- [Key Functions](#key-functions)
- [DLT Examples](#dlt-examples)
- [Conclusion](#conclusion)

## About DLT 🚀

DLT, or Dual Layer Token, is a unique token standard that combines the best features of existing standards while adding a novel layered structure, making it ideal for managing diverse asset types and their attributes.

The DLT structure comprises:

- `mainId`: Represents the primary asset type.
- `subId`: Represents the unique attributes or variations of the asset.

## DLT vs. Existing Standards 🥊

While existing token standards (ERC20, ERC721, ERC1155) have their merits, they each have limitations when dealing with diverse asset types and attributes within the same contract.

DLT overcomes these limitations by providing a more flexible, efficient, and scalable solution for managing various assets. 🏗️

Benefits of DLT include:

- Simplified Asset Management 📦
- Optimized Gas Costs ⛽
- Inherent Scalability 📈
- Enhanced Interoperability 🧩
- Fostering Innovation 💡

## Interface Overview 📖

The DLT Interface consists of several key events and functions that facilitate the handling and management of tokens.

Key events include:

- `Transfer`: Emitted when a token is transferred.
- `TransferBatch`: Emitted for batch transfers.
- `Approval`: Emitted when an owner approves a spender to manage a token.
- `ApprovalForAll`: Emitted when a spender enables or disables an operator to manage all of its assets.
- `URI`: Emitted when the URI of a mainId is changed.

Key functions include:

- `setApprovalForAll`: Approve or remove an operator for the caller.
- `safeTransferFrom`: Moves tokens using the allowance mechanism.
- `approve`: Sets the allowance of a spender over the caller's tokens.
- `subBalanceOf`: Returns the amount of tokens owned by an account.
- `balanceOfBatch`: Returns the balances of multiple accounts.
- `allowance`: Returns the remaining number of tokens that a spender can spend on behalf of an owner.
- `isApprovedForAll`: Checks if an operator is allowed to manage all of the assets of an owner.

## Key Functions 📚

The DLT interface provides a set of functions to interact with and manage the tokens. Here's a brief overview:

- `setApprovalForAll(operator, approved)`: Allows the approval or removal of `operator` as an operator for the caller. Operators can call `transferFrom` or `safeTransferFrom` for any token owned by the caller.
- `safeTransferFrom(sender, recipient, mainId, subId, amount, data)`: Moves `amount` tokens from `sender` to `recipient` using the allowance mechanism. `amount` is then deducted from the caller's allowance.
- `approve(spender, mainId, subId, amount)`: Sets `amount` as the allowance of `spender` over the caller's tokens.
- `subBalanceOf(account, mainId, subId)`: Returns the amount of tokens owned by `account
- `balanceOfBatch(accounts, mainIds, subIds)`: Returns the balances of multiple `accounts` for each pair of `mainIds` and `subIds`.
- `allowance(owner, spender, mainId, subId)`: Returns the remaining number of tokens that `spender` can spend on behalf of `owner` for a specific `mainId` and `subId`.
- `isApprovedForAll(owner, operator)`: Checks if `operator` is allowed to manage all of the assets of `owner`.

## DLT Examples 🌟

1. Real Estate Platform with Fractional Ownership:

   DLT can represent unique houses (mainId) and fractional ownership (subId) efficiently within the same contract, allowing for a more versatile real estate platform.

2. Invoice Factoring for SMEs:

   DLT can represent unique invoices (mainId) and individual invoice components or fractional ownership (subId) efficiently within the same contract, allowing for a more versatile invoice factoring platform for SMEs.

## SubId Types 📏

DLT can manage different types of digital assets (mainIds) and their attributes or variations (subIds) with associated quantities in various applications. SubIds can be used in two ways:

1. Shared SubIds:

   All mainIds share the same set of subIds.

   Example: Smartphone Models and Storage Capacities

   MainIds (Models):

   - iPhone
   - Samsung
   - Google Pixel

   SubIds (Storage Capacities):

   - A: 64GB
   - B: 128GB
   - C: 256GB

   Here, all smartphone models (mainIds) have the same storage capacities (subIds A, B, C).

2. Mixed SubIds:

   MainIds have unique sets of subIds.

   Example: Courses and Instructors with Class Quotas

   MainIds (Courses):

   - Math
   - Science
   - History

   SubIds (Instructors and Class Quotas):

   - A: Alice (20 students)
   - B: Bob (15 students)
   - C: Carol (30 students)
   - D: Dave (25 students)

   Here, each course (mainId) has a different set of instructors (subIds) with specific class quotas.

## Conclusion 🔚

DLT is a versatile and efficient token standard that simplifies asset management, optimizes gas costs, and promotes scalability, interoperability, and innovation across various industries and use cases.

By implementing the DLT standard in your projects, you can unlock the potential of blockchain technology for managing diverse assets and their unique attributes or variations. 🚀
