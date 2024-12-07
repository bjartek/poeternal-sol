// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.25;

// Dependencies
import { Test } from "forge-std/src/Test.sol";

/// @notice An abstract base test contract that provides common test logic.
abstract contract Base_Test is Test {
    /*//////////////////////////////////////////////////////////////
                                 USERS
    //////////////////////////////////////////////////////////////*/

    address payable public admin;
    address payable public alice;
    address payable public bob;
    address payable public carol;
    address payable public pauser;
    address payable public bridge;
    address payable public minter;
    address payable public burner;

    /*//////////////////////////////////////////////////////////////
                                 SETUP
    //////////////////////////////////////////////////////////////*/

    function setUp() public virtual {
        // Create the admin address.
        admin = payable(makeAddr("admin"));
        // Label the admin address.
        vm.label(admin, "admin");
        // Create the alice address.
        alice = payable(makeAddr("alice"));
        // Label the alice address.
        vm.label(alice, "alice");
        // Create the bob address.
        bob = payable(makeAddr("bob"));
        // Label the bob address.
        vm.label(bob, "bob");
        // Create the carol address.
        carol = payable(makeAddr("carol"));
        // Label the carol address.
        vm.label(carol, "carol");
        // Create the pauser address.
        pauser = payable(makeAddr("pauser"));
        // Label the pauser address.
        vm.label(pauser, "pauser");
        // Create the bridge address.
        bridge = payable(makeAddr("bridge"));
        // Label the bridge address.
        vm.label(bridge, "bridge");
        // Create the minter address.
        minter = payable(makeAddr("minter"));
        // Label the minter address.
        vm.label(minter, "minter");

        burner = payable(makeAddr("burner"));
        // Label the minter address.
        vm.label(minter, "burner");
    }
}
