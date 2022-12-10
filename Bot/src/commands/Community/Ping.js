const { SlashCommandBuilder } = require('@discordjs/builders');
const { EmbedBuilder } = require('discord.js');
const { Client } = require('discord.js');

module.exports = {
    data: new SlashCommandBuilder()
    .setName('ping')
    .setDescription('This will return a pong.'),
    async execute(interaction, client) {
        const embed = new EmbedBuilder()
        .setColor('#008cff')
        .setTitle('Ping Command')
        .setThumbnail('https://i.imgur.com/G99HUux.png')
        .setDescription('Pong!') 
        .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });

        interaction.reply({embeds: [embed]});
    }
} 