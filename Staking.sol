pragma solidity  ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract Staking {

    address public addressToken;
    uint256 public procent;
    mapping(address => uint256) public stakeAddressTime;
    mapping(address => uint256) public stakeAddressAmount;

    constructor(address _addressToken, uint256 _procent){
        addressToken = _addressToken;
        procent = _procent;
    }

    function addLiqudity(uint256 amount) public payable {
        IERC20 token = IERC20(addressToken);
        token.transferFrom(msg.sender, address(this), amount);
    }

    function tokenApprove(address contractAddress) public payable {
        IERC20 token = IERC20(addressToken);
        token.approve(contractAddress, 99999999999999999999999999999999999999999);
    }

    function stake(uint256 amount) public payable {
        require(amount >= msg.value, 'staking error');
        require(stakeAddressTime[msg.sender] == 0, 'allredy staked');
        IERC20 token = IERC20(addressToken);
        token.transferFrom(msg.sender, address(this), amount);
        uint256 time = block.timestamp;
        stakeAddressTime[msg.sender] = time;
        stakeAddressAmount[msg.sender] += amount;
    }

    function unstake() public payable{
        require(stakeAddressAmount[msg.sender] != 0, '0 staked');
        uint256 amount = stakeAddressAmount[msg.sender];
        uint256 time = stakeAddressTime[msg.sender];

        uint256 reward = amount *  (block.timestamp - time)/60e2/24/365 * procent;
        uint256 staked = reward + amount;

        IERC20 token = IERC20(addressToken);
        token.transferFrom(address(this), msg.sender, staked);
    }

}
