// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Stats {
        uint256 level;
        uint256 speed;
        uint256 strength;
        uint256 life;
    }

    mapping(uint256 => Stats) public tokenIdToStats;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 tokenId) public view returns(string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Warrior", '</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Level: ", getLevel(tokenId), '</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ", getSpeed(tokenId), '</text>',
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ", getStrength(tokenId), '</text>',
            '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ", getLife(tokenId), '</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }

    function random(uint number) public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % number;
    }

    function getLevel(uint256 tokenId) public view returns (string memory) {
        uint256 level = tokenIdToStats[tokenId].level;
        return level.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        uint256 level = tokenIdToStats[tokenId].speed;
        return level.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        uint256 level = tokenIdToStats[tokenId].strength;
        return level.toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        uint256 level = tokenIdToStats[tokenId].life;
        return level.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mint() public { 
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToStats[newItemId].level = 0;
        tokenIdToStats[newItemId].speed = random(30);
        tokenIdToStats[newItemId].strength = random(10);
        tokenIdToStats[newItemId].life = random(100);
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId));
        require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");
        uint256 currentLevel = tokenIdToStats[tokenId].level;
        tokenIdToStats[tokenId].level = currentLevel + 1;
        tokenIdToStats[tokenId].speed = currentLevel + 1;
        tokenIdToStats[tokenId].strength = currentLevel + 1;
        tokenIdToStats[tokenId].life = currentLevel + 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}