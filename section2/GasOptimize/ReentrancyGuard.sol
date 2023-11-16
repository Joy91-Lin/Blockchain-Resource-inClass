pragma solidity ^0.8.17;

contract ReentrancyGuardBefore {
  uint256 private _status;
  modifier _nonReentrant() {
    require(_status != 1, "ReentrancyGuard: reentrant call");
    _status = 1;
    _;
    _status = 0;
  }
  function funcA() public _nonReentrant {}
  function funcB() public _nonReentrant {}
  function funcC() public _nonReentrant {}
}

contract ReentrancyGuardAfter {
  uint256 private _status;

  constructor() {
    _status = 1;
  }

  modifier _nonReentrant() {
    require(_status != 2, "ReentrancyGuard: reentrant call");
    _status = 2;
    _;
    _status = 1;
  }
  function funcA() public _nonReentrant {}
  function funcB() public _nonReentrant {}
  function funcC() public _nonReentrant {}
}

// state variable的初始值從0改成1會使用更多的gas
// 故這裡者status用1,2來表示，會比較省gas