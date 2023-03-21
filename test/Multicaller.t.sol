// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Callee} from "src/Callee.sol";

contract MulticallerTest is Test {
    Multicaller public multicaller;
    Callee public callee;

    function setUp() public {
        multicaller = Multicaller(HuffDeployer.deploy("Multicaller"));
        callee = new Callee();
    }

    function testMulticallRetValues() public {
        bytes[] memory calldatas = new bytes[](4);
        address[] memory targets = new address[](4);

        calldatas[0] = abi.encodeWithSelector(Callee.toBeCalled.selector, 10, 15);
        calldatas[1] = abi.encodeWithSelector(Callee.toBeCalled.selector, 10, 16);
        calldatas[2] = abi.encodeWithSelector(Callee.toBeCalled.selector, 10, 17);
        calldatas[3] = abi.encodeWithSelector(Callee.toBeCalled.selector, 10, 18);

        targets[0] = address(callee);
        targets[1] = address(callee);
        targets[2] = address(callee);
        targets[3] = address(callee);

        bytes[] memory callsRes = multicaller.multicall(calldatas, targets);

        assertEq(uint256(bytes32(callsRes[0])), 25);
        assertEq(uint256(bytes32(callsRes[1])), 26);
        assertEq(uint256(bytes32(callsRes[2])), 27);
        assertEq(uint256(bytes32(callsRes[3])), 28);
    }
}

interface Multicaller {
    function multicall(bytes[] calldata, address[] calldata) external returns (bytes[] memory);
}
