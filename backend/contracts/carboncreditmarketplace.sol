// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CarbonCredits {
    struct Credit {
        uint id;
        address owner;
        uint amount; // Amount of carbon credits
        string ipfsHash; // IPFS hash of the credit document
    }

    uint public nextCreditId;
    mapping(uint => Credit) public credits;

    // Issue carbon credits to a buyer
    function issueCredits(address _owner, uint _amount, string memory _ipfsHash) public {
        credits[nextCreditId] = Credit(nextCreditId, _owner, _amount, _ipfsHash);
        nextCreditId++;
    }

    // Transfer carbon credits to another user
    function transferCredits(uint _creditId, address _newOwner) public {
        require(credits[_creditId].owner == msg.sender, "Not the owner");
        credits[_creditId].owner = _newOwner;
    }

    // Retrieve credit details
    function getCredit(uint _creditId) public view returns (Credit memory) {
        return credits[_creditId];
    }
}
