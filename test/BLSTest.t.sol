// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {Blacklist} from "../src/BLS_NEW.sol";
import {ReportModel} from "../src/utils/BLSModels.sol";

contract BLSTest is Test {
    Blacklist bls;

    address owner = 0x64265cDE28238cFf36fcABc917361dBCd18Ff987;

    function setUp() public {
        bls = new Blacklist();
    }

    function test_reportAddresses_getAllReports() public {
        address[] memory addresses = new address[](3);
        addresses[0] = 0x58172e0b0fFB243D6F691d5b30152b6032f12a06;
        addresses[1] = 0x7DBB4bdCfE614398D1a68ecc219F15280d0959E0;
        addresses[2] = 0x444ab79616b4a790dC7Ffa9cEb8Dc82Cbc47cCDD;
        bytes32[] memory byt = new bytes32[](3);
        byt[0] = 0xcbe633433eee6c07bd6f5a0d54541c81f6e5281c2bdf60001c4e12d8051dafeb;
        byt[1] = 0x50ec052a3705c1d1a4639485ca814596ffa89a41ae4df3edf7bfde20e8577a9c;
        byt[2] = 0x15a9ccd3fbc2dc1a07fa2b6f44bfa189619a672970650ebebc52665fe24c4e5e;

        vm.startPrank(owner);
        bls.reportAddress(ReportModel.UserReport(1, addresses, byt));
        vm.stopPrank();

        assertTrue(bls.isAddressReported(addresses[0]));
        assertTrue(bls.isAddressReported(addresses[1]));
        assertTrue(bls.isAddressReported(addresses[2]));
        ReportModel.ScammerAddressRecord[] memory reports = bls.getAllAddressReports(addresses[0]);

        assertEq(reports.length, 1);
        assertEq(reports[0].to, addresses[0]);
        assertEq(reports[0].txIn, byt[0]);
        assertEq(reports[0].stage, 1);
        assertEq(reports[0].timestamp, block.timestamp);

        ReportModel.TransactionDetails[] memory txs = bls.getAllAddressTransactions(addresses[1]);
        assertEq(txs.length, 1);
        assertEq(txs[0].transactionHash, byt[1]);
        assertEq(txs[0].chainId, 1);
        vm.startPrank(owner);
        ReportModel.ScammerAddressRecord[] memory reports2 = bls.getAllMyReports();
        vm.stopPrank();
        assertEq(reports2.length, 3);
        assertEq(reports2[0].to, addresses[0]);
        assertEq(reports2[0].txIn, byt[0]);
        assertEq(reports2[0].stage, 1);
        assertEq(reports2[0].timestamp, block.timestamp);

        assertEq(reports2[1].to, addresses[1]);
        assertEq(reports2[1].txIn, byt[1]);
        assertEq(reports2[1].stage, 2);
        assertEq(reports2[1].timestamp, block.timestamp);

        assertEq(reports2[2].to, addresses[2]);
        assertEq(reports2[2].txIn, byt[2]);
        assertEq(reports2[2].stage, 3);
        assertEq(reports2[2].timestamp, block.timestamp);
    }

    function getBadPeople(uint256 n) internal returns (address[] memory) {
        address[] memory listOfBadPeople = new address[](n);
        for (uint256 i = 0; i < listOfBadPeople.length; i++) {
            listOfBadPeople[i] = vm.randomAddress();
        }
        return listOfBadPeople;
    }

    function getTxns(uint256 n) internal returns (bytes32[] memory) {
        bytes32[] memory txs = new bytes32[](n);
        for (uint256 i = 0; i < txs.length; i++) {
            txs[i] = bytes32(uint256(vm.randomUint()));
        }
        return txs;
    }

    function test_reportRandomAddresses() public {
        address alice = vm.randomAddress();
        address[] memory listOfBadPeople = getBadPeople(4);
        bytes32[] memory txs = getTxns(4);
        vm.startPrank(alice);
        bls.reportAddress(ReportModel.UserReport(1, listOfBadPeople, txs));
        vm.stopPrank();

        for (uint256 j = 0; j < listOfBadPeople.length; j++) {
            ReportModel.ScammerAddressRecord[] memory reports = bls.getAllAddressReports(listOfBadPeople[j]);
            assertEq(reports.length, 1);
            assertEq(reports[0].to, listOfBadPeople[j]);
            assertEq(reports[0].txIn, txs[j]);
        }
    }

    function test_reportRandom(uint8 n) public {
        for (uint256 i = 0; i < n; i++) {
            test_reportRandomAddresses();
        }
    }

    // Test for input validation
    function testFail_invalidInputLengths() public {
        address[] memory addresses = new address[](1);
        bytes32[] memory byt = new bytes32[](2);

        vm.startPrank(owner);
        try bls.reportAddress(ReportModel.UserReport(1, addresses, byt)) {
            fail();
        } catch Error(string memory reason) {
            assertEq(reason, 'InvalidInput("lengths!=!")');
        }
        vm.stopPrank();
    }

    function testFail_emptyReport() public {
        address[] memory addresses = new address[](0);
        bytes32[] memory byt = new bytes32[](0);

        vm.startPrank(owner);
        try bls.reportAddress(ReportModel.UserReport(1, addresses, byt)) {
            fail();
        } catch Error(string memory reason) {
            assertEq(reason, 'InvalidInput("lengths<0")');
        }
        vm.stopPrank();
    }

    // Test for access control
    function test_expectEmit() public {
        address[] memory addresses = new address[](1);
        addresses[0] = 0x58172e0b0fFB243D6F691d5b30152b6032f12a06;
        bytes32[] memory byt = new bytes32[](1);
        byt[0] = 0xcbe633433eee6c07bd6f5a0d54541c81f6e5281c2bdf60001c4e12d8051dafeb;
        address nonOwner = vm.randomAddress();

        ReportModel.ScammerAddressRecord[] memory reports = new ReportModel.ScammerAddressRecord[](1);
        reports[0] = ReportModel.ScammerAddressRecord(1, addresses[0], byt[0], block.timestamp);
        vm.expectEmit(true, true, true, true);
        emit ReportModel.ScamTransactionReported(addresses[0], byt[0]);
        vm.expectEmit(true, true, true, true);
        emit ReportModel.PublicReportUpdated(reports);
        vm.startPrank(nonOwner);
        bls.reportAddress(ReportModel.UserReport(137, addresses, byt));
        vm.stopPrank();

        // vm.startPrank(nonOwner);
        // try bls.reportAddress(ReportModel.UserReport(1, addresses, byt)) {
        //     fail("Non-owner should not be able to report");
        // } catch Error(string memory reason) {
        //     assertEq(reason, "Ownable: caller is not the owner");
        // }
        // vm.stopPrank();
    }
}
