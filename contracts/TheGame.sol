// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract TheGame is ERC721,ERC721URIStorage, Ownable {
  uint public totalSupply = 2^256;
  uint public totalLosses =0;
  string public baseURI = "https://bafkreigm33tvwbd3t6led7tltb5ff67zvbhofihj7axifto5f7ffnsmghm.ipfs.dweb.link/";
  mapping (address=>uint) LossTracker;
  

  using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("TheGame", "LOST") {
    }

    function safeMint(address to,uint amountOfLosses) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, baseURI);
        LossTracker[msg.sender] = LossTracker[msg.sender] + amountOfLosses;

    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

}
