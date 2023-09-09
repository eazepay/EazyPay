// SPDX-License-Identifier: MIT License
pragma solidity 0.8.17;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EazePay is ERC20 {
    address public controller;
    // Owner of the contract
    address public owner;
    // Mapping of currency symbols to their respective prices
    mapping(string => uint256) public currencyPrices;

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

    function mint(address account, uint256 amount) public onlyController {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) public onlyController {
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
        address user,
        string memory currencySymbol,
        uint256 amount
    ) external {
        uint256 currencyPrice = currencyPrices[currencySymbol];
        require(currencyPrice > 0, "Currency not supported");

        // Calculate the required token amount based on the currency and amount
        uint256 requiredTokens = currencyPrice * amount;

        // Check if the user has enough tokens
        require(balanceOf(user) >= requiredTokens, "Insufficient balance");

        // burn user tokens
        burn(user, requiredTokens);

        // emit event
        emit CurrencyWithdraw(user, currencySymbol, amount, requiredTokens);
    }

    // Event to log currency withdrwaw
    event CurrencyWithdraw(
        address indexed user,
        string currencySymbol,
        uint256 amount,
        uint256 tokens
    );

    function recharge(
        address user,
        string memory currencySymbol,
        uint256 amount
    ) external {
        uint256 currencyPrice = currencyPrices[currencySymbol];
        // Calculate the recharge token amount based on the currency and amount
        uint256 totalTokenPrice = currencyPrice * amount;
        mint(user, totalTokenPrice);

        emit rechargedToken(user, currencySymbol, amount);
    }

    event rechargedToken(
        address indexed user,
        string currencySymbol,
        uint256 amount
    );
}