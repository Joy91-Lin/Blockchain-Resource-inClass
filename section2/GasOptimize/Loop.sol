pragma solidity ^0.8.17;

contract DoWhileBefore {
  function go() public pure {
    uint16 i;
    do {
      unchecked {
        ++i;
      }
    } while (i < 200);
  }
}

contract DoWhileAfter {
  function go() public pure {
    uint256 i;
    do {
      unchecked {
        ++i;
      }
    } while (i < 200);
  }
}
// uint16->uint256 補滿所有的位元可以減少 gas fee
