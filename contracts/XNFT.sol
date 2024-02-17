// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract XNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // Variable to store the base URI
    string private _currentBaseURI;

    // Address allowed to mint tokens
    address private _mintingAuthority;

    constructor(string memory s_baseURI) ERC721("XNFT", "XNFT") {
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

    // This function will still return the full URI by concatenating the base URI with the token ID.
    function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    // Optional: Function to change the minting authority, if needed
    function transferMintingAuthority(address newAuthority) public {
        require(msg.sender == _mintingAuthority, "Not authorized to change authority");
        _mintingAuthority = newAuthority;
    }

}

// contract MyToken is ERC721 {
//     using Counters for Counters.Counter;
//     Counters.Counter private _tokenIdCounter; // Counter to keep track of the last token ID

//     constructor() ERC721("MyToken", "MTK") {}

//     // TODO: add function that can support set _baseURI
//     function _baseURI() internal pure override returns (string memory) {
//         return "https://c076-111-243-87-212.ngrok-free.app/metadata/";
//     }

//     // TODO only one address can execute 
    

//     // Function to mint a new token to a specified address
//     function safeMint(address to) public {
//         _tokenIdCounter.increment(); // Increment the counter to get the new token ID
//         uint256 newTokenId = _tokenIdCounter.current(); // Get the current value of the counter
//         _safeMint(to, newTokenId); // Mint the new token
//     }

//     // // Override required by Solidity for when tokens are burnt.
//     // function _burn(uint256 tokenId) internal override(ERC721) {
//     //     super._burn(tokenId);
//     // }

//     // This function will still return the full URI by concatenating the base URI with the token ID.
//     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
//         return super.tokenURI(tokenId);
//     }
// }


// // http://localhost:8080 / 1

// {
//     name: "x-friend-service",
//     image: "http://xxxxx.jpg",
//     serviceID: "1",
// }
