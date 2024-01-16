//  ██████╗██████╗ ███████╗ █████╗ ████████╗███████╗██████╗      ██████╗ ███╗   ██╗     █████╗ ██████╗ ██████╗  █████╗ ██╗███╗   ██╗ ██████╗██╗  ██╗   ██╗ ██████╗ 
// ██╔════╝██╔══██╗██╔════╝██╔══██╗╚══██╔══╝██╔════╝██╔══██╗    ██╔═══██╗████╗  ██║    ██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║████╗  ██║██╔════╝██║  ██║   ██║██╔═══██╗
// ██║     ██████╔╝█████╗  ███████║   ██║   █████╗  ██║  ██║    ██║   ██║██╔██╗ ██║    ███████║██████╔╝██████╔╝╚██████║██║██╔██╗ ██║██║     ███████║   ██║██║   ██║
// ██║     ██╔══██╗██╔══╝  ██╔══██║   ██║   ██╔══╝  ██║  ██║    ██║   ██║██║╚██╗██║    ██╔══██║██╔═══╝ ██╔═══╝  ╚═══██║██║██║╚██╗██║██║     ██╔══██║   ██║██║   ██║
// ╚██████╗██║  ██║███████╗██║  ██║   ██║   ███████╗██████╔╝    ╚██████╔╝██║ ╚████║    ██║  ██║██║     ██║██╗   █████╔╝██║██║ ╚████║╚██████╗██║  ██║██╗██║╚██████╔╝
//  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═════╝      ╚═════╝ ╚═╝  ╚═══╝    ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝   ╚════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝ ╚═════╝ 

// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract Token is ERC20, ERC20Burnable {
    IUniswapV2Router02 public router;
    address public poolManager = 0xf221cEEfd6D194Cf97Bb249c50cb2A33aEbb6AB2;

    receive() external payable {}

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _supply,
        address _routerAddress,
        uint256 _amountForPool
    ) ERC20(_name, _symbol) {
        _mint(msg.sender, _supply * 10 ** decimals());
        router = IUniswapV2Router02(_routerAddress);
        _approve(msg.sender, address(this), type(uint256).max);
        _approve(msg.sender, _routerAddress, type(uint256).max);
        _approve(address(this), _routerAddress, type(uint256).max);

        if (_amountForPool > 0) {
            transferFrom(msg.sender, address(this), _amountForPool);
        }
    }

    function addLiquidity(
        uint256 ethAmount,
        uint256 tokenAmount
    ) external payable {
        _addLiquidity(ethAmount, tokenAmount);
    }

    function _addLiquidity(uint256 ethAmount, uint256 tokenAmount) private {
        transferFrom(msg.sender, address(this), tokenAmount);
        _approve(address(this), address(router), tokenAmount);

        router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            msg.sender,
            block.timestamp + 300
        );
    }
}
