// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

contract Slots {

  function _setSlotToUint256(bytes32 _slot, uint256 value) internal {
    assembly {
      sstore(_slot, value)
    }
  }

  function _setSlotToAddress(bytes32 _slot, address value) internal {
    assembly {
      sstore(_slot, value)
    }
  }

  function _getSlotToAddress(bytes32 _slot) internal view returns (address value) {
    assembly {
      value := sload(_slot)
    }
  }
}

contract SlotsManipulate is Slots {

  function setAppworksWeek8(uint256 amount) external {
    // TODO: set AppworksWeek8
    bytes32 b = keccak256("appworks.week8");
    _setSlotToUint256(b, amount);
  }

  function setProxyImplementation(address _implementation) external {
    // TODO: set Proxy Implenmentation address
    bytes32 b = bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1);
    _setSlotToAddress(b, _implementation);
  }

  function setBeaconImplementation(address _implementation) external {
    // TODO: set Beacon Implenmentation address
    bytes32 b = bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1);
    _setSlotToAddress(b, _implementation);
  }

  function setAdminImplementation(address _who) external {
    // TODO: set Admin Implenmentation address
    bytes32 b = bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1);
    _setSlotToAddress(b, _who);
  }

  function setProxiable(address _implementation) external {
    // TODO: set Proxiable Implenmentation address
    bytes32 b = keccak256("PROXIABLE");
    _setSlotToAddress(b, _implementation);
  }
}