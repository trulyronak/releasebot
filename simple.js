const execa = require("execa")
async function test() {
    const version = "8.2.3"
    const {stdout, stderr} = await execa("bash", ["script.sh", version])
    console.log(stdout)
    console.log(stderr)
}

test()