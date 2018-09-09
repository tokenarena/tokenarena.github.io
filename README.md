

Token economics
---------------

Buy curve: `f(x1) = x1^2`

Sell curve: `f(x2) = 0.9x2^2`

This creates the incentives to hold tokens and not immediately dump them after purchase. Example: If you invest 1 Ether that buys you 1000 tokens and you decide to immediately sell your tokens again, you only don't get 1 Ether back but significantly less. The ratio equals to the area ratios of the respective integrals of both buy and sell curves at `x = 1000` (1000 tokens).

**Current parameters yield the following median prices (@200eur/eth):**
- 1 token: < 0.0001c
- 1000 tokens: 0.66eur (the 1001st token costs 2eur)
- 1000000 tokens: 5292000eur


Deploy smart contracts
----------------------

Inside `/smartcontracts`, run the following command to deploy on the Ropsten test network

```
truffle migrate --network ropsten --reset
```

Keynote presentation:
https://drive.google.com/open?id=1ZpGVhzhD0b7aZYjKrCDBWvc5f8a9E6DT
