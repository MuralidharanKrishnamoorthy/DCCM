// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract CarbonCreditMarketplace {
    
    // USDC contract address (Polygon network)
    address public usdcTokenAddress = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174; // USDC on Polygon
    IERC20 public usdcToken = IERC20(usdcTokenAddress);

    struct Credit {
        uint256 id;
        string documentURI;  // IPFS link to the document proving the carbon credit
        uint256 price;       // Price in USDC (e.g., 100 USDC)
        address owner;       // The current owner of the credit
        bool availableForSale;
    }

    mapping(uint256 => Credit) public credits;
    uint256 public creditCount = 0;

    // Events for logging
    event CreditCreated(uint256 id, string documentURI, uint256 price, address indexed owner);
    event CreditPurchased(uint256 id, address indexed from, address indexed to, uint256 price);

    // Developer creates a carbon credit
    function createCredit(string memory _documentURI, uint256 _price) public {
        creditCount++;
        credits[creditCount] = Credit(creditCount, _documentURI, _price, msg.sender, true);
        
        emit CreditCreated(creditCount, _documentURI, _price, msg.sender);
    }

    // Company purchases the carbon credit by sending USDC
    function purchaseCredit(uint256 _id) public {
        Credit storage credit = credits[_id];
        require(credit.availableForSale, "This credit is not available for sale");
        require(credit.owner != msg.sender, "You already own this credit");
        require(usdcToken.balanceOf(msg.sender) >= credit.price, "Insufficient USDC balance");

        // Transfer USDC from buyer (company) to the seller (developer)
        require(usdcToken.transferFrom(msg.sender, credit.owner, credit.price), "USDC transfer failed");

        // Transfer ownership of the carbon credit to the buyer
        address previousOwner = credit.owner;
        credit.owner = msg.sender;
        credit.availableForSale = false;  // Mark credit as sold

        emit CreditPurchased(_id, previousOwner, msg.sender, credit.price);
    }
}
