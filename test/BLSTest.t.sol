// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {BLS, Report, Record} from "../src/BLS.sol";

contract BLSTest is Test {
    BLS bls;

    function setUp() public {
        bls = new BLS();
    }

    uint40 sds;
    uint24 wds;

    uint32 sdsd = 1;

    function test_reportAddress() public {
        address addr = address(0x123);
        string[] memory report = new string[](1);
        report[0] = "report";
        bls.reportAddress(addr, report);
        assertTrue(bls.isReported(addr));
    }
}
