// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {EazePay} from "../src/EazePayToken.sol";

contract EazePaTest is Test {
    EazePay public eazepay;

    function setUp() public {
        eazepay = new EazePay("Eazepay", "Epy");
        
    }

    
}
