pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract TokenLin is StandardToken {
  event LogMint(uint256 amountMinted, uint256 totalCost);
  event LogWithdraw(uint256 amountWithdrawn, uint256 reward);
  event LogBondingCurve(string logString, uint256 value);

  // must be divisible by 2 & at least 14 to accurately calculate cost
  uint8 public bondingCurveDecimals;
  uint256 public poolBalance = 0;

  // shorthand for decimal
  // dec = (10 ** uint256(bondingCurveDecimals));
  uint256 dec;

  // multiple is the cost of 1 * multiple tokens
  // multiple will effect accuracy
  // it should be around 10 ** 8 - 10 ** 12 to limit rounding errors
  uint256 public multiple;


 // to compute poolBalance for any given price use integral y = m * 1/2 * x ^ 2
  /**
   * Get price for purchacing tokenAmount of tokens
   * @param tokenAmount token amount param
   * @return {uint} finalPrice
   */
  function getBuyPrice(uint256 tokenAmount) public view returns(uint) {
    uint256 totalTokens = tokenAmount + totalSupply_;

    // With: x = totalTokens / dec
    uint256 finalPrice = multiple * totalTokens * totalTokens / ( 2 * dec * dec ) - poolBalance;

    return finalPrice;
  }


  /**
   * Get sell price for tokenAmount
   * @param tokenAmount token amount param
   * @return {uint} finalPrice
   */
  function getSellReward(uint256 tokenAmount) public view returns(uint) {
    require(totalSupply_ >= tokenAmount);

    uint256 newTotalTokens = totalSupply_ - tokenAmount;
    uint256 finalPrice = poolBalance - multiple * newTotalTokens * newTotalTokens / (2 * dec * dec);

    return finalPrice;
  }


  /**
   * @dev calculates the area under the curve based on amount
   * this should not be needed - the ui should compute amount on the client
   * @return tokenAmount
   */
  function estimateTokenAmountForPrice(uint256 price) public view returns(uint256 tokenAmount);


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
  function buyTokens(uint256 tokensToMint) public payable returns(bool) {
    uint256 priceForAmount = getBuyPrice(tokensToMint);
    require(msg.value >= priceForAmount);

    uint256 remainingFunds = msg.value.sub(priceForAmount);
    uint256 usedWei = msg.value.sub(remainingFunds);

    // Send back unspent funds
    if (remainingFunds > 0) {
      msg.sender.transfer(remainingFunds);
      Transfer(0x0, msg.sender, remainingFunds);
    }

    totalSupply_ = totalSupply_.add(tokensToMint);
    balances[msg.sender] = balances[msg.sender].add(tokensToMint);
    poolBalance = poolBalance.add(usedWei);

    LogMint(tokensToMint, usedWei);
    return true;
  }

  /**
   * @dev sell tokesn
   * @param _amountToWithdraw amount of tokens to withdraw
   * @return {bool}
   */
  function sellTokens(uint256 _amountToWithdraw) public returns(bool) {
    require(_amountToWithdraw > 0 && balances[msg.sender] >= _amountToWithdraw);

    uint256 reward = getSellReward(_amountToWithdraw);
    msg.sender.transfer(reward);

    poolBalance = poolBalance.sub(reward);
    balances[msg.sender] = balances[msg.sender].sub(_amountToWithdraw);
    totalSupply_ = totalSupply_.sub(_amountToWithdraw);
    LogWithdraw(_amountToWithdraw, reward);

    return true;
  }

  /**
   * @dev calculetes amount of tokens to mint for give Eth amount
   * based on the area under the curve based on amount
   * area = m * 1/2 * x ^ 2 <- total price of all tokens
   * we can dervive
   * poolBalance + msg.value = m * 1/2 * (totalSupply_ + newTokens) ^ 2
   * first we figure out how many tokens to mint
   * 2 * (poolBalance + msg.value)^1/2 = m * (totalSupply_ + newTokens)
   * @param price - this is the amount user is willing to pay for new tokens
   * @return tokenAmount
   */
  function estimateTokenAmountForPrice(uint256 price) public view returns(uint256 tokenAmount) {
    uint256 newTotal = sqrt((price + poolBalance) * 2 / multiple) * dec;
    return newTotal;
  }

  function sqrt(uint256 x) public pure returns (uint256 y) {
    uint256 z = (x + 1) / 2;
    y = x;
    while (z < y) {
      y = z;
      z = (x / z + z) / 2;
    }
  }
}
