const express = require('express');
const http = require('http');
const axios = require('axios');
const execa = require('execa');
require("dotenv").config();

const app = express();

app.use(express.urlencoded({ extended: true }))
app.use(express.json());

function isValid(string) {
    // Makes sure the string matches the pattern of X.X.X
    return string.match(/^(\d+\.)?(\d+\.)?(\*|\d+)$/)
}

app.post("/slack", async (req, res) => {
    const arguments = req.body.text;
    console.log(`received request for ${arguments}`)
    if (arguments === "install") {
        res.send(`Install the app @ ${req.protocol}://${req.get('host')}/install`)
        return;
    }
    if (!isValid(arguments)) {
        res.send({
            "response_type": "ephemeral",
            "text": "request failed — please send in a version number like X.X.X"
        })
    } else {
        const version = arguments
        const responseUrl = req.body.response_url;

        res.send(`Received request to release version ${version}. Working on it right now (Expect to hear back in ~5 minutes)`)
        
        // run script
        const {stdout} = await execa("bash", ["script.sh", version])


        axios({
            method: 'post',
            url: responseUrl,
            data: {
                "response_type" : "in_channel",
                "text" : `bumped to ${version} - authorize the PR @ ${stdout}`
            }
        })
    }
})

app.get("/", (req, res) => {
    res.redirect("https://useoptic.com")
})

http.createServer(app).listen(process.env.OPTIC_API_PORT || process.env.PORT || 4000)