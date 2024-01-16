
import { ethers } from 'hardhat'
import { parseEther } from 'ethers/lib/utils';
import test_util from './util'
const colors = require('colors/safe');

async function main() {
    const [deployer] = await ethers.getSigners();
    if (deployer === undefined) throw new Error("Deployer is undefined.");

    const mockToken = {
        name: "testt",
        symbol: "test",
        supply: "1000000000",
        router: "0xDf247000F750AE87CE8C1a5E2c059592C9D0B09e",
        _amountForPool: "0"
    }

    const factory = await ethers.getContractFactory("Token");
    const contract = await factory.deploy(mockToken.name, mockToken.symbol, mockToken.supply, mockToken.router, mockToken._amountForPool)
    await contract.deployed()
    console.log(colors.cyan(" Address: ") + colors.yellow(contract.address));
    //await test_util.sleep("30")
    //await test_util.verify(contract.address, "Token", [mockToken.name, mockToken.symbol, mockToken.supply, mockToken.router, parseEther(mockToken.ethLiquidityAmount), parseEther(mockToken.tokenLiquidityAmount)])

}

async function deploy(name: string, symbol: string, supply: string, to: string) {
    let contractName = "Token"
    const contractFactory = await ethers.getContractFactory(contractName);
    const token = await contractFactory.deploy(name, symbol, 18, parseEther(supply), to);
    console.log(colors.cyan(name + " Address: ") + colors.yellow(token.address));
    await test_util.sleep("15");
}

main()
    .then(async (r: any) => {
        console.log("");
        return r;
    })
    .catch(error => {
        console.log(colors.red("ERROR :("));
        console.log(colors.red(error));
        return undefined;
    })


