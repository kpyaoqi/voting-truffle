const Web3 = require("web3");
const web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
exports.getId= async function(){
    await web3.eth.net.getId().then(res=>{
        networkId=res;
    });
    return networkId;
}