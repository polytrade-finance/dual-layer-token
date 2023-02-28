//SPDX-License-Identifier: Unlicense
pragma solidity =0.8.17;

import "hardhat/console.sol";

contract Greeter {
    string private _greeting;

    constructor(string memory greeting_) {
        console.log("Deploying a Greeter with greeting:", greeting_);
        _greeting = greeting_;
    }

    function setGreeting(string memory greeting_) public {
        console.log(
            "Changing greeting from '%s' to '%s'",
            _greeting,
            greeting_
        );
        _greeting = greeting_;
    }

    function greet() public view returns (string memory) {
        return _greeting;
    }
}
