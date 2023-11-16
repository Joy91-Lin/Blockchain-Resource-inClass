pragma solidity ^0.8.17;

contract CallmeBefore {
  function callme() public {}
}
contract CallmeAfter {
  function callme() public payable {}
}
// add payable can reduce gas fee