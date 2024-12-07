// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

// Interfaces
import { IPoeternal } from "./interfaces/IPoeternal.sol";
import { IERC165 } from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

// Dependencies
import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { AccessControl } from "@openzeppelin/contracts/access/AccessControl.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { ERC721Burnable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

/// @title Poeternal NFT Contract
/// @notice Poeternal is an SODA, all state in this NFT is on chain. tokenURI is on chain and image is on chain
contract Poeternal is ERC721, ERC721Burnable, AccessControl, IPoeternal {
  /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/
  //
  error NoTokenIds();
  error NotNFTOwner(address sender, uint256 tokenId);

  /*//////////////////////////////////////////////////////////////
                               LIBRARIES
    //////////////////////////////////////////////////////////////*/

  using Strings for uint256;

  /*//////////////////////////////////////////////////////////////
                                 STRUCTS
    //////////////////////////////////////////////////////////////*/

  /// @notice Attributes of a Poeternal NFT
  /// @param author The author of the poem
  /// @param source The source of the poem, where inspiration was taken from to create it
  /// @param colour The color of the background in the poem
  /// @param name The name of the poem
  /// @param lines The lines in the poem
  struct Poem {
    string author;
    string source;
    string colour;
    string name;
    string[4] lines;
  }

  /*//////////////////////////////////////////////////////////////
                               CONSTANTS
    //////////////////////////////////////////////////////////////*/
  //
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

  /*//////////////////////////////////////////////////////////////
                                 STATE
    //////////////////////////////////////////////////////////////*/

  mapping(uint256 tokenId => Poem poems) private poems;
  mapping(uint256 tokenId => string tokenUris) private tokenURIs;

  /*//////////////////////////////////////////////////////////////
                              CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

  /// @notice Initializes the Poeternal contract
  /// @param _admin Address to be granted the DEFAULT_ADMIN_ROLE
  /// @param _minter Address to be granted the MINTER_ROLE
  constructor(address _admin, address _minter) ERC721("Poeternal", "POEM") {
    _grantRole(DEFAULT_ADMIN_ROLE, _admin);
    _grantRole(MINTER_ROLE, _minter);
  }

  /*//////////////////////////////////////////////////////////////
                              EXTERNAL
    //////////////////////////////////////////////////////////////*/

  /// @inheritdoc IPoeternal
  function mint(
    address to,
    uint256 newTokenId,
    string calldata name,
    string[4] memory lines,
    string calldata author,
    string calldata source,
    string calldata colour
  ) external onlyRole(MINTER_ROLE) returns (uint256) {
    _safeMint(to, newTokenId);
    Poem memory poem = Poem(author, source, colour, name, lines);
    poems[newTokenId] = poem;

    string memory description = _getDescription(poem.lines);
    string memory escapedDescription = escapeNewlines(description); // Escape newlines

    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',
            poem.name,
            '", "description": "',
            escapedDescription,
            '", "image": "',
            _getImage(poem),
            '", ',
            '"attributes": [',
            '{"trait_type": "Author", "value": "@',
            poem.author,
            '"}, ',
            '{"trait_type": "Source", "value": "',
            poem.source,
            '"}',
            "]}"
          )
        )
      )
    );

    string memory tokenUri = string(abi.encodePacked("data:application/json;base64,", json));

    tokenURIs[newTokenId] = tokenUri;
    return newTokenId;
  }

  /// @inheritdoc IPoeternal
  function tokenURI(uint256 tokenId) public view override(ERC721, IPoeternal) returns (string memory) {
    _requireOwned(tokenId);

    return tokenURIs[tokenId];
  }

  // Function to generate SVG using the Poem struct
  function generateSVG(Poem memory poem) public pure returns (string memory) {
    string memory svgStart = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 380" width="600" height="380">';
    string memory rect = string(abi.encodePacked('<rect width="100%" height="100%" fill="', poem.colour, '" />'));

    string memory text1 = string(
      abi.encodePacked(
        '<text x="50%" y="20%" font-family="Cursive, Georgia, serif" font-size="36" text-anchor="middle" fill="#3D2B1F" font-style="italic">',
        poem.lines[0],
        "</text>"
      )
    );
    string memory text2 = string(
      abi.encodePacked(
        '<text x="50%" y="35%" font-family="Cursive, Georgia, serif" font-size="36" text-anchor="middle" fill="#3D2B1F" font-style="italic">',
        poem.lines[1],
        "</text>"
      )
    );
    string memory text3 = string(
      abi.encodePacked(
        '<text x="50%" y="50%" font-family="Cursive, Georgia, serif" font-size="36" text-anchor="middle" fill="#3D2B1F" font-style="italic">',
        poem.lines[2],
        "</text>"
      )
    );
    string memory text4 = string(
      abi.encodePacked(
        '<text x="50%" y="65%" font-family="Cursive, Georgia, serif" font-size="36" text-anchor="middle" fill="#3D2B1F" font-style="italic">',
        poem.lines[3],
        "</text>"
      )
    );

    string memory authorText = string(
      abi.encodePacked(
        '<text x="50%" y="85%" font-family="\'Brush Script MT\', cursive" font-size="36" font-style="italic" text-anchor="middle" fill="#3D2B1F" alignment-baseline="middle">',
        poem.author,
        "</text>"
      )
    );

    string memory svgEnd = "</svg>";

    // Concatenate all parts and return the SVG
    return string(abi.encodePacked(svgStart, rect, text1, text2, text3, text4, authorText, svgEnd));
  }

  /// @inheritdoc IPoeternal
  function getName(uint256 tokenId) external view returns (string memory) {
    _requireOwned(tokenId);
    return poems[tokenId].name;
  }

  function getMintData(
    uint256 tokenId
  ) external view returns (uint256, string memory, string[4] memory, string memory, string memory, string memory) {
    Poem memory poem = poems[tokenId];
    return (tokenId, poem.name, poem.lines, poem.author, poem.source, poem.colour);
  }

  /// @inheritdoc IPoeternal
  function getDescription(uint256 tokenId) external view returns (string memory) {
    _requireOwned(tokenId);
    return _getDescription(poems[tokenId].lines);
  }

  /// @inheritdoc IPoeternal
  function getAuthor(uint256 tokenId) external view returns (string memory) {
    _requireOwned(tokenId);
    return poems[tokenId].author;
  }

  /// @inheritdoc IPoeternal
  function getSource(uint256 tokenId) external view returns (string memory) {
    _requireOwned(tokenId);
    return poems[tokenId].source;
  }

  // Function to join an array of strings with newlines
  function joinWithNewline(string[4] memory items) internal pure returns (string memory) {
    bytes memory result = "";

    for (uint i = 0; i < items.length; i++) {
      result = abi.encodePacked(result, items[i]);

      // Add a newline character except after the last item
      if (i < items.length - 1) {
        result = abi.encodePacked(result, "\n");
      }
    }

    return string(result);
  }

  /*//////////////////////////////////////////////////////////////
                            INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

  /// @notice Checks if the contract supports an interface
  /// @param interfaceId The interface identifier
  /// @return bool True if the contract supports the interface
  function supportsInterface(bytes4 interfaceId) public view override(ERC721, AccessControl, IERC165) returns (bool) {
    return super.supportsInterface(interfaceId);
  }

  /// @notice Gets the description based on the speed attribute
  /// @param lines The lines in the poem
  /// @return string The description of the slime
  function _getDescription(string[4] memory lines) internal pure returns (string memory) {
    return joinWithNewline(lines);
  }

  /// @notice Gets the image based on the variant attribute
  /// @param poem The poem we want to generate an svg for
  /// @return string The image URL of the slime
  function _getImage(Poem memory poem) internal pure returns (string memory) {
    string memory svgStart = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 600 380" width="600" height="380">';
    string memory rect = string(abi.encodePacked('<rect width="100%" height="100%" fill="', poem.colour, '" />'));

    string memory text1 = string(
      abi.encodePacked(
        '<text x="50%" y="20%" font-family="Cursive, Georgia, serif" font-size="36" text-anchor="middle" fill="#3D2B1F" font-style="italic">',
        poem.lines[0],
        "</text>"
      )
    );
    string memory text2 = string(
      abi.encodePacked(
        '<text x="50%" y="35%" font-family="Cursive, Georgia, serif" font-size="36" text-anchor="middle" fill="#3D2B1F" font-style="italic">',
        poem.lines[1],
        "</text>"
      )
    );
    string memory text3 = string(
      abi.encodePacked(
        '<text x="50%" y="50%" font-family="Cursive, Georgia, serif" font-size="36" text-anchor="middle" fill="#3D2B1F" font-style="italic">',
        poem.lines[2],
        "</text>"
      )
    );
    string memory text4 = string(
      abi.encodePacked(
        '<text x="50%" y="65%" font-family="Cursive, Georgia, serif" font-size="36" text-anchor="middle" fill="#3D2B1F" font-style="italic">',
        poem.lines[3],
        "</text>"
      )
    );

    string memory authorText = string(
      abi.encodePacked(
        '<text x="50%" y="85%" font-family="\'Brush Script MT\', cursive" font-size="36" font-style="italic" text-anchor="middle" fill="#3D2B1F" alignment-baseline="middle">',
        poem.author,
        "</text>"
      )
    );

    string memory svgEnd = "</svg>";

    // Concatenate all parts to form the full SVG
    string memory svg = string(abi.encodePacked(svgStart, rect, text1, text2, text3, text4, authorText, svgEnd));

    // Encode the SVG to Base64 using OpenZeppelin's Base64 library
    string memory base64SVG = Base64.encode(bytes(svg));

    // Return the Data URI with the base64-encoded SVG content
    return string(abi.encodePacked("data:image/svg+xml;base64,", base64SVG));
  }

  function escapeNewlines(string memory input) internal pure returns (string memory) {
    bytes memory inputBytes = bytes(input);
    uint256 newLength = inputBytes.length;
    // Count the number of newlines
    for (uint256 i = 0; i < inputBytes.length; i++) {
      if (inputBytes[i] == 0x0A) {
        // 0x0A is ASCII for newline (\n)
        newLength += 1; // Need to escape newline, so the length increases
      }
    }

    bytes memory escapedBytes = new bytes(newLength);
    uint256 j = 0;
    for (uint256 i = 0; i < inputBytes.length; i++) {
      if (inputBytes[i] == 0x0A) {
        escapedBytes[j++] = 0x5C; // Backslash '\'
        escapedBytes[j++] = 0x6E; // 'n'
      } else {
        escapedBytes[j++] = inputBytes[i];
      }
    }

    return string(escapedBytes);
  }
}
