pragma solidity ^0.4.18;

import "./SpaceOwnership.sol";
import "./SpaceOwnership.sol";
import "./Ownable.sol";
import "./Pausable.sol";

contract ClockAuctionBase {

    // Represents an auction on an NFT
    struct Auction {
        // Current owner of NFT
        address seller;
        // Price in wei
        uint128 price;
        // Duration (in seconds) of auction
        uint64 duration;
        // Time when auction started
        // NOTE: 0 if this auction has been concluded
        uint64 startedAt;
    }

    // Reference to contract tracking NFT ownership
    ERC721 public nonFungibleContract;

    // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
    // Values 0-10,000 map to 0%-100%
    uint256 public ownerCut;

    // Map from token ID to their corresponding auction.
    mapping (uint256 => Auction) tokenIdToAuction;

    event AuctionCreated(uint256 tokenId, uint256 price, uint256 duration);
    event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);
    event AuctionCancelled(uint256 tokenId);

    // Returns true if the claimant owns the token.
    // _claimant - Address claiming to own the token.
    // _tokenId - ID of token whose ownership to verify.
    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
    }

    // Escrows the NFT, assigning ownership to this contract.
    // Throws if the escrow fails.
    // _owner - Current owner address of token to escrow.
    // _tokenId - ID of token whose approval to verify.
    function _escrow(address _owner, uint256 _tokenId) internal {
        // it will throw if transfer fails
        nonFungibleContract.transferFrom(_owner, this, _tokenId);
    }

    // Transfers an NFT owned by this contract to another address.
    // Returns true if the transfer succeeds.
    // _receiver - Address to transfer NFT to.
    // _tokenId - ID of token to transfer.
    function _transfer(address _receiver, uint256 _tokenId) internal {
        // it will throw if transfer fails
        nonFungibleContract.transfer(_receiver, _tokenId);
    }

    // Adds an auction to the list of open auctions. Also fires the
    //  AuctionCreated event.
    // _tokenId The ID of the token to be put on auction.
    // _auction Auction to add.
    function _addAuction(uint256 _tokenId, Auction _auction) internal {
        // Require that all auctions have a duration of
        // at least one minute. (Keeps our math from getting hairy!)
        require(_auction.duration >= 1 minutes);

        tokenIdToAuction[_tokenId] = _auction;

        AuctionCreated(
            uint256(_tokenId),
            uint256(_auction.price),
            uint256(_auction.duration)
        );
    }

    // Cancels an auction unconditionally.
    function _cancelAuction(uint256 _tokenId, address _seller) internal {
        _removeAuction(_tokenId);
        _transfer(_seller, _tokenId);
        AuctionCancelled(_tokenId);
    }

    // Computes the price and transfers winnings.
    // Does NOT transfer ownership of token.
    function _bid(uint256 _tokenId, uint256 _bidAmount)
        internal
        returns (uint256)
    {
        // Get a reference to the auction struct
        Auction storage auction = tokenIdToAuction[_tokenId];

        // Explicitly check that this auction is currently live.
        // (Because of how Ethereum mappings work, we can't just count
        // on the lookup above failing. An invalid _tokenId will just
        // return an auction object that is all zeros.)
        require(_isOnAuction(auction));

        uint256 price = auction.price;
        require(_bidAmount >= price);

        // Grab a reference to the seller before the auction struct
        // gets deleted.
        address seller = auction.seller;

        // The bid is good! Remove the auction before sending the fees
        // to the sender so we can't have a reentrancy attack.
        _removeAuction(_tokenId);

        // Transfer proceeds to seller (if there are any!)
        if (price > 0) {
            // Calculate the auctioneer's cut.
            // (NOTE: _computeCut() is guaranteed to return a
            // value <= price, so this subtraction can't go negative.)
            uint256 auctioneerCut = _computeCut(price);
            uint256 sellerProceeds = price - auctioneerCut;

            // NOTE: Doing a transfer() in the middle of a complex
            // method like this is generally discouraged because of
            // reentrancy attacks and DoS attacks if the seller is
            // a contract with an invalid fallback function. We explicitly
            // guard against reentrancy attacks by removing the auction
            // before calling transfer(), and the only thing the seller
            // can DoS is the sale of their own asset! (And if it's an
            // accident, they can call cancelAuction(). )
            seller.transfer(sellerProceeds);
        }

        // Calculate any excess funds included with the bid. If the excess
        // is anything worth worrying about, transfer it back to bidder.
        // NOTE: We checked above that the bid amount is greater than or
        // equal to the price so this cannot underflow.
        uint256 bidExcess = _bidAmount - price;

        // Return the funds. Similar to the previous transfer, this is
        // not susceptible to a re-entry attack because the auction is
        // removed before any transfers occur.
        msg.sender.transfer(bidExcess);

        AuctionSuccessful(_tokenId, price, msg.sender);

        return price;
    }

    // Removes an auction from the list of open auctions.
    // _tokenId - ID of NFT on auction.
    function _removeAuction(uint256 _tokenId) internal {
        delete tokenIdToAuction[_tokenId];
    }

    // Returns true if the NFT is on auction.
    // _auction - Auction to check.
    function _isOnAuction(Auction storage _auction) internal view returns (bool) {
        return (_auction.startedAt > 0);
    }

    // Computes owner's cut of a sale.
    // _price - Sale price of NFT.
    function _computeCut(uint256 _price) internal view returns (uint256) {
        // NOTE: We don't use SafeMath (or similar) in this function because
        //  all of our entry functions carefully cap the maximum values for
        //  currency (at 128-bits), and ownerCut <= 10000 (see the require()
        //  statement in the ClockAuction constructor). The result of this
        //  function is always guaranteed to be <= _price.
        return _price * ownerCut / 10000;
    }

}

contract ClockAuction is ClockAuctionBase, Pausable	 {

    // Constructor creates a reference to the NFT ownership contract
    //  and verifies the owner cut is in the valid range.
    // _nftAddress - address of a deployed contract implementing
    //  the Nonfungible Interface.
    // _cut - percent cut the owner takes on each auction, must be
    //  between 0-10,000.
    function ClockAuction(address _nftAddress, uint256 _cut) public {
        require(_cut <= 10000);
        ownerCut = _cut;

        ERC721 candidateContract = ERC721(_nftAddress);
        nonFungibleContract = candidateContract;
    }

    // Remove all Ether from the contract, which is the owner's cuts
    //  as well as any Ether sent directly to the contract address.
    //  Always transfers to the NFT contract, but can be called either by
    //  the owner or the NFT contract.
    function withdrawBalance() external {
        address nftAddress = address(nonFungibleContract);

        require(
            msg.sender == owner ||
            msg.sender == nftAddress
        );
        
        nftAddress.transfer(this.balance);
    }

    // Creates and begins a new auction.
    // _tokenId - ID of token to auction, sender must be owner.
    // _startingPrice - Price of item (in wei) at beginning of auction.
    // _endingPrice - Price of item (in wei) at end of auction.
    // _duration - Length of time to move between starting
    //  price and ending price (in seconds).
    // _seller - Seller, if not the message sender
    function createAuction(
        uint256 _tokenId,
        uint256 _price,
        uint256 _duration,
        address _seller
    )
        external
        whenNotPaused
    {
        // Sanity check that no inputs overflow how many bits we've allocated
        // to store them in the auction struct.
        require(_price == uint256(uint64(_price)));
        require(_duration == uint256(uint64(_duration)));

        require(_owns(msg.sender, _tokenId));
        _escrow(msg.sender, _tokenId);
        Auction memory auction = Auction(
            _seller,
            uint128(_price),
            uint64(_duration),
            uint64(now)
        );
        _addAuction(_tokenId, auction);
    }

    // Bids on an open auction, completing the auction and transferring
    //  ownership of the NFT if enough Ether is supplied.
    // _tokenId - ID of token to bid on.
    function bid(uint256 _tokenId)
        external
        payable
        whenNotPaused
    {
        // _bid will throw if the bid or funds transfer fails
        _bid(_tokenId, msg.value);
        _transfer(msg.sender, _tokenId);
    }

    // Cancels an auction that hasn't been won yet.
    //  Returns the NFT to original owner.
    // This is a state-modifying function that can
    //  be called while the contract is paused.
    // _tokenId - ID of token on auction
    function cancelAuction(uint256 _tokenId)
        external
    {
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(_isOnAuction(auction));
        address seller = auction.seller;
        require(msg.sender == seller);
        _cancelAuction(_tokenId, seller);
    }

    // Cancels an auction when the contract is paused.
    //  Only the owner may do this, and NFTs are returned to
    //  the seller. This should only be used in emergencies.
    // _tokenId - ID of the NFT on auction to cancel.
    function cancelAuctionWhenPaused(uint256 _tokenId)
        whenPaused
        onlyOwner
        external
    {
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(_isOnAuction(auction));
        _cancelAuction(_tokenId, auction.seller);
    }

    // Returns auction info for an NFT on auction.
    // _tokenId - ID of NFT on auction.
    function getAuction(uint256 _tokenId)
        external
        view
        returns
    (
        address seller,
        uint256 price,
        uint256 duration,
        uint256 startedAt
    ) {
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(_isOnAuction(auction));
        return (
            auction.seller,
            auction.price,
            auction.duration,
            auction.startedAt
        );
    }

    // Returns the current price of an auction.
    // _tokenId - ID of the token price we are checking.
    function getCurrentPrice(uint256 _tokenId)
        external
        view
        returns (uint256)
    {
        Auction storage auction = tokenIdToAuction[_tokenId];
        require(_isOnAuction(auction));
        return auction.price;
    }
}

contract SaleClockAuction is ClockAuction {

    // Sanity check that allows us to ensure that we are pointing to the
    //  right auction in our setSaleAuctionAddress() call.
    bool public isSaleClockAuction = true;

    // Tracks last 5 sale price of gen0 planet sales
    uint256 public gen0SaleCount;
    uint256[5] public lastGen0SalePrices;

    // Delegate constructor
    function SaleClockAuction(address _nftAddr, uint256 _cut) public
        ClockAuction(_nftAddr, _cut) {}

    // Creates and begins a new auction.
    // _tokenId - ID of token to auction, sender must be owner.
    // _startingPrice - Price of item (in wei) at beginning of auction.
    // _endingPrice - Price of item (in wei) at end of auction.
    // _duration - Length of auction (in seconds).
    // _seller - Seller, if not the message sender
    function createAuction(
        uint256 _tokenId,
        uint256 _price,
        uint256 _duration,
        address _seller
    )
        external
    {
        // Sanity check that no inputs overflow how many bits we've allocated
        // to store them in the auction struct.
        require(_price == uint256(uint128(_price)));
        require(_duration == uint256(uint64(_duration)));

        require(msg.sender == address(nonFungibleContract));
        _escrow(_seller, _tokenId);
        Auction memory auction = Auction(
            _seller,
            uint128(_price),
            uint64(_duration),
            uint64(now)
        );
        _addAuction(_tokenId, auction);
    }

    // Updates lastSalePrice if seller is the nft contract
    // Otherwise, works the same as default bid method.
    function bid(uint256 _tokenId)
        external
        payable
    {
        // _bid verifies token ID size
        address seller = tokenIdToAuction[_tokenId].seller;
        uint256 price = _bid(_tokenId, msg.value);
        _transfer(msg.sender, _tokenId);

        // If not a gen0 auction, exit
        if (seller == address(nonFungibleContract)) {
            // Track gen0 sale prices
            lastGen0SalePrices[gen0SaleCount % 5] = price;
            gen0SaleCount++;
        }
    }

    function averageGen0SalePrice() external view returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < 5; i++) {
            sum += lastGen0SalePrices[i];
        }
        return sum / 5;
    }

}

contract SpaceAuction is SpaceOwnership {

    // Sets the reference to the sale auction.
    // _address - Address of sale contract.
    function setSaleAuctionAddress(address _address) external onlyCEO {
        SaleClockAuction candidateContract = SaleClockAuction(_address);

        // NOTE: verify that a contract is what we expect - https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
        require(candidateContract.isSaleClockAuction());

        // Set the new contract address
        saleAuction = candidateContract;
    }

    // Put a planet up for auction.
    //  Does some ownership trickery to create auctions in one tx.
    function createSaleAuction(
        uint256 _planetId,
        uint256 _price,
        uint256 _duration
    )
        external
        whenNotPaused
    {
        // Auction contract checks input sizes
        // If planet is already on any auction, this will throw
        // because it will be owned by the auction contract.
        require(_owns(msg.sender, _planetId));
        // Ensure the planet is not pregnant to prevent the auction
        // contract accidentally receiving ownership of the child.
        // NOTE: the planet IS allowed to be in a cooldown.
        _approve(_planetId, saleAuction);
        // Sale auction throws if inputs are invalid and clears
        // transfer and sire approval after escrowing the planet.
        saleAuction.createAuction(
            _planetId,
            _price,
            _duration,
            msg.sender
        );
    }

    // Transfers the balance of the sale auction contract
    // to the PlanetCore contract. We use two-step withdrawal to
    // prevent two transfer calls in the auction bid function.
    function withdrawAuctionBalances() external onlyCLevel {
        saleAuction.withdrawBalance();
    }
}