// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

contract JapaneseTempuraCraftRegistry {

    struct TempuraStyle {
        string region;          // Tokyo, Kyoto, Osaka, etc.
        string shopOrFamily;    // real historical shop or lineage
        string styleName;       // Edo-style tempura, Kyoto-style tempura, etc.
        string ingredients;     // real ingredients used
        string preparation;     // authentic preparation method
        string uniqueness;      // what makes this style culturally distinct
        address creator;
        uint256 likes;
        uint256 dislikes;
        uint256 createdAt;
    }

    TempuraStyle[] public styles;

    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event StyleRecorded(
        uint256 indexed id,
        string styleName,
        string shopOrFamily,
        address indexed creator
    );

    event StyleVoted(
        uint256 indexed id,
        bool like,
        uint256 likes,
        uint256 dislikes
    );

    constructor() {
        styles.push(
            TempuraStyle({
                region: "Japan",
                shopOrFamily: "ExampleShop",
                styleName: "Example Style (replace with real entries)",
                ingredients: "example ingredients",
                preparation: "example preparation",
                uniqueness: "example uniqueness",
                creator: address(0),
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );
    }

    function recordStyle(
        string calldata region,
        string calldata shopOrFamily,
        string calldata styleName,
        string calldata ingredients,
        string calldata preparation,
        string calldata uniqueness
    ) external {
        require(bytes(region).length > 0, "Region required");
        require(bytes(shopOrFamily).length > 0, "Shop or family required");
        require(bytes(styleName).length > 0, "Style name required");

        styles.push(
            TempuraStyle({
                region: region,
                shopOrFamily: shopOrFamily,
                styleName: styleName,
                ingredients: ingredients,
                preparation: preparation,
                uniqueness: uniqueness,
                creator: msg.sender,
                likes: 0,
                dislikes: 0,
                createdAt: block.timestamp
            })
        );

        emit StyleRecorded(
            styles.length - 1,
            styleName,
            shopOrFamily,
            msg.sender
        );
    }

    function voteStyle(uint256 id, bool like) external {
        require(id < styles.length, "Invalid ID");
        require(!hasVoted[id][msg.sender], "Already voted");

        hasVoted[id][msg.sender] = true;

        TempuraStyle storage s = styles[id];

        if (like) {
            s.likes += 1;
        } else {
            s.dislikes += 1;
        }

        emit StyleVoted(id, like, s.likes, s.dislikes);
    }

    function totalStyles() external view returns (uint256) {
        return styles.length;
    }
}
