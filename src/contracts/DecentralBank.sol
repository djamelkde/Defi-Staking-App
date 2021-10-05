pragma solidity ^0.5.0;

import './RewardToken.sol';
import './Tether.sol';

contract DecentralBank {
    address public owner;
    string public name = 'Decentral Bank';
    Tether public tether;
    RWD public rwd;

    address[] stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(RWD _rwd, Tether _tether) public {
        rwd = _rwd;
        tether = _tether;
    }

    // Staking function
    function depositTokens(uint _amount) public {
        require(_amount > 0, 'amount cannot be 0');
        //Transfer tether tokens to this contract address for staking
        tether.transferFrom(msg.sender, address(this), _amount);
        //update staking balance
        stakingBalance[msg.sender] += _amount;
        if(!hasStaked[msg.sender]){
            stakers.push(msg.sender);
        }
        //update Staking state mappings
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

}