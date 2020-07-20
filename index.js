const express = require('express');
const bodyParser = require('body-parser');
const http = require('http');
const axios = require('axios');
const execa = require('execa');
require("dotenv").config();

const app = express();

app.use(express.urlencoded({ extended: true }))
app.use(express.json());

function isValid(string) {
    // complex regex
    return string.match(/^(\d+\.)?(\d+\.)?(\*|\d+)$/)
}

app.post("/slack", async (req, res) => {
    const arguments = req.body.text;
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

        res.send(`Received request to release version ${arguments}. Working on it right now`)
        
        // run script
        const {stdout} = await execa("bash", ["script.sh", version])

        axios({
            method: 'post',
            url: responseUrl,
            data: {
                "response_type" : "in_channel",
                "text" : `released ${version}! ${stdout}`
            }
        })
    }
})

// setup github configuration

app.get("/install", (req, res) => {
    const github = new GitHub({ client_id: process.env.GH_CLIENT_ID, client_secret: process.env.GH_CLIENT_SECRET });
    res.redirect(github.authorization_url("repo"));
})

app.get("/", (req, res) => {
    res.send("get :O")
})

http.createServer(app).listen(4000)