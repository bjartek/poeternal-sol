// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.25;

// Test
import { Base_Test } from "test/Base.t.sol";

// Contracts
import { Poeternal } from "src/Poeternal.sol";

contract Poeternal_Test is Base_Test {
  /*//////////////////////////////////////////////////////////////
                                  VARS
    //////////////////////////////////////////////////////////////*/

  Poeternal poeternal;

  uint256 constant TOKEN_ID = 42;
  string constant NAME = "YourView";
  string constant COLOUR = "#F8D6D6";
  string constant AUTHOR = "0xBjartek";
  string constant SOURCE = "How to winn friends and influence people";
  string[4] LINES = [
    "To speak of dreams that they hold dear,",
    "Will bring their joys and passions near.",
    "For when their world is seen through you",
    "A bond is formed, enduring, true."
  ];

  function mint() public {
    vm.startPrank(minter);

    poeternal.mint(alice, TOKEN_ID, NAME, LINES, AUTHOR, SOURCE, COLOUR);
    assertEq(poeternal.ownerOf(TOKEN_ID), alice);
    vm.stopPrank();
  }

  /*//////////////////////////////////////////////////////////////
                                  SETUP
    //////////////////////////////////////////////////////////////*/

  function setUp() public virtual override {
    super.setUp();

    poeternal = new Poeternal(burner, minter);
  }
}
