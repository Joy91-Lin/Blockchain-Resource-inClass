pragma solidity ^0.8.17;

contract MintCounterBefore {

  uint256 totalSupply;
  function mint(uint256 amount) public {
    for (uint256 i = 0; i < amount; i++) {
      uint256 id = totalSupply++;
      mintNft(msg.sender, id);
    }
  }

  function mintNft(address _who, uint256 tokenId) public {}
}

contract MintCounterAfter {

  uint256 totalSupply;
  function mint(uint256 amount) public {
    uint256 id = totalSupply;
    for (uint256 i = 0; i < amount;) {
      unchecked {
        ++i;
        ++id;
      }
      mintNft(msg.sender, id);
    }
    totalSupply += amount;
  }

  function mintNft(address _who, uint256 tokenId) public {}
}
// 減少提取state variable的次數，可以減少 gas fee
// add unchecked can reduce gas fee
