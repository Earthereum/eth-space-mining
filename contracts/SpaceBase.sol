pragma solidity ^0.4.18;

import "./SpaceAccessControl.sol";

contract SpaceBase is SpaceAccessControl {
	 /*** EVENTS ***/

    /// @dev The Creation event is fired whenever a new planet comes into existence. Called when
    /// planets are generated from player or gen
    event Birth(address owner, uint256 planetId, uint256 genes);

    /// @dev Transfer event as defined in current draft of ERC721. Emitted every time a planet
    ///  ownership is assigned, including births.
    event Transfer(address from, address to, uint256 tokenId);

    /*** DATA TYPES ***/

    /// @dev The main Planet struct. 
    ///  Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
    struct Planet {
        // The Planet's genetic code is packed into these 256-bits
        uint256 genes;

        // The timestamp from the block when this planet came into existence.
        uint64 birthTime;

        // The minimum timestamp after which this planet can be harvested
        // again. 
        uint64 cooldownEndBlock;

        // Set to the index in the cooldown array (see below) that represents
        // the current cooldown duration for this Planet. This starts at zero
        // for gen0 planets, and is initialized to floor(generation/2) for others.
        // Incremented by one for each successful harvest action
        uint16 cooldownIndex;

        // The "generation number" of this planet. Planets minted by our contract
        // for sale are called "gen0" and have a generation number of 0. The
        // generation number of all other planets is proportional to the distance
        // from the center of the galaxy
        uint16 generation;
    }

    /*** CONSTANTS ***/

    /// @dev A lookup table indicating the cooldown duration after any successful
    ///  harvesting action.
    ///  Designed such that the cooldown roughly doubles each time a planet
    ///  is harvested, encouraging owners not to just keep harvesting the same planet over
    ///  and over again. Caps out at one week (a planet can be harvested an unbounded number
    ///  of times, and the maximum cooldown is always seven days).
    uint32[14] public cooldowns = [
        uint32(1 minutes),
        uint32(2 minutes),
        uint32(5 minutes),
        uint32(10 minutes),
        uint32(30 minutes),
        uint32(1 hours),
        uint32(2 hours),
        uint32(4 hours),
        uint32(8 hours),
        uint32(16 hours),
        uint32(1 days),
        uint32(2 days),
        uint32(4 days),
        uint32(7 days)
    ];

    // An approximation of currently how many seconds are in between blocks.
    uint256 public secondsPerBlock = 15;

    /*** STORAGE ***/

    /// @dev An array containing the Planet struct for all Planets in existence. The ID
    ///  of each planet is actually an index into this array. Note that ID 0 is TBD
    Planet[] planets;

    /// @dev A mapping from planet IDs to the address that owns them. All planets have
    ///  some valid owner address, even gen0 planets are created with a non-zero owner.
    mapping (uint256 => address) public planetIndexToOwner;

    // @dev A mapping from owner address to count of tokens that address owns.
    //  Used internally inside balanceOf() to resolve ownership count.
    mapping (address => uint256) ownershipTokenCount;

    /// @dev A mapping from PlanetIDs to an address that has been approved to call
    ///  transferFrom(). Each Planet can only have one approved address for transfer
    ///  at any time. A zero value means no approval is outstanding.
    mapping (uint256 => address) public planetIndexToApproved;

    /// @dev The address of the ClockAuction contract that handles sales of Planets. This
    ///  same contract handles both peer-to-peer sales as well as the gen0 sales which are
    ///  initiated every 15 minutes.
    // SaleClockAuction public saleAuction;

    /// @dev Assigns ownership of a specific Planet to an address.
    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        // Since the number of planets is capped to 2^32 we can't overflow this
        ownershipTokenCount[_to]++;
        // transfer ownership
        planetIndexToOwner[_tokenId] = _to;
        // When creating new planets _from is 0x0, but we can't account that address.
        if (_from != address(0)) {
            ownershipTokenCount[_from]--;
            // clear any previously approved ownership exchange
            delete planetIndexToOwner[_tokenId];
        }
        // Emit the transfer event.
        Transfer(_from, _to, _tokenId);
    }

    /// @dev An internal method that creates a new Planet and stores it. This
    ///  method doesn't do any checking and should only be called when the
    ///  input data is known to be valid. Will generate both a Birth event
    ///  and a Transfer event.
    /// @param _generation The generation number of this planet, must be computed by caller.
    /// @param _genes The Planet's genetic code.
    /// @param _owner The inital owner of this planet, must be non-zero (except for the unPlanet, ID 0)
    function _createPlanet(
        uint256 _generation,
        uint256 _genes,
        address _owner
    )
        internal
        returns (uint)
    {
        // These requires are not strictly necessary, our calling code should make
        // sure that these conditions are never broken. However! _createPlanet() is already
        // an expensive call (for storage), and it doesn't hurt to be especially careful
        // to ensure our data structures are always valid.
        require(_generation == uint256(uint16(_generation)));

        // New Planet starts with the same cooldown as parent gen/2
        uint16 cooldownIndex = uint16(_generation / 2);
        if (cooldownIndex > 13) {
            cooldownIndex = 13;
        }

        Planet memory _Planet = Planet({
            genes: _genes,
            birthTime: uint64(now),
            cooldownEndBlock: 0,
            cooldownIndex: cooldownIndex,
            generation: uint16(_generation)
        });
        uint256 newplanetId = planets.push(_Planet) - 1;

        // It's probably never going to happen, 4 billion planets is A LOT, but
        // let's just be 100% sure we never let this happen.
        require(newplanetId == uint256(uint32(newplanetId)));

        // emit the birth event
        Birth(
            _owner,
            newplanetId,

            _Planet.genes
        );

        // This will assign ownership, and also emit the Transfer event as
        // per ERC721 draft
        _transfer(0, _owner, newplanetId);

        return newplanetId;
    }

    // Any C-level can fix how many seconds per blocks are currently observed.
    function setSecondsPerBlock(uint256 secs) external onlyCLevel {
        require(secs < cooldowns[0]);
        secondsPerBlock = secs;
    }
}