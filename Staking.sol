// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
* @title TKN Token Staking Contract (TKN)
* @author Abdulhakim Altunkaya
* @notice ERC20 token staking with incentive distribution.
*/

import "./openzeppelin/ERC20.sol";
import "./openzeppelin/SafeMath.sol";
import "./openzeppelin/Ownable.sol";

/*
contract TKNToken1 is ERC20 {

    // @dev using SafeMath library for uint256
    using SafeMath for uint256;

    //we’re creating an initialSupply of tokens, which will be assigned to the address that deploys the contract.
    constructor(uint256 initialSupply) ERC20("Gold", "GLD") {
        _mint(msg.sender, initialSupply);
    }
}
*/

contract TKNToken is ERC20, Ownable {
    // using SafeMath library for uint256
    using SafeMath for uint256;

    //initial supply of tokens is assigned to the address that deploys the contract.
    constructor(address _owner, uint256 _supply) {
        _mint(_owner, _supply);
    }

    // array of stakeholder addresses. List do not have to visible.
   address[] internal stakeholders;

    /**
    * @notice The stakes for each stakeholder.
    */ // This mapping below will record the stakeholder's address and his/her stake size.
   mapping(address => uint256) internal stakes;

      /**
    * @notice A method to check if an address is a stakeholder.
    * @param _address The address to verify.
    * @return bool, uint256 Whether the address is a stakeholder,
    * and if so its position in the stakeholders array.
    */
    //This function checks if an address is inside the stakeholders list.
    //If it is, then it will return its return true and its index number. If not,
    //it will return false and 0.
   function isStakeholder(address _address) public view returns(bool, uint) {
       for (uint i = 0; i < stakeholders.length; i++){
           if (_address == stakeholders[i]) return (true, i);
       }
       return (false, 0);
   }

   /**
    * @notice A method to add a stakeholder.
    * @param _stakeholder The stakeholder to add.
    */
    //This function adds an address to the stakeholders list. It is 
    //calling isStakeholder function, storing the bool value in a variable,
    //then if bool value is false, in other words, if it is not inside the 
    //stakeholders list, then it will add it to the end of the list.
    function addStakeholder(address _stakeholder) public {
        (bool _isStakeholder, ) = isStakeholder(_stakeholder);
        if(!_isStakeholder) stakeholders.push(_stakeholder);
    }

   /**
    * @notice A method to remove a stakeholder.
    * @param _stakeholder The stakeholder to remove.
    */
    //This function removes an address from stakeholders list. It does so, by calling 
    //stakeholder function, storing both bool value and uint index number in two variables.
    //Then if bool value is true(if queried element is inside the list), it removes the address
    //by using its index value. One tiny point, after removal the array order changes. Because
    //removal is done by using pop method. It copies last element value to the element that we 
    //want to remove. Then pop.
    function removeStakeholder(address _stakeholder) public {
        (bool _isStakeholder, uint256 s) = isStakeholder(_stakeholder);
        if(_isStakeholder){
            stakeholders[s] = stakeholders[stakeholders.length - 1];
            stakeholders.pop();
        }
    }

   /**
    * @notice A method to retrieve the stake for a stakeholder.
    * @param _stakeholder The stakeholder to retrieve the stake for.
    * @return uint256 The amount of wei staked.
    */
   function stakeOf(address _stakeholder) public view returns(uint256) {
       return stakes[_stakeholder];
   }

   /**
    * @notice A method to the aggregated stakes from all stakeholders.
    * @return uint256 The aggregated stakes from all stakeholders.
    */
   function totalStakes() public view returns(uint256) {
       uint256 _totalStakes = 0;
       for (uint256 s = 0; s < stakeholders.length; s += 1){
           _totalStakes = _totalStakes.add(stakes[stakeholders[s]]);
       }
       return _totalStakes;
   }

}