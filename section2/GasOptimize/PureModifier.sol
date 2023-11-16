// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

error NotOwner();

contract PureModifierBefore {
    address owner;

    modifier checkOwner() {
        if (msg.sender == owner) {
            revert NotOwner();
        }
        _;
    }

    function funcA() public checkOwner {}

    function funcB() public checkOwner {}

    function funcC() public checkOwner {}
}

contract PureModifierAfter1 {
    address owner;

    function _checkOwner() internal view {
        if (msg.sender == owner) {
            revert NotOwner();
        }
    }

    function funcA() public {
        _checkOwner();
    }

    function funcB() public {
        _checkOwner();
    }

    function funcC() public {
        _checkOwner();
    }
}

contract PureModifierAfter2 {
    address owner;

    modifier checkOwner() {
        _checkOwner();
        _;
    }

    function _checkOwner() internal view {
        if (msg.sender == owner) {
            revert NotOwner();
        }
    }

    function funcA() public checkOwner {}

    function funcB() public checkOwner {}

    function funcC() public checkOwner {}
}

// 因為modifier會被複製到每個function裡面
// 所以要省gas的話可以用
// 1.function來取代modifier
// 2.把modifier要做的事包成一個function，然後在modifier裡面呼叫這個function