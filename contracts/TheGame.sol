// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

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
    function FirstLoser() public onlyOwner  {
        for (uint i=0; i<3;i++) {
          safeMint(msg.sender);
          totalLosses = totalLosses + 1;
          LossTracker[msg.sender] = LossTracker[msg.sender] + amountOfLosses;
        }

          
    } 
    ///Needs to HandOutLs after owner is given first 100 Ls;
    function HandOutLs(address to, uint amountOfLosses) public {
        for (uint i = 0;i<amountOfLosses;i++) {
          safeMint(to);
        }
        totalLosses = totalLosses + amountOfLosses;
        LossTracker[msg.sender] = LossTracker[msg.sender] + amountOfLosses;
        }

    function safeMint(address to) internal {
        uint tokenId = _tokenIdCounter.current()+1;
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, baseURI);
    }
    // The following functions are overrides required by Solidity.
    ///NEEDS TO BE FIXED
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
    function LossFinder(address ad) public view returns(uint) {
      return LossTracker[ad];
    }

}
