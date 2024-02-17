// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Xpoap is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // Variable to store the base URI
    string private _currentBaseURI;

    // Address allowed to mint tokens
    address private _mintingAuthority;

    constructor(string memory s_baseURI) ERC721("Xpoap", "Xpoap") {
        _mintingAuthority = msg.sender; // Set the deployer as the initial minting authority
        setBaseURI(s_baseURI);
    }

    // Function to set the base URI, restricted to the minting authority
    function setBaseURI(string memory baseURI) public {
        require(msg.sender == _mintingAuthority, "Not authorized to set base URI");
        _currentBaseURI = baseURI;
    }

    // Override _baseURI to return the dynamic base URI
    function _baseURI() internal view override returns (string memory) {
        return _currentBaseURI;
    }

    // Function to mint a new token, restricted to the minting authority
    function safeMint(address to) public {
        require(msg.sender == _mintingAuthority, "Not authorized to mint");
        _tokenIdCounter.increment();
        uint256 newTokenId = _tokenIdCounter.current();
        _safeMint(to, newTokenId);
    }

    // Optional: Function to change the minting authority, if needed
    function transferMintingAuthority(address newAuthority) public {
        require(msg.sender == _mintingAuthority, "Not authorized to change authority");
        _mintingAuthority = newAuthority;
    }

}

// // http://localhost:8080 / 1

// {
//     name: "x-friend-service",
//     image: "http://xxxxx.jpg",
//     serviceID: "1",
// }
