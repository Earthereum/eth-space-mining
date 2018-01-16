pragma solidity ^0.4.18;

import "./SpaceBase.sol";


/// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
/// @author Earthereum <austinatchley@gmail.com> (https://github.com/Earthereum)
contract ERC721 {
    // Required methods
    function totalSupply() public view returns (uint256 total);
    function balanceOf(address _owner) public view returns (uint256 balance);
    function ownerOf(uint256 _tokenId) external view returns (address owner);
    function approve(address _to, uint256 _tokenId) external;
    function transfer(address _to, uint256 _tokenId) external;
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);

    // Events
    event Transfer(address from, address to, uint256 tokenId);
    event Approval(address owner, address approved, uint256 tokenId);
}

contract SpaceOwnership is SpaceBase, ERC721 {

	/// Name and symbol of the non fungible token, as defined in ERC721.
    string public name = "Earthereum";
    string public symbol = "ERTH";

    bool public implementsERC721 = true;

    /// Checks if a given address is the current owner of a particular planet.
    /// _claimant the address we are validating against.
    /// _tokenId planet id, only valid when > 0
    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return planetIndexToOwner[_tokenId] == _claimant;
    }

    /// Checks if a given address currently has transferApproval for a particular planet.
    /// _claimant the address we are confirming planet is approved for.
    /// _tokenId planet id, only valid when > 0
    function _approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return planetIndexToApproved[_tokenId] == _claimant;
    }

    /// Marks an address as being approved for transferFrom(), overwriting any previous
    ///  approval. Setting _approved to address(0) clears all transfer approval.
    ///  NOTE: _approve() does NOT send the Approval event. This is intentional because
    ///  _approve() and transferFrom() are used together for putting planets on auction, and
    ///  there is no value in spamming the log with Approval events in that case.
    function _approve(uint256 _tokenId, address _approved) internal {
        planetIndexToApproved[_tokenId] = _approved;
    }

    /// Returns the number of planets owned by a specific address.
    /// _owner The owner address to check.
    /// Required for ERC-721 compliance
    function balanceOf(address _owner) public view returns (uint256 count) {
        return ownershipTokenCount[_owner];
    }

    /// Transfers a planet to another address. If transferring to a smart
    ///  contract be VERY CAREFUL to ensure that it is aware of ERC-721 (or
    ///  Cryptoplanets specifically) or your planet may be lost forever. Seriously.
    /// _to The address of the recipient, can be a user or contract.
    /// _tokenId The ID of the planet to transfer.
    /// Required for ERC-721 compliance.
    function transfer(
        address _to,
        uint256 _tokenId
    )
        external
        whenNotPaused
    {
        // Safety check to prevent against an unexpected 0x0 default.
        require(_to != address(0));
        // Disallow transfers to this contract to prevent accidental misuse.
        // The contract should never own any planets (except very briefly
        // after a gen0 planet is created and before it goes on auction).
        require(_to != address(this));
        // Disallow transfers to the auction contracts to prevent accidental
        // misuse. Auction contracts should only take ownership of planets
        // through the allow + transferFrom flow.
        // require(_to != address(saleAuction));
        // require(_to != address(siringAuction));

        // You can only send your own planet.
        require(_owns(msg.sender, _tokenId));

        // Reassign ownership, clear pending approvals, emit Transfer event.
        _transfer(msg.sender, _to, _tokenId);
    }

    /// Grant another address the right to transfer a specific planet via
    ///  transferFrom(). This is the preferred flow for transfering NFTs to contracts.
    /// _to The address to be granted transfer approval. Pass address(0) to
    ///  clear all approvals.
    /// _tokenId The ID of the planet that can be transferred if this call succeeds.
    /// Required for ERC-721 compliance.
    function approve(
        address _to,
        uint256 _tokenId
    )
        external
        whenNotPaused
    {
        // Only an owner can grant transfer approval.
        require(_owns(msg.sender, _tokenId));

        // Register the approval (replacing any previous approval).
        _approve(_tokenId, _to);

        // Emit approval event.
        Approval(msg.sender, _to, _tokenId);
    }

    /// Transfer a planet owned by another address, for which the calling address
    ///  has previously been granted transfer approval by the owner.
    /// _from The address that owns the planet to be transfered.
    /// _to The address that should take ownership of the planet. Can be any address,
    ///  including the caller.
    /// _tokenId The ID of the planet to be transferred.
    /// Required for ERC-721 compliance.
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    )
        external
        whenNotPaused
    {
        // Safety check to prevent against an unexpected 0x0 default.
        require(_to != address(0));
        // Disallow transfers to this contract to prevent accidental misuse.
        // The contract should never own any planets (except very briefly
        // after a gen0 planet is created and before it goes on auction).
        require(_to != address(this));
        // Check for approval and valid ownership
        require(_approvedFor(msg.sender, _tokenId));
        require(_owns(_from, _tokenId));

        // Reassign ownership (also clears pending approvals and emits Transfer event).
        _transfer(_from, _to, _tokenId);
    }

    /// Returns the total number of planets currently in existence.
    /// Required for ERC-721 compliance.
    function totalSupply() public view returns (uint) {
        return planets.length - 1;
    }

    /// Returns the address currently assigned ownership of a given planet.
    /// Required for ERC-721 compliance.
    function ownerOf(uint256 _tokenId)
        external
        view
        returns (address owner)
    {
        owner = planetIndexToOwner[_tokenId];

        require(owner != address(0));
    }

    /// Returns a list of all planet IDs assigned to an address.
    /// _owner The owner whose planets we are interested in.
    /// This method MUST NEVER be called by smart contract code. First, it's fairly
    ///  expensive (it walks the entire planet array looking for Planets belonging to owner),
    ///  but it also returns a dynamic array, which is only supported for web3 calls, and
    ///  not contract-to-contract calls.
    function tokensOfOwner(address _owner) external view returns(uint256[] ownerTokens) {
        uint256 tokenCount = balanceOf(_owner);

        if (tokenCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 totalPlanets = totalSupply();
            uint256 resultIndex = 0;

            // We count on the fact that all Planets have IDs starting at 1 and increasing
            // sequentially up to the totalplanet count.
            uint256 planetId;

            for (planetId = 1; planetId <= totalPlanets; planetId++) {
                if (planetIndexToOwner[planetId] == _owner) {
                    result[resultIndex] = planetId;
                    resultIndex++;
                }
            }

            return result;
        }
    }

    /// Adapted from memcpy() by @arachnid (Nick Johnson <arachnid@notdot.net>)
    ///  This method is licenced under the Apache License.
    ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
    function _memcpy(uint _dest, uint _src, uint _len) private pure {
        // Copy word-length chunks while possible
        for(; _len >= 32; _len -= 32) {
            assembly {
                mstore(_dest, mload(_src))
            }
            _dest += 32;
            _src += 32;
        }

        // Copy remaining bytes
        uint256 mask = 256 ** (32 - _len) - 1;
        assembly {
            let srcpart := and(mload(_src), not(mask))
            let destpart := and(mload(_dest), mask)
            mstore(_dest, or(destpart, srcpart))
        }
    }

    /// Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
    ///  This method is licenced under the Apache License.
    ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
    function _toString(bytes32[4] _rawBytes, uint256 _stringLength) private pure returns (string) {
        var outputString = new string(_stringLength);
        uint256 outputPtr;
        uint256 bytesPtr;

        assembly {
            outputPtr := add(outputString, 32)
            bytesPtr := _rawBytes
        }

        _memcpy(outputPtr, bytesPtr, _stringLength);

        return outputString;
    }
}