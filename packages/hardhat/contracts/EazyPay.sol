// // SPDX-License-Identifier: MIT License
// pragma solidity ^0.8.19;
// import "@chainlink/contracts/src/v0.8/VRFConsumer.sol";
// import "IEazeToken.sol";

// contract EasePay is VRFConsumer, IEazeToken {

//     struct Users {
        
//     }

//     uint256 private randomNumber;

//     constructor(
//         address _vrfCoordinator,
//         address _linkToken
//     ) VRFConsumer(_vrfCoordinator, _linkToken) {}

//     function getRandomNumber() public returns (uint256) {
//         if (randomNumber == 0) {
//             // Request a random number from Chainlink VRF.
//             bytes32 requestId = requestRandomNumber();

//             // Wait for the request to be fulfilled.
//             fulfillRandomNumber(requestId);
//         }

//         return randomNumber;
//     }

//     function fulfillRandomNumber(bytes32 requestId) internal {
//         // Get the random number from the fulfillment.
//         uint256 randomNumber = uint256(fulfillment.randomNumber);

//         // Store the random number.
//         this.randomNumber = randomNumber;
//     }
// }