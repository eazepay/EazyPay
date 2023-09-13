// SPDX-License-Identifier: MIT License
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EazePay is ERC20 {
    address public controller;
    // Owner of the contract
    address public owner;

    uint256 public userId = 1000;

    // ====================== MAPPINGS ===================== //git
    // Mapping of currency symbols to their respective prices
    mapping(string => uint256) public currencyPrices;
    // Mapping of user IDs to their user addresses
    mapping(uint256 => address) public userId_Address;
    // Mapping of user IDs to their usernames;
    mapping(uint256 => string) public userId_Username;
    //
    mapping(uint256 => uint256) public idToBalance;

    // ====================== EVENTS ===================== //

    // Event to log currency withdrwaw
    event CurrencyWithdraw(
        address indexed user,
        string currencySymbol,
        uint256 amount,
        uint256 tokens
    );

    event rechargedToken(
        address indexed user,
        string currencySymbol,
        uint256 amount
    );
    event joined(address user, uint256 id);

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        controller = msg.sender;
        owner = msg.sender;
    }

    modifier onlyController() {
        require(
            msg.sender == controller,
            "Only the controller can perform this operation"
        );
        _;
    }

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function mint(address account, uint256 amount) internal  {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) internal  {
        _burn(account, amount);
    }

    function setController(address newController) public onlyController {
        controller = newController;
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
        uint256 currencyPrice = currencyPrices[currencySymbol];
        require(currencyPrice > 0, "Currency not supported");

        // Calculate the required token amount based on the currency and amount
        uint256 requiredTokens = amount / currencyPrice;

        // Check if the user has enough tokens
        require(idToBalance[id] >= requiredTokens, "Insufficient balance");
        idToBalance[id] -= requiredTokens;
        // burn user tokens
        burn(userId_Address[id], requiredTokens);

        // emit withdraw event
        emit CurrencyWithdraw(
            userId_Address[id],
            currencySymbol,
            amount,
            requiredTokens
        );
    }

    function recharge(
        uint256 id,
        string memory currencySymbol,
        uint256 amount
    ) external {
        uint256 currencyPrice = currencyPrices[currencySymbol];
        // Calculate the recharge token amount based on the currency and amount
        uint256 totalTokenPrice = amount / currencyPrice;
        idToBalance[id] += totalTokenPrice;
        mint(msg.sender, totalTokenPrice);

        // emit recharge event
        emit rechargedToken(msg.sender, currencySymbol, amount);
    }

    function join(string memory username) external {
        userId_Address[userId] = msg.sender;
        userId_Username[userId] = username;
        idToBalance[userId];
        userId++;
        emit joined(msg.sender, userId);
    }
}

