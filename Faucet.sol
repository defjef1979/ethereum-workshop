pragma solidity ^0.4.24;

contract Faucet {
    function withdraw1Ether() public {
        // Insert your code here
    }

    function faucetBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // This function makes it possible for the contract to receive ether
    function() public payable { }
}
