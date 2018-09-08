pragma solidity ^0.4.24;

import "base/TokenExp.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract TokenArena is TokenExp, Ownable {

  // Name of user or token arena
  string public name;
  Controller public controller;

  bool public votingIsOpen;
  uint public votingStartsAt;
  uint[] public optionStakes;
  bytes[] public options;
  uint public isWinnerChosen = true; // initialize to true so that initial `createVote()` succeeds
  uint public winnerOptionIndex;
  mapping(address => uint) public lockedUntil;
  uint public lockingPeriod = 1 day; // 3600 * 24

  constructor(address _controllerAddress, string _name)
    TokenExp(18, 900) // 18 as bondingCurveDecimals, 90% sell curve (10% penalty compared to buys)
  {
    controller = Controller(_controllerAddress);
    controller.registerTokenArea(address(this), _name);

    name = _name;
  }

  function vote(uint256 _optionIndex) external returns (bool) {
    require(votingStartsAt <= now && votingStartsAt != 0, 'Voting is not open or no voting exists');
    require(_optionIndex < options.length, 'Invalid option');
    require(now < lockedUntil[msg.sender], 'User is locked');

    optionStakes[_optionIndex] = optionStakes[_optionIndex] + balance[msg.sender];
    lockedUntil[msg.sender] = now + lockingPeriod;

    return true;
  }

  function createVote(uint _startsAt, bytes[] _options) external onlyOwner returns (bool) {
    require(_startsAt > now, 'Voting must be in the future');
    require(isWinnerChosen == true, 'Previous voting is still running');

    votingStartsAt = _startsAt;
    options = _options;
    isWinnerChosen = false;

    return true;
  }

  function resolve(uint _winnerIndex) external onlyOwner returns (true) {
    require(_winnerIndex < options.length);
    require(isWinnerChosen == false, 'Winner already chosen or no voting to resolve')

    votingStartsAt = 0;
    winnerOptionIndex = _winnerIndex;
    isWinnerChosen = true;

    // TODO: any payouts/incentivation happening here?

    return true;
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
