// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Ownable} from 'openzeppelin-contracts/contracts/access/Ownable.sol';
import {AccessControl} from 'openzeppelin-contracts/contracts/access/AccessControl.sol';
import {SafeMath} from 'openzeppelin-contracts/contracts/utils/math/SafeMath.sol';

import {ERC20} from 'openzeppelin-contracts/contracts/token/ERC20/ERC20.sol';
import {IERC20} from 'openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';

import {SafeERC20} from 'openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol';
import {ERC20Burnable} from 'openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol';


/**
 * @title KibaRewardToken
 * @dev ERC20 token for Kiba Rewards, with minting and burning capabilities.
 */
contract KibaRewardToken is ERC20, ERC20Burnable, Ownable, AccessControl {
    using SafeMath for uint256;
    using SafeERC20 for ERC20;

    /**
     * @dev Mapping of balances for each address.
     */
    mapping(address => uint256) private _balances;

    /**
     * @dev Total supply of tokens.
     */
    uint256 private _totalSupply;
  
    /**
     * @dev Role identifier for the manager.
     */
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    /**
     * @dev Initializes the contract with the token name and symbol.
     */
    constructor() ERC20("Kiba Rewards Token", "KRT") {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(MANAGER_ROLE, _msgSender());
    }

    /**
     * @dev Mints tokens to a specified address.
     * @param to The address to mint tokens to.
     * @param amount The amount of tokens to mint.
     */
    function mint(address to, uint256 amount) external {
        require(hasRole(MANAGER_ROLE, _msgSender()), "You're Not Allowed To Call This Function");
        _totalSupply = _totalSupply.add(amount);
        _balances[to] = _balances[to].add(amount);
        _mint(to, amount);
    }

    /**
     * @dev Transfers tokens safely to a specified address.
     * @param _to The address to transfer tokens to.
     * @param _amount The amount of tokens to transfer.
     */
    function safeKRTTransfer(address _to, uint256 _amount) external {
        require(hasRole(MANAGER_ROLE, _msgSender()), "You're Not Allowed To Call This Function");
        uint256 krtBalance = balanceOf(address(this));
        if (_amount > krtBalance){
          transfer(_to, krtBalance);
        }
        else {
          transfer(_to, _amount);
        }
    }
}