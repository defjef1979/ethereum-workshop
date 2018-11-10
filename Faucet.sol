pragma solidity ^0.4.24;

import './ChocolateMaster.sol';

contract Faucet {
    function withdrawEther() public {
        // Insert your code here
    }

    function faucetBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // This function makes it possible for the contract to receive ether
    function() public payable { }
}
