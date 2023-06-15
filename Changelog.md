# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and adheres to [Semantic Versioning](http://semver.org/).

## [1.0.0] - (2023-06-14)

### Added

- **DLTPermit extension** has been included, allowing the approval of a spender through message-based signing following[EIP-2612](https://eips.ethereum.org/EIPS/eip-2612). It involves calling the permit function with signed parameters.
- **DLTEnumerable extension** has been added to track the amounts in both main IDs and sub-IDs, including `totalMainIds`, `totalSubIds`, `totalMainSupply`, `totalSubSupply`, `getSubIds`, `subIdBalanceOf` functions.
- The new `getSubIds` function retrieves all sub-IDs associated with a main ID.

### Changed

- The `mainTotalSupply` has been renamed to `totalMainSupply` in the `DLTEnumerable` extension.
- The `subTotalSupply` has been renamed to `totalSubSupply` in the `DLTEnumerable` extension.
- Minor optimizations have been implemented in the `DLT`.

### Removed

- The `totalMainIds` function has been removed, and the tracking of total main IDs has been moved to the `DLTEnumerable` extension.
- The `totalSupply` function has been removed.
- The `mainTotalSupply` function has been removed, and the tracking of the main total supply has been moved to the `DLTEnumerable` extension.
- The `subTotalSupply` function has been removed, and the tracking of the total supply of a sub ID has been moved to the `DLTEnumerable` extension.
- The `totalSubIds` function has been removed, and the tracking of the number of sub IDs has been moved to the `DLTEnumerable` extension.
