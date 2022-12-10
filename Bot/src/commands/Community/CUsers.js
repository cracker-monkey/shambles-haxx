const { SlashCommandBuilder } = require('@discordjs/builders');
const { EmbedBuilder } = require('discord.js');
const { Client } = require('discord.js');
const WebSocket = require("ws");
const wss = new WebSocket.Server({ port: 8023 });

var name = "none"
var game = "none"

wss.on("connection", ws => {
    ws.on("message", data => {
        if (data.includes("name-request"))
        {
            name = data.slice(13, data.length);
            console.log(name)
        }
        
        if (data.includes("game-request"))
        {
            game = data.slice(13, data.length);
            console.log(name)
        }
    })

    ws.on("close", () => {
        name = "none"
        game = "none"
    });
})

module.exports = {
    data: new SlashCommandBuilder()
    .setName('current-users')
    .setDescription('People who are currently using shambles haxx.'),
    async execute(interaction, client) {
        const embed = new EmbedBuilder()
        .setColor('#008cff')
        .setTitle('Current Users Command')
        .addFields(
            { name: 'Current Users', value: name.toString(), inline: true },   
            { name: 'Current Game', value: game.toString(), inline: true },     
        )
        .setThumbnail('https://i.imgur.com/G99HUux.png')
        .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });

        interaction.reply({embeds: [embed]});
    }
} 