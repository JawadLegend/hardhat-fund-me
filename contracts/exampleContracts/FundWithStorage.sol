// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FundWithStoarge {
    uint256 favoriteNumber; // store at slot 0
    bool someBool; // stored at slot 1
    uint256[] myArray; /* Array Legth stored at slot 2,
    but the objects will be the keccak256(2),
     since 2 is the storage slot of the array */
     mapping(uint256 => bool) myMap; /* An empty slot help at slot 3
     and the elements will b stored at keccak256(h(k) . p)

     p: The storage slot (aka, 3)
     k: The key in hex
     h: Some function based o the type. For uint256, it jus pads the hex
     */

     uint256 constant NOT_IN_STORAGE = 123;
     uint256 immutable i_not_in_storage;

     constructor () {
        favoriteNumber = 25; //See stored spot above // SSTORE
        someBool = true; // see stored spot above // SSTORE
        myArray.push(222); // SSTORE
        myMap[0] = true; // SSTORE
        i_not_in_storage = 123;
     }
        function doStuff() public {
            uint256 newVar = favoriteNumber + 1;//SLOAD
            bool otherVar = someBool; //SLOAD
            // ^^ memory variables        
    }
  }

