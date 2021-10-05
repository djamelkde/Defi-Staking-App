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
        owner = msg.sender;
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

    //Issue rewards after staking
    function issueTokens() public {
        //lets require the owner to issue reward tokens
        require(msg.sender == owner, "The caller must be the owner");
        for(uint i = 0; i < stakers.length; i++) {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient] / 9; // divide by 9 to create percentage incentive
            if(balance > 0){
                rwd.transfer(recipient, balance);
            }
        }
    }

    // Unstake tokens
    function unstakeTokens() public {
        uint balance = stakingBalance[msg.sender];
        require(balance > 0, "staking balance cannot be less than 0");
        //Transfer the tokens to the specified contract address from our bank
        tether.transfer(msg.sender, balance);
        
        //reset Staking balance
        stakingBalance[msg.sender] = 0;
        
        //Update Staking status
        isStaking[msg.sender] = false;
    }

}