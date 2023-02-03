// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.17 and less than 0.9.0
pragma solidity ^0.8.0;

//
//In this contract, buyer, seller, and arbitrator are the addresses of the participants involved in the transaction.
//The amount and deadline variables store the agreed amount and the deadline for the transaction, respectively.
//The state variable keeps track of the current state of the transaction, which can be one of Created, Funded, Released, or Refunded.

//The contract's functions allow for the following actions to be taken:

//The fund function allows the buyer to fund the escrow with the agreed amount.

//The release function allows the arbitrator to release the funds to the seller.

//The refund function allows the arbitrator to refund the funds to the buyer if the deadline has passed and the funds have not been released.

//This contract serves as a simple example of how smart contracts can be used to create decentralized, trustless services that eliminate the need for intermediaries.


contract Escrow {

    address payable buyer;
    address payable seller;
    address payable arbitrator;

    uint public amount;
    uint public deadline;

    enum State { Created, Funded, Released, Refunded }
    State public state;

    constructor(address _buyer, address _seller, address _arbitrator, uint _amount, uint _deadline) public {
        buyer = _buyer;
        seller = _seller;
        arbitrator = _arbitrator;
        amount = _amount;
        deadline = _deadline;
        state = State.Created;
    }

    function fund() public payable {
        require(msg.sender == buyer, "Only the buyer can fund the escrow");
        require(state == State.Created, "The escrow must be in the created state");
        require(msg.value == amount, "The amount funded must match the agreed amount");
        state = State.Funded;
    }

    function release() public {
        require(msg.sender == arbitrator, "Only the arbitrator can release the funds");
        require(state == State.Funded, "The escrow must be in the funded state");
        seller.transfer(amount);
        state = State.Released;
    }

    function refund() public {
        require(msg.sender == arbitrator, "Only the arbitrator can refund the funds");
        require(state == State.Funded, "The escrow must be in the funded state");
        require(now > deadline, "The deadline must have passed");
        buyer.transfer(amount);
        state = State.Refunded;
    }
}
