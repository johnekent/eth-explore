// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract ComplementStorage {
    uint storedComplement;

    function set(uint x) public {
        storedComplement = x;
    }

    function get() public view returns (uint) {
        return storedComplement;
    }
}
