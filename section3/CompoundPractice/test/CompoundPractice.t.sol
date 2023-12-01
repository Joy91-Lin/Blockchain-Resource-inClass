// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { EIP20Interface } from "compound-protocol/contracts/EIP20Interface.sol";
import { CErc20 } from "compound-protocol/contracts/CErc20.sol";
import "test/helper/CompoundPracticeSetUp.sol";
import {Comptroller} from "compound-protocol/contracts/Comptroller.sol";

interface IBorrower {
  function borrow() external;
}

contract CompoundPracticeTest is CompoundPracticeSetUp {
  EIP20Interface public USDC = EIP20Interface(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
  CErc20 public cUSDC = CErc20(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
  address public user;
  uint256 initialBalance;
  IBorrower public borrower;

  function setUp() public override {
    super.setUp();

    // Deployed in CompoundPracticeSetUp helper
    borrower = IBorrower(borrowerAddress);
    vm.makePersistent(address(borrower));

    uint256 forkId = vm.createFork(vm.envString("MAINNET_RPC_URL"));
    vm.selectFork(forkId);
    vm.rollFork(11887768);

    user = makeAddr("User");  

    initialBalance = 10000 * 10 ** USDC.decimals();
    deal(address(USDC), user, initialBalance);

    vm.label(address(cUSDC), "cUSDC");
    vm.label(borrowerAddress, "Borrower");
  }

  function test_compound_mint_interest() public {
    vm.startPrank(user);
    uint256 initAmount = 100 * 10 ** USDC.decimals(); 
    // TODO: 1. Mint some cUSDC with USDC
    USDC.approve(address(cUSDC), initAmount);
    (uint mintStatus) = cUSDC.mint(initAmount);
    assertEq(mintStatus, 0);

    // TODO: 2. Modify block state to generate interest
    vm.roll(block.number + 100);
    // TODO: 3. Redeem and check the redeemed amount
    (uint redeemStatus) = cUSDC.redeem(cUSDC.balanceOf(user));
    assertEq(redeemStatus, 0);

    assertGt(USDC.balanceOf(user), initialBalance);
    console.log("test1 earn amount: ", USDC.balanceOf(user) - initialBalance);
    vm.stopPrank();
  }

  function test_compound_mint_interest_with_borrower() public {
    vm.startPrank(user); 
    uint256 initAmount = 100 * 10 ** USDC.decimals(); 
    // TODO: 1. Mint some cUSDC with USDC
    USDC.approve(address(cUSDC), initAmount);
    (uint mintStatus) = cUSDC.mint(initAmount);
    assertEq(mintStatus, 0);

    // 2. Borrower contract will borrow some USDC
    borrower.borrow();

    // TODO: 3. Modify block state to generate interest
    vm.roll(block.number + 100);

    // TODO: 4. Redeem and check the redeemed amount
    (uint redeemStatus) = cUSDC.redeem(cUSDC.balanceOf(user));
    assertEq(redeemStatus, 0);

    assertGt(USDC.balanceOf(user), initialBalance);
    console.log("test2 earn amount: ", USDC.balanceOf(user) - initialBalance);

    vm.stopPrank();
  }

  function test_compound_mint_interest_with_borrower_advanced() public {
    vm.startPrank(user); 
    uint256 initAmount = 100 * 10 ** USDC.decimals(); 
    // TODO: 1. Mint some cUSDC with USDC
    USDC.approve(address(cUSDC), initAmount);
    (uint mintStatus) = cUSDC.mint(initAmount);
    assertEq(mintStatus, 0);


    address anotherBorrower = makeAddr("Another Borrower");
    // TODO: 2. Borrow some USDC with another borrower
    vm.startPrank(anotherBorrower);
    try_borrower_function(anotherBorrower);
    vm.stopPrank();

    // TODO: 3. Modify block state to generate interest
    vm.roll(block.number + 100);

    // TODO: 4. Redeem and check the redeemed amount
    vm.startPrank(user); 
    (uint redeemStatus) = cUSDC.redeem(cUSDC.balanceOf(user));
    assertEq(redeemStatus, 0);

    assertGt(USDC.balanceOf(user), initialBalance);
    console.log("test3 earn amount: ", USDC.balanceOf(user) - initialBalance);
    vm.stopPrank();
  }

  function try_borrower_function(address borrower) internal {
      EIP20Interface DAI = EIP20Interface(0x6B175474E89094C44Da98b954EedeAC495271d0F);
      CErc20 cDAI = CErc20(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);

      deal(address(DAI), borrower, 10000 * 10 ** DAI.decimals());

      uint256 initAmount = 100 * 10 ** DAI.decimals();
      DAI.approve(address(cDAI), initAmount);
      (uint mintStatus) = cDAI.mint(initAmount);
      assertEq(mintStatus, 0);

      Comptroller comptroller = Comptroller(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);
      address[] memory cTokens = new address[](1);
      cTokens[0] = address(cDAI);
      comptroller.enterMarkets(cTokens);

      cUSDC.borrow(1000 * 10 ** cUSDC.decimals());
  }
}
