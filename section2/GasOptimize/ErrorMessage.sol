pragma solidity ^0.8.17;

contract ErrorMessageBefore {
  function I_am_a_revert_function(uint256 a, uint256 b) public pure {
    require(
      a > b || a == b,
      "I am a revert function, i revert everything"
    );
  }
}

error RevertWhenAIsGreaterOrEqualToB();
contract ErrorMessageAfter {
  function I_am_a_revert_function(uint256 a, uint256 b) public pure {
    if (a < b) {
      revert RevertWhenAIsGreaterOrEqualToB();
    }
  }
}

// require回傳字串長度也會影響 gas fee
// 使用 error event可以減少 gas fee