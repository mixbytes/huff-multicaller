// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

contract Callee {

    function toBeCalled(uint256 a, uint256 b) public returns(uint256) {
        return a + b;
    }

}