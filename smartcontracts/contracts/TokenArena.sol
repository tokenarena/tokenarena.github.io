pragma solidity ^0.4.24;

import "base/TokenExp.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract TokenArena is TokenExp, Ownable {

  // Name of user or token arena
  string name;
  Controller controller;

  bool votingIsOpen;
  uint[] optionStakes;
  bytes[] options;
  mapping(address => uint) public lockedUntil;
  uint lockingPeriod = 1 day; // 3600 * 24

  constructor(address _controllerAddress, string _name)
    TokenExp(18, 900) // 18 as bondingCurveDecimals, 90% sell curve (10% penalty compared to buys)
  {
    controller = Controller(_controllerAddress);
    controller.registerTokenArea(address(this), _name);

    name = _name;
  }

  function vote(uint256 _optionIndex) external {
    require(votingIsOpen, 'Voting is not open');
    require(_optionIndex < options.length, 'Invalid option');
    require(now < lockedUntil[msg.sender]);

    optionStakes[_optionIndex] = optionStakes[_optionIndex] + balance[msg.sender];
    lockedUntil[msg.sender] = now + lockingPeriod;


  }

  function createVote(bytes[] _options) external onlyOwner {

  }

  function resolve(uint _winnerIndex) external onlyOwner {

  }

  function buy() public payable returns(bool) {
    // Users can buy all the time. Also when locked.
    return buyTokens(msg.value);
  }

  function sell(uint256 _amount) public returns(bool) {
    require(now < lockedUntil[msg.sender]);
    return sellTokens(_amount);
  }
}
