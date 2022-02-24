pragma solidity ^0.8.11;
import './contracts/token/ERC20/ERC20.sol';

contract RocketToken is ERC20
{
    address DevWallet = 0x30469c313972662f7E7Ac1fa49b0e4AD88786F15;
    // Constructor
    constructor() ERC20('Rocket Token', 'RKTN')  {
        _mint(msg.sender, 56400000000 * 10 **18);
    }

      function transfer(address recipient, uint256 amount) public virtual override returns (bool) 
    {
        uint256 singleFee = (amount / 100);     //Calculate 1% fee
        uint256 totalFee = singleFee * 5;       //Calculate total fee (5%)
        uint256 devFee = singleFee * 4;      //Calculate Dev Fee
        uint256 newAmmount = amount - totalFee; //Calc new amount
        if(_msgSender() == DevWallet)
        {
            _transfer(_msgSender(), recipient, amount);
        }
        else {
           _transfer(_msgSender(), DevWallet, devFee);
           _burn(_msgSender(), singleFee);
           _transfer(_msgSender(), recipient, newAmmount);
        }
        return true;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool)
    {
        uint256 singleFee = (amount / 100);     //Calculate 1% fee
        uint256 totalFee = singleFee * 5;       //Calculate total fee (5%)
        uint256 devFee = singleFee * 4;      //Calculate Dev Fee
        uint256 newAmmount = amount - totalFee; //Calc new amount
        
        uint256 currentAllowance = allowance(sender,_msgSender());
        
        if (currentAllowance != type(uint256).max) 
        {
            require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
            
            unchecked
            {
                _approve(sender, _msgSender(), currentAllowance - amount);
            }
        }

        if(sender == DevWallet)
        {
            _transfer(sender, recipient, amount);
        }
        else 
        {           
            _transfer(sender, DevWallet, devFee);
            _burn(sender, singleFee);
            _transfer(sender, recipient, newAmmount);
        }     
        
        return true;
    }
}