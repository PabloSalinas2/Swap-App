// SPDX-License-Identifier: MIT
// forge test -vvvv --fork-url https://arb1.arbitrum.io/rpc --match-test 

pragma solidity 0.8.24;

import "../src/SwapApp.sol";
import "../lib/forge-std/src/Test.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract SwapAppTest is Test {
    
    SwapApp public swapApp;
    address public addressV2Router02 = 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24;
    address public  dai= 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1; // 18 decimals 
    address public usdc= 0xaf88d065e77c8cC2239327C5EDb3A432268e5831; // 6 decimals
    address public randomUser= vm.addr(1);

    function setUp() external {
        swapApp= new SwapApp(addressV2Router02);
        
    }

    function testSwapTokens() external{
        uint256 amountIn=50* 1e6;
        uint256 amountOutMin= 49*1e18;
        address[] memory path= new address[](2);
        path[0]=usdc;
        path[1]= dai;
        uint deadline=1793461139 + 100000000;

        vm.startPrank(randomUser);
        deal(usdc,randomUser,amountIn);

        uint256 daiBalanceUserBefore=IERC20(dai).balanceOf(randomUser);
        uint256 usdcBalanceUserBefore= IERC20(usdc).balanceOf(randomUser);
        IERC20(usdc).approve(address(swapApp),amountIn);
        swapApp.swapTokens(amountIn,amountOutMin, path, deadline);
        uint256 daiBalanceUserAfter=IERC20(dai).balanceOf(randomUser);
        uint256 usdcBalanceUserAfter= IERC20(usdc).balanceOf(randomUser);


        assert(daiBalanceUserAfter > daiBalanceUserBefore);
        assert(usdcBalanceUserBefore - amountIn == usdcBalanceUserAfter);

        vm.stopPrank();
    }
}