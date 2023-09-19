// SPDX-License-Identifier: MIT License
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EazePay is ERC20 {
   
    // Owner of the contract
    address public owner;

    uint256 public userId = 1000;

    struct UserDetails {
        string username;
        bool isActive;
        address userAddress;
        uint256 userId;
        uint256 balance;
    }

    // ====================== MAPPINGS ===================== //

    // Mapping of currency symbols to their respective prices
    mapping(string => uint256) public currencyPrices;
   // Mapping of user IDs to their user details
    mapping(uint256 => UserDetails) public userIdToDetails;
    // Mapping of user addresses to their user IDs
    mapping(address => uint256) public addressToUserId;

    // ====================== EVENTS ===================== //

       // Event to log currency withdrawal
    event CurrencyWithdrawal(
        address indexed user,
        string currencySymbol,
        uint256 amount
    );

    event RechargedToken(
        address indexed user,
        string currencySymbol,
        uint256 amount
    );

    event Joined(address indexed user, uint256 userId);

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        owner = msg.sender;
    }

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }

    function mint(address account, uint256 amount) internal  {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) internal  {
        _burn(account, amount);
    }


    // Add or update the price of a currency
    function setCurrencyPrice(
        string memory currencySymbol,
        uint256 price
    ) external onlyOwner {
        currencyPrices[currencySymbol] = price;
    }

    // Function to exchange currency for tokens
    function withdraw(
        uint256 id,
        string memory currencySymbol,
        uint256 amount
    ) external {
        require(id > 0, "Invalid User Id");
        require(userIdToDetails[id].isActive, "User not Active"); 
        uint256 currencyPrice = currencyPrices[currencySymbol];
        require(currencyPrice > 0, "Currency not supported");

        // Calculate the required token amount based on the currency and amount
        uint256 requiredTokens = amount / currencyPrice;

        // Check if the user has enough tokens
        require(userIdToDetails[id].balance >= requiredTokens, "Insufficient balance");
        userIdToDetails[id].balance -= requiredTokens;
        // burn user tokens
        burn(userIdToDetails[id].userAddress, requiredTokens);

        // emit withdraw event
        emit CurrencyWithdrawal(
            userIdToDetails[id].userAddress,
            currencySymbol,
            requiredTokens
        );
    }

    function recharge(
        uint256 id,
        string memory currencySymbol,
        uint256 amount
    ) external {
        require(id > 0, "Invalid User Id");
        require(userIdToDetails[id].isActive, "User not Active"); 
        uint256 currencyPrice = currencyPrices[currencySymbol];
        // Calculate the recharge token amount based on the currency and amount
        uint256 totalTokenPrice = amount / currencyPrice;

        mint(msg.sender, totalTokenPrice);
        // Update user's balance in UserDetails struct
        userIdToDetails[id].balance += totalTokenPrice;
        // emit recharge event
        emit RechargedToken(msg.sender, currencySymbol, amount);
    }

    function pauseUser(uint256 id) external {
        require(id > 0, "Invalid User Id");
        require(userIdToDetails[id].userAddress == msg.sender, "only user can pause");
        require(userIdToDetails[id].isActive, "User already paused"); 
        userIdToDetails[id].isActive = false;
    }

     function unPauseUser(uint256 id) external {
        require(id > 0, "Invalid User Id");
        require(userIdToDetails[id].userAddress == msg.sender, "only user can unPause");
        require(!userIdToDetails[id].isActive, "User not paused"); 
        userIdToDetails[id].isActive = true;
    }

    function join(string memory username) external {
      require(addressToUserId[msg.sender] == 0, "User already registered");

        userIdToDetails[userId] = UserDetails({
            username: username,
            isActive: true,
            userId: userId,
            userAddress: msg.sender,
            balance: 0
        });

        addressToUserId[msg.sender] = userId;

        emit Joined(msg.sender, userId);

        userId++;
    } 
}
