// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Investment is ReentrancyGuard, Ownable {
    IERC20 public usdt;
    IERC20 public companyToken;
    uint256 public investmentDurationShort = 45 days;
    uint256 public investmentDurationLong = 180 days;
    uint256 public investmentReturnShort = 18;
    uint256 public investmentReturnLong = 48;
    uint256 public companyTokenBoost = 5;

    struct InvestmentInfo {
        uint256 amount;
        uint256 duration;
        uint256 returnPercentage;
        uint256 startTime;
    }

    mapping(address => InvestmentInfo) public investments;

    event InvestmentMade(address indexed investor, uint256 amount, uint256 duration);
    event InvestmentWithdrawn(address indexed investor, uint256 returnAmount);

    constructor(address _usdtAddress, address _companyTokenAddress) {
        usdt = IERC20(_usdtAddress);
        companyToken = IERC20(_companyTokenAddress);
    }

    function invest(uint256 _amount, uint256 _duration) public nonReentrant {
        require(_amount > 0, "Investment amount must be greater than zero");
        require(_duration == investmentDurationShort || _duration == investmentDurationLong, "Invalid investment duration");
        require(usdt.transferFrom(msg.sender, address(this), _amount), "USDT transfer failed");

        uint256 returnPercentage = _duration == investmentDurationShort ? investmentReturnShort : investmentReturnLong;

        if (companyToken.balanceOf(msg.sender) > 0) {
            returnPercentage += companyTokenBoost;
        }

        investments[msg.sender] = InvestmentInfo(_amount, _duration, returnPercentage, block.timestamp);

        emit InvestmentMade(msg.sender, _amount, _duration);
    }

    function withdraw() public nonReentrant {
        InvestmentInfo storage investment = investments[msg.sender];
        require(investment.amount > 0, "No investment found");
        require(block.timestamp >= investment.startTime + investment.duration, "Investment duration not reached");

        uint256 returnAmount = investment.amount * (100 + investment.returnPercentage) / 100;
        require(usdt.transfer(msg.sender, returnAmount), "USDT transfer failed");

        delete investments[msg.sender];

        emit InvestmentWithdrawn(msg.sender, returnAmount);
    }

    function setCompanyTokenBoost(uint256 _companyTokenBoost) public onlyOwner {
        companyTokenBoost = _companyTokenBoost;
    }

    function recoverFunds(IERC20 _token) public onlyOwner {
        uint256 balance = _token.balanceOf(address(this));
        require(_token.transfer(msg.sender, balance), "Token transfer failed");
    }

    function setInvestmentDurationShort(uint256 _investmentDurationShort) public onlyOwner {
        investmentDurationShort = _investmentDurationShort;
    }

    function setInvestmentDurationLong(uint256 _investmentDurationLong) public onlyOwner {
        investmentDurationLong = _investmentDurationLong;
    }

    function setInvestmentReturnShort(uint256 _investmentReturnShort) public onlyOwner {
        investmentReturnShort = _investmentReturnShort;
    }

    function setInvestmentReturnLong(uint256 _investmentReturnLong) public onlyOwner {
        investmentReturnLong = _investmentReturnLong;
    }

    function withdrawFunds(uint256 _amount) public onlyOwner {
        require(usdt.transfer(msg.sender, _amount), "USDT transfer failed");
    }
}
