# LenderPool V3

![solidity](https://img.shields.io/badge/Solidity-e6e6e6?style=for-the-badge&logo=solidity&logoColor=black) ![openzeppelin](https://img.shields.io/badge/OpenZeppelin-4E5EE4?logo=OpenZeppelin&logoColor=fff&style=for-the-badge)

This repository contains the smart contracts for LenderPool V3, see [documentation](https://polytrade.gitbook.io/lender-v3/) for details.

Lender Pool Version 3 represents a revamped version of the current LenderPool V2 architecture that streamlines and automates the pool dynamics, providing lenders with greater control and flexibility. The cornerstone of LPV3 is the Lender Pool factory, which generates pool instances that meet various needs and specifications.

## 💸 LenderPool Types

### Fixed Pool

Features of a fixed pool include:

- **Locking Period:** a timeframe for which deposits are held in a pool until their end date.
- **Deposit Window:** deposits are only allowed within a specified timeframe, after which the pool will be closed to any additional funding.
- **Fixed APR and Bonus Rate:** non-variable annual percentage rate (APR) and bonus rate set by the pool administrator throughout the deposit period.

### Flexible Pool

Features of a flexible pool include:

- **Locking Period**
  - Base pool:
    - No locking period
    - Lenders can withdraw their funds once the pool reaches its end date regardless of the time they made the deposit
  - Dynamic pool:
    - Locking period is optional
    - If a lender decides to set a locking period for their deposit, they can select a duration that has a min of 3 months and a max of 12 months, and the rewards are calculated based on the duration and the bonding curve model
- **No Deposit Window:** flexible pools do not have any restrictions on the timeframe within which lenders can make deposits.
- **Dynamic APR and Bonus Rate:** variable annual percentage rate (APR) and bonus rate based on a bonding curve model.

## 📝 Contracts

```bash
Contracts
├─ BondingCurve
│  ├─ Interface
│  │  └─ IBondingCurve.sol
│  └─ BondingCurve.sol
├─ Lender
│  ├─ Interface
│  │  ├─ IFixLender.sol
│  │  └─ IFlexLender.sol
│  ├─ FixLender.sol
│  └─ FlexLender.sol
├─ Strategy
│  ├─ Interface
│  │  ├─ IAaveLendingPool.sol
│  │  └─ IStrategy.sol
│  └─ Strategy.sol
├─ Token
│  ├─ Interface
│  │  └─ IToken.sol
│  └─ Token.sol
└─ Verification
   ├─ Interface
   │  ├─ IPolytradeProxy.sol
   │  └─ IVerification.sol
   ├─ Mock
   │  └─ PolytradeProxy.sol
   └─ Verification.sol
```

## 🛠️ Install Dependencies

```bash
npm install
npx hardhat compile
npx hardhat test
```

## ⚖️ License

All files in `/contracts` are licensed under MIT as indicated in their SPDX header.
