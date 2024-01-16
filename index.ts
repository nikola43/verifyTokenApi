const cors = require('cors');
const express = require('express');
const util = require('util');
const exec = util.promisify(require('child_process').exec);

const app = express();
app.use(express.json())    // <==== parse request body as JSON
app.use(express.urlencoded({ extended: true }));

app.use(cors({
    //origin: 'https:website.com'
    origin: '*'
}));

app.get('/', async (req: any, res: any) => {
    res.send("Hello World");
})

app.post('/verify', async (req: any, res: any) => {

    const chainName = req.body.chainName;
    const address = req.body.address;
    const name = req.body.name;
    const symbol = req.body.symbol
    const supply = req.body.supply
    const router = req.body.router
    const amountForPool = req.body.amountForPool

    const command = `npx hardhat verify ${address} ${name} ${symbol} ${supply} ${router} ${amountForPool} --network ` + chainName
    console.log(command);
    try {
        const { stdout, stderr } = await exec(command);
        console.log('stdout:', stdout);
        console.log('stderr:', stderr);
        res.send({
            message: "Verified"
        });
    } catch (error) {
        console.log(error);
        res.send({
            message: error
        });
    }
})


app.listen(9999, () => {
    console.log("Server running on port 9999");
})