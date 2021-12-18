// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


/// @title The Game-Don't think about it 
/// @author rubrixks.eth
/// @notice Will only be available on testnets until deployed on a L2 scaling solution
/// @dev All function calls are currently implemented without side effects
/// @custom:experimental This is an experimental contract.
contract TheGame is ERC721,ERC721URIStorage, Ownable {


  uint public totalSupply = 2**256-1;
  uint public totalLosses =0;
  string public baseURI = "https://bafkreigm33tvwbd3t6led7tltb5ff67zvbhofihj7axifto5f7ffnsmghm.ipfs.dweb.link/";
  string public AccountwithMostLs;
  mapping (address=>uint) LossTracker;
  using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;


    constructor() ERC721("TheGame", "DTAI") { 
    }
    ///Needs to only allow owner to call

    /// @notice Allows creator to mint the first 100 losses
    /// @dev Only the owner can call this function
    function FirstLoser() public onlyOwner  {
        for (uint i=0; i<3;i++) {
          safeMint(msg.sender);
          totalLosses = totalLosses + 1;
          LossTracker[msg.sender] = LossTracker[msg.sender] + amountOfLosses;
        }

          
    } 
    ///Needs to HandOutLs after owner is given first 100 Ls;
    /// @notice Anyone who has thought about the game can mint as many Losses as they have thought of 
    /// @dev Keeps track of how many Losses have been minted 
    /// @param address wanting to mint and amount of losses wanted on the address
    function HandOutLs(address to, uint amountOfLosses) public {
      require(amountOfLosses<= 100000,"No. Stop. Stop thinking about The Game.")
        for (uint i = 0;i<amountOfLosses;i++) {
          safeMint(to);
        }
        totalLosses = totalLosses + amountOfLosses;
        LossTracker[msg.sender] = LossTracker[msg.sender] + amountOfLosses;
        }
  /// @notice Calculate tree age in years, rounded up, for live trees
    /// @dev safely mints NFT
    /// @param to is the address of the address wanting to mint NFT
    function safeMint(address to) internal {
        uint tokenId = _tokenIdCounter.current()+1;
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, baseURI);
    }
    // The following functions are overrides required by Solidity.
    ///NEEDS TO BE FIXED
    /// @notice burns the Loss NFT from the address requesting to burn
    /// @dev Only the owner can burn their Loss
    /// @param tokenID so the address can identify which loss to get rid of the NFT
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
    /// @notice Returns JSON file of the The Game
    /// @dev Must return baseURI for all tokenURI requests
    /// @param tokenId is what makes the token nonfungible, it keeps track of when the NFT want minted
    /// @return URI
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
    /// @notice Returns who the amount of Losses on in one address
    /// @dev Must return baseURI for all tokenURI requests
    /// @param ad is the address that tracks how many times the account has minted or has been transferred losses
    /// @return a number
    function LossFinder(address ad) public view returns(uint) {
      return LossTracker[ad];
    }

}
