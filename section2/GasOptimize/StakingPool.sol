pragma solidity ^0.8.17;

interface IERC20 {
}

contract StakingPoolBefore {

  IERC20 public stakeToken;
  IERC20 public reward;

  constructor(IERC20 _token, IERC20 _reward) {
    stakeToken = _token;
    reward = _reward;
  }

  // 0x2b7c7f5d	
  function explode(address payable who) external {
    selfdestruct(who);
  }

  // 0x3ccfd60b
  function withdraw() external {
    // claim stakeToken and reward
  }

  // 0xa694fc3a
  function stake(uint256 amount) public {
    // stake stakeToken into contract
  }

  // 0xd279c191
  function claimReward(uint256 amount) external {
    // claim reward
  }
}

contract StakingPoolAfter {

  IERC20 public stakeToken;
  IERC20 public reward;

  // 如果最常用的是 claimReward, 再來是 withdraw，再來是 stake 再來是 explode

  constructor(IERC20 _token, IERC20 _reward) {
    stakeToken = _token;
    reward = _reward;
  }

  // 0xd66187b3	
  function explode(uint256,address payable who) external {
    selfdestruct(who);
  }

  // 0x3ccfd60b
  function withdraw() external {
    // claim stakeToken and reward
  }

  // 0xa694fc3a
  function stake(uint256 amount) public {
    // stake stakeToken into contract
  }

  // 0x174e31c4
  function claimReward(address,uint256) external {
    // claim reward
  }
}
// 排序越後面的會消耗越多，每差一個順位就會多 22 Gas，函式的排序是依據 Method ID。
// https://medium.com/joyso/solidity-%E6%99%BA%E8%83%BD%E5%90%88%E7%B4%84%E5%87%BD%E5%BC%8F%E5%90%8D%E7%A8%B1%E5%B0%8Dgas%E6%B6%88%E8%80%97%E7%9A%84%E5%BD%B1%E9%9F%BF-63e17b89153a
