pragma solidity ^0.4.24;

import './ChocolateToken.sol';
import './Faucet.sol';

contract ChocolateMaster {
    event ChocolateTokenCreated(ChocolateToken token);

    uint private TOTAL_CHOCOLATE_TOKENS = 40;
    string private BASIC_INCOME = 'BASIC_INCOME';
    string private CONTRACT_HAS_ETHER = 'CONTRACT_HAS_ETHER';
    string private CAN_WITHDRAW_ETHER_FROM_CONTRACT = 'CAN_WITHDRAW_ETHER_FROM_CONTRACT';
    string private FAUCET_CAN_INITIATE_WITHDRAW = 'FAUCET_CAN_INITIATE_WITHDRAW';

    mapping (string => mapping (address => bool)) private retrieved;
    bool private bonusTokenRetrieved = false;
    ChocolateToken public token;

    constructor() public {
        token = new ChocolateToken(TOTAL_CHOCOLATE_TOKENS);
    }

    // Call this to get a 'basic income' chocolate token
    function getBasicChocolateIncome() public {
        require(retrieved[BASIC_INCOME][msg.sender] == false);

        retrieved[BASIC_INCOME][msg.sender] = true;
        token.transfer(msg.sender, 1);
    }

    // Call this to prove that your faucet has ether and get a chocolate token
    function proveThatFaucetHasEther(Faucet faucet) public {
        require(retrieved[CONTRACT_HAS_ETHER][msg.sender] == false);
        require(address(faucet).balance > 0);

        retrieved[CONTRACT_HAS_ETHER][msg.sender] = true;
        token.transfer(msg.sender, 1);
    }

    // Call this to prove that ether can be withdrawn from your faucet and get one
    // chocolate token
    function proveThatEtherCanBeWithdrawn(Faucet faucet) public {
        require(retrieved[CAN_WITHDRAW_ETHER_FROM_CONTRACT][msg.sender] == false);

        retrieveOneEther(faucet);

        retrieved[CAN_WITHDRAW_ETHER_FROM_CONTRACT][msg.sender] = true;
        token.transfer(msg.sender, 1);
    }

    // Bonus: Make your faucet contract itself call this method in order to make it
    // withdraw some ether. Get a bonus chocolate token. Just the first one to call this
    // gets this token.
    function faucetInitiatesWithdraw() public {
        if (!bonusTokenRetrieved)
            return;

        retrieveOneEther(Faucet(msg.sender));

        bonusTokenRetrieved = true;
        token.transfer(msg.sender, 1);
    }

    function retrieveOneEther(Faucet faucet) private {
        uint initialBalance = address(this).balance;
        faucet.withdraw1Ether();
        uint newBalance = address(this).balance;
        require(newBalance - initialBalance == 1 ether);
    }
}
