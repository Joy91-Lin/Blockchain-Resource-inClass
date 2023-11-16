// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { Test, console } from "forge-std/Test.sol";
import { UUPSProxy } from "../src/UUPSProxy.sol";
import { UUPSMultiSigWallet } from "../src/UUPS/UUPSMultiSigWallet.sol";
import { UUPSMultiSigWalletV2 } from "../src/UUPS/UUPSMultiSigWalletV2.sol";
import { MultiSigWallet, MultiSigWalletV2 } from "../src/MultiSigWallet/MultiSigWalletV2.sol";

contract NoProxiableContract {}

contract UUPSTest is Test {

  address public admin = makeAddr("admin");
  address public alice = makeAddr("alice");
  address public bob = makeAddr("bob");
  address public carol = makeAddr("carol");
  address public receiver = makeAddr("receiver");

  UUPSProxy proxy;
  UUPSMultiSigWallet wallet;
  UUPSMultiSigWalletV2 walletV2;
  UUPSMultiSigWallet proxyWallet;
  UUPSMultiSigWalletV2 proxyWalletV2;

  function setUp() public {
    vm.startPrank(admin);
    wallet = new UUPSMultiSigWallet();
    walletV2 = new UUPSMultiSigWalletV2();
    proxy = new UUPSProxy(
      abi.encodeWithSelector(wallet.initialize.selector, [alice, bob, carol]),
      address(wallet)
    );
    vm.stopPrank();
  }

  function test_UUPS_updateCodeAddress_success() public {
    // TODO:
    // 1. check if proxy is correctly proxied,  assert that proxyWallet.VERSION() is "0.0.1"
    // 2. upgrade to UUPSMultiSigWalletV2 by calling updateCodeAddress
    // 3. assert that proxyWallet.VERSION() is "0.0.2"
    // 4. assert updateCodeAddress is gone by calling updateCodeAddress with low-level call or UUPSMutliSigWallet
    vm.startPrank(admin);
    proxyWallet = UUPSMultiSigWallet(address(proxy));
    assertEq(proxyWallet.VERSION(), "0.0.1");

    proxyWallet.updateCodeAddress(address(walletV2), "");
    proxyWalletV2 = UUPSMultiSigWalletV2(address(proxy));
    assertEq(proxyWalletV2.VERSION(), "0.0.2");

    // low-level call
    NoProxiableContract noProxiableContract = new NoProxiableContract();
    vm.expectRevert();
    address(proxyWalletV2).call(
    abi.encodeWithSignature("updateCodeAddress(address,bytes)", address(noProxiableContract), "")
    );

    // UUPSMutliSigWallet
    // vm.expectRevert();
    // proxyWallet.updateCodeAddress(address(walletV2), abi.encodeWithSelector(walletV2.v2Initialize.selector));


    vm.stopPrank();
    
  }

  function test_UUPS_updateCodeAddress_revert_if_no_proxiableUUID() public {
    // TODO:
    // 1. deploy NoProxiableContract
    // 2. upgrade to NoProxiableContract by calling updateCodeAddress, which should revert
    vm.startPrank(admin);
    NoProxiableContract noProxiableContract = new NoProxiableContract();
    proxyWallet = UUPSMultiSigWallet(address(proxy));
    vm.expectRevert();
    proxyWallet.updateCodeAddress(address(noProxiableContract), "");
    vm.stopPrank();
  }
}