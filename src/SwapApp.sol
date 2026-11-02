// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import "../src/IV2Router02.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract SwapApp {

    address public addressV2Router02;

    event SwapTokens(address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);

    constructor(address addressV2Router02_) {
        addressV2Router02= addressV2Router02_;
    }

// contrato para swapear de usdc a dai 
    function swapTokens(uint256 amountIn_,uint256 amountOutMin_, address[] memory path, uint deadline_) external {
        
        IERC20(path[0]).transferFrom(msg.sender, address(this), amountIn_);
        IERC20(path[0]).approve(addressV2Router02,amountIn_);
        
        IV2Router02(addressV2Router02).swapExactTokensForTokens( amountIn_,  amountOutMin_, path, msg.sender, deadline_);
        
        emit SwapTokens(path[0], path[path.length-1],amountIn_,amountOutMin_);
    }

}

// se transfiere la moneda entrante desde la direccion del usuario hacia el contrato 
// se aprueba al router a quitar dichos tokens 
// se trnasfieren los usdc al router 
// el router devuelve un arreglo de enteros, por que un arreglo y no un solo valor ? 