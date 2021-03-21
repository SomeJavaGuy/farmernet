const Farmernet = artifacts.require('FarmernetLand')
const TOKENID = 0
module.exports = async callback => {
    const dnd = await Farmernet.deployed()
    console.log('Let\'s set the tokenURI of your Lands')
    const tx = await dnd.setTokenURI(0, "https://ipfs.io/ipfs/Qmb5iojS3iwz7xZRk9xq9Lf4faLdjYtJ5ftFUN1w6gj7t5?filename=farmland1.jpeg")
    const tx1 = await dnd.setTokenURI(1, "https://ipfs.io/ipfs/QmNU8CWbd7UYDBqNLUxYGJGjA5AzoFowSVRUv2AFXWBZCM?filename=farmland2.jpeg")
    const tx2 = await dnd.setTokenURI(2, "https://ipfs.io/ipfs/QmebqM2QmVfyPAH7i4zXzh2HHy2srfW3URqWBE2J2Z1UVJ?filename=farmland3.jpeg")
    console.log(tx)
    callback(tx.tx)
}
