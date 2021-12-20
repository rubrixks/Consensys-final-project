// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


/// @title The Game-Don't think about it 
/// @author rubrixks.eth
/// @notice Will only be available on testnets until deployed on a L2 scaling solution
/// @dev All function calls are currently implemented without side effects
/// @custom:experimental This is an experimental contract.
contract TheGame is ERC721,ERC721URIStorage, Ownable {

  bool public GameStarts = false;
  uint public MaxSupply = 2**256-1;
  uint public mintedLosses = 0;
  uint public totalLosses =0;
  string public baseURI = "https://bafkreigm33tvwbd3t6led7tltb5ff67zvbhofihj7axifto5f7ffnsmghm.ipfs.dweb.link/";
  uint public LossBasePrice = .00025 ether;
  mapping (address=>uint) LossTracker;
  using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;


    constructor() ERC721("TheGame", "DTAI") { 
    }
    ///Needs to only allow owner to call

    /// @notice Allows creator to mint the first 100 losses
    /// @dev Only the owner can call this function
    function FirstLoser() payable public onlyOwner  {
      beginTheGame();
      require(msg.value == LossBasePrice * 100,"Not enough Ether was sent");
        for (uint i = 0; i < 100; i++) {
          safeMint(msg.sender);
        }
        totalLosses = totalLosses + 100;
        LossTracker[msg.sender] = LossTracker[msg.sender] + 100;
    } 
    ///Needs to HandOutLs after owner is given first 100 Ls;
    /// notice Anyone who has thought about the game can mint as many Losses as they have thought of 
    /// dev Keeps track of how many Losses have been minted 
    /// param address wanting to mint and amount of losses wanted on the address
    function HandOutLs(address to, uint amountOfLosses) payable public {
      require(GameStarts == true,"The Game has not begun");
      require(mintedLosses +amountOfLosses<= MaxSupply,"We reached our technological limit. Mint less losses, or ask another Loser to send you one.");
      require(msg.value == LossBasePrice * amountOfLosses,"Sorry friend, send the exact amount of Ether required");
        for (uint i = 0; i < amountOfLosses; i++) {
          safeMint(to);
        }
        mintedLosses = mintedLosses + amountOfLosses;
        totalLosses = totalLosses + amountOfLosses;
        LossTracker[msg.sender] = LossTracker[msg.sender] + amountOfLosses;
        }
  /// notice Calculate tree age in years, rounded up, for live trees
    /// dev safely mints NFT
    /// param to is the address of the address wanting to mint NFT
    function safeMint(address to) internal {
        uint tokenId = _tokenIdCounter.current()+1;
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, baseURI);
    }
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
    /// notice Returns JSON file of the The Game
    /// dev Must return baseURI for all tokenURI requests
    /// param tokenId is what makes the token nonfungible, it keeps track of when the NFT want minted
    /// return URI
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
    /// notice Returns who the amount of Losses on in one address
    /// dev Must return baseURI for all tokenURI requests
    /// param ad is the address that tracks how many times the account has minted or has been transferred losses
    /// returns a number
    function lossFinder(address ad) public view returns(uint) {
      return LossTracker[ad];
    }
    function withdraw() payable public onlyOwner {
        uint amount = address(this).balance;
        payable(msg.sender).transfer(amount);
    }

    function beginTheGame() public onlyOwner {
        GameStarts = !GameStarts;
    }
}
