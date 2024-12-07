// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

// Dependencies
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/// @title IPoeternal Interface
/// @notice Interface for the Poeternal NFT contract
interface IPoeternal is IERC721 {
  /*//////////////////////////////////////////////////////////////
                                   MINT
    //////////////////////////////////////////////////////////////*/
  /// @notice Mints a new Poeternal NFT
  /// @param to The address to mint the NFT to
  /// @param newTokenId The ID of the new token
  /// @param author The author of the poem
  /// @param source The source of the poem, where inspiration was taken from to create it
  /// @param colour The color of the background in the poem
  /// @param name The name of the poem
  /// @param lines The lines in the poem
  /// @return The ID of the new token
  function mint(
    address to,
    uint256 newTokenId,
    string calldata name,
    string[4] memory lines,
    string calldata author,
    string calldata source,
    string calldata colour
  ) external returns (uint256);

  /*//////////////////////////////////////////////////////////////
                                   VIEW
    //////////////////////////////////////////////////////////////*/

  /// @notice Returns the URI for a given token ID
  /// @param tokenId The ID of the token to query
  /// @return A string containing the URI
  function tokenURI(uint256 tokenId) external view returns (string memory);

  /// @notice Gets the name of a slime
  /// @param tokenId The ID of the token to query
  /// @return The name of the slime
  function getName(uint256 tokenId) external view returns (string memory);

  /// @notice Gets the description of a slime
  /// @param tokenId The ID of the token to query
  /// @return The description of the slime
  function getDescription(uint256 tokenId) external view returns (string memory);

  /// @notice Gets the speed of a slime
  /// @param tokenId The ID of the token to query
  /// @return The speed of the slime
  function getAuthor(uint256 tokenId) external view returns (string memory);

  /// @notice Gets the variant of a slime
  /// @param tokenId The ID of the token to query
  /// @return The variant of the slime
  function getSource(uint256 tokenId) external view returns (string memory);

  /// @notice Gets the mint data used to mint this item so it can be reminted on another chain
  /// @param tokenId The ID of the token to query
  /// @return A list of data fields
  function getMintData(
    uint256 tokenId
  ) external view returns (uint256, string memory, string[4] memory, string memory, string memory, string memory);
}
