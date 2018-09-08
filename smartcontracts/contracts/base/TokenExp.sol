pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract TokenExp is ERC20 {
  event LogMint(uint256 amountMinted, uint256 totalCost);
  event LogWithdraw(uint256 amountWithdrawn, uint256 reward);
  event LogBondingCurve(string logString, uint256 value);

  // must be divisible by 2 & at least 14 to accurately calculate cost
  uint8 public bondingCurveDecimals;
  uint256 public poolBalance = 0;

  // shorthand for decimal
  // dec = (10 ** uint256(bondingCurveDecimals));
  uint256 dec;

  // Ratio of sell reward compared to buys
  // Example: If set to 900, you sell your tokens at 90% of the buy value.
  uint256 sellRatioPerMille;

  // multiple is the cost of 1 * multiple tokens
  // multiple will effect accuracy
  // it should be around 10 ** 8 - 10 ** 12 to limit rounding errors
  uint256 public multiple;

  constructor(
      uint256 _bondingCurveDecimals,
      uint _sellRatioPerMille
  )
    public
  {
      bondingCurveDecimals = _bondingCurveDecimals;
      dec = (10 ** uint256(bondingCurveDecimals));
      sellRatioPerMille = _sellRatioPerMille;
  }

  // to compute poolBalance for any given price use integral y = m * 1/3 * x ^ 3
  /**
   * Get price for purchacing tokenAmount of tokens
   * @param tokenAmount token amount param
   * @return {uint} finalPrice
   */
  function getBuyPrice(uint256 tokenAmount) public view returns(uint) {
    uint256 totalTokens = tokenAmount + totalSupply_;

    // With: x = totalTokens / dec
    uint256 finalPrice = multiple * (totalTokens * totalTokens * totalTokens) / ( 3 * dec * dec * dec) - poolBalance;

    return finalPrice;
  }


  /**
   * Get sell price for tokenAmount
   * @param tokenAmount token amount param
   * @return {uint} finalPrice
   */
  function getSellReward(uint256 tokenAmount) public view returns(uint) {
    require(totalSupply_ >= tokenAmount);

    uint256 buyPrice = poolBalance - multiple * totalTokens * totalTokens * totalTokens * 1 / ( 3 * dec * dec * dec);
    uint finalReward = sellRatioPerMille * buyPrice / 1000

    uint ownerPayout = buyPrice - finalReward;
    owner.transfer(ownerPayout);

    return finalReward;
  }


  /**
   * @dev calculates the area under the curve based on amount
   * this should not be needed - the ui should compute amount on the client
   * @return tokenAmount
   */
   function estimateTokenAmountForPrice(uint256 price) public view returns(uint256 tokenAmount) {
     // maximum amount for estimates
     uint8 maxSale = 10 ** 2;
     uint256 currentAmount = (price + poolBalance);
     uint256 newPrice;

     // TODO modify these intervals, as tokens get more expensive, we will want to use smaller intervals
     for (uint8 i = 1; i < maxSale; i++) {
       uint256 totalTokens = i * dec + totalSupply_;
       // TODO check overflow
       // same as totalTokens^3 * multiple^2
       newPrice = (totalTokens * totalTokens / dec) * (totalTokens);
       if (currentAmount < multiple * newPrice / (3 * dec * dec)) {
         break;
       }
     }

     return (i - 1) * d;
   }


  /**
   * @dev default function
   * this is a disrete approximation and shouldn't be used in practice
   * gas price for this one is 128686
   */
  function() public payable {
    uint256 amount = estimateTokenAmountForPrice(msg.value);
    buyTokens(amount);
  }

  /**
   * @dev Buy tokens
   * gas cost ~ $1.5
   * @param tokensToMint tokens we want to buy
   * @return {bool}
   */
  function buyTokens(uint256 wei) public payable returns(bool) {
    uint256 tokenAmount = estimateTokenAmountForPrice(wei);
    uint256 priceForAmount = getBuyPrice(tokenAmount);
    require(msg.value >= priceForAmount, 'Insufficient Ether to buy desired amount of tokens');

    uint256 remainingFunds = msg.value.sub(priceForAmount);
    uint256 usedWei = msg.value.sub(remainingFunds);

    // Send back unspent funds
    if (remainingFunds > 0) {
      msg.sender.transfer(remainingFunds);
      Transfer(0x0, msg.sender, remainingFunds);
    }

    totalSupply_ = totalSupply_.add(tokenAmount);
    balances[msg.sender] = balances[msg.sender].add(tokenAmount);
    poolBalance = poolBalance.add(usedWei);

    LogMint(tokenAmount, usedWei);
    return true;
  }

  /**
   * @dev sell tokesn
   * @param _amountToWithdraw amount of tokens to withdraw
   * @return {bool}
   */
  function sellTokens(uint256 _amountToWithdraw) public returns(bool) {
    require(_amountToWithdraw > 0, 'Cannot sell 0 tokens');
    require(balances[msg.sender] >= _amountToWithdraw, 'Insufficient balance for selling desired amount of tokens');

    uint256 reward = getSellReward(_amountToWithdraw);
    msg.sender.transfer(reward);

    poolBalance = poolBalance.sub(reward);
    balances[msg.sender] = balances[msg.sender].sub(_amountToWithdraw);
    totalSupply_ = totalSupply_.sub(_amountToWithdraw);
    LogWithdraw(_amountToWithdraw, reward);

    return true;
  }
}
