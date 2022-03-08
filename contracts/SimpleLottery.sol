//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract SimpleLottery {
    uint256 public TICKET_PRICE = 1 ether;
    address[] public tickets;
    uint256 timeDuration;
    address winner;

    constructor(uint256 duration) {
        timeDuration = block.timestamp + duration;
    }

    function buy() public payable {
        require(msg.value == TICKET_PRICE);
        require(block.timestamp < timeDuration);
        tickets.push(msg.sender);
    }

    function drawWinner() public {
        require(timeDuration < block.timestamp + 5 minutes);
        require(winner == address(0));
        bytes32 rand = keccak256(block.blockhash(block.number - 1));
        winner = tickets[uint256(rand) % tickets.length];
    }

    function withdraw() public {
        require(msg.sender == winner);
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {
        buy();
    }
}
