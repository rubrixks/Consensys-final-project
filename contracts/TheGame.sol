// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
contract TheGame is ERC1155, Ownable {
  uint256[] public totalSupply =[1000000000,1000000000];
  uint256[] public Loses = [0,0];
  uint8 public cost = .0001 ether;
  uint256 public totalLoses = 0;

function mint(uint256 id, uint256 amount) public payable {
        require(id <= LostOnes.length, "Try again friend. Either you lost the Game, or someone else set you up.");
        require(id >0, "What are you doing?");
        require(amount ==1, "Why do you want more than one L on your record? Take one only.");
        uint index = id-1;
        require(Loses[index] <= totalSupply[index], "Surprisingly, we ran out. There are more Ls out there in the world, just ask someone to send you one. ");
        require(msg.value == cost, "Sorry Friend. minting this NFT costs .0001 ether");
        _mint(msg.sender, id, amount, "0x00");
        Loses[index] += amount;
        totalLoses= totalLoses +amount;
    }
  constructor() public {
  
  }


}
