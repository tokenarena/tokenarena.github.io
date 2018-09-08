pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract Controller is Ownable {

  address[] public tokenArenas;
  mapping(address => uint) public indexes;

  function registerTokenArena(address _tokenArenaAddress, string _name)
    public
  {
    require(isContract(_tokenArenaAddress)); // TODO: harder checks

    tokenArenas[tokenArenas.length] = _tokenArenaAddress;
  }

  function unregisterTokenArena(address _tokenArenaAddress)
    onlyOwner
    public
  {

    // swap deleted token arena with last token arena in `tokenArenas` list
    uint swappedIndex = indexes[_tokenArenaAddress];
    require(tokenArenas[swappedIndex] != address(0));

    indexes[_tokenArenaAddress] = 0;
    address lastArena = tokenArenas[tokenArenas.length - 1];
    tokenArenas[swappedIndex] = lastArena;
    indexes[lastArena] = swappedIndex;
    tokenArenas.length--;
  }

  /**
   * Convenience functions
   */
  function getNumberTokenArenas() public view returns (uint) {
    return tokenArenas.length;
  }

  function getTokenArenaAtIndex(uint _index) public view returns (address) {
      require(_index < tokenArenas.length);
      return tokenArenas[_index];
  }

  function isContract(address _address) private returns (bool){
    uint32 size;
    assembly {
      size := extcodesize(_address)
    }
    return (size > 0);
  }
}
