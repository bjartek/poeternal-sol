// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

// Tests
import { Poeternal_Test } from "./Poeternal.t.sol";

// Interfaces
import { IPoeternal } from "src/interfaces/IPoeternal.sol";

// Libraries
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

contract Poeternal_mint is Poeternal_Test {
  /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/

  error AccessControlUnauthorizedAccount(address, bytes32);
  error TokenAlreadyMinted();
  error InvalidVariant(string variant);
  error ERC721InvalidSender(address);

  /*//////////////////////////////////////////////////////////////
                               LIBRARIES
    //////////////////////////////////////////////////////////////*/

  using Strings for uint256;

  function setUp() public override {
    super.setUp();
    mint();
  }

  /*//////////////////////////////////////////////////////////////
                                   TESTS
    //////////////////////////////////////////////////////////////*/

  function test_getName() public view {
    string memory name = poeternal.getName(TOKEN_ID);
    assertEq(name, "YourView", "getName should return the correct name");
  }
}
