// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.25 <0.9.0;

import { Poeternal } from "../src/Poeternal.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
  address private immutable ADMIN_ADDRESS = vm.envAddress("ADMIN_ADDRESS");
  address private immutable MINTER_ADDRESS = vm.envAddress("MINTER_ADDRESS");

  function run() public broadcast returns (address) {
    Poeternal poeternal = new Poeternal(ADMIN_ADDRESS, MINTER_ADDRESS);
    return address(poeternal);
  }
}
