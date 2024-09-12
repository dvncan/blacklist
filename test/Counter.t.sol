// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {console} from "lib/forge-std/src/console.sol";
import {Counter} from "../src/Counter.sol";
import {BlackList, Proof} from "src/blacklist.sol";

contract CounterTest is Test {
    BlackList public contr;
    address owner;
    address mod1;
    address bing;
    Proof.BannedRecord badThing;

    function setUp() public {
        mod1 = address(0xDEfbAaE321);
        owner = address(0xffff);
        badThing = Proof.BannedRecord(
            bing,
            Proof.Status(0x1),
            10,
            bytes32("duncan fucked up")
        );
        bing = address(0xd);
        vm.startPrank(owner);
        contr = new BlackList();
        contr.addMod(mod1);
    }

    function test_Increment(address bad) public {
        contr.addToList(badThing, bad);
        assertEq(contr.totalNumber(), 1, "fail");
        assertEq(contr.blackListAddress(bad), address(bad), "fail");
        assertEq(contr.blackList(bad), true, "fail");
        // assertEq(
        //     contr.reason ==
        //         Proof.BannedRecord(
        //             bing,
        //             Proof.Status(0x1),
        //             10,
        //             bytes32("duncan fucked up")
        //         ),
        //     true,
        //     "fail"
        // );
        assertEq(contr.whyBanned(bad), bytes32("duncan fucked up"), "fail");
        assertEq(contr.whenBanned(bad), 10, "Fail");
        // assertEq(contr.getStatus(bad), Proof.Status(0x1), "Fail");
    }

    function test_mythings() public {
        // bytes32 me = ;
        // string memory you = ;

        // console.log(you);
        // console.log(me);
        console.logString(
            contr.returnToString(
                "0x64756e63616e206675636b656420757000000000000000000000000000000000"
            )
        );
        console.logBytes32(contr.getProofBytes("duncan fucked up"));
        console.CONSOLE_ADDRESS;

        // assertEq(me, ("0x64756e63616e206675636b6564207570"), "fail");
        // console2_log_StdCheats(p0);
        // console2_log_StdCheats(me);
    }

    // function testFuzz_SetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
