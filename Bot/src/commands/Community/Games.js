const { SlashCommandBuilder } = require('@discordjs/builders');
const { EmbedBuilder } = require('discord.js');
const { Client } = require('discord.js');

module.exports = {
    data: new SlashCommandBuilder()
    .setName('games')
    .setDescription('Shambles Haxx games.'),
    async execute(interaction, client) {
        const embed = new EmbedBuilder()
        .setColor('#008cff')
        .setTitle('Games Command')
        .setThumbnail('https://i.imgur.com/G99HUux.png')
        .addFields(
            { name: 'Phantom Forces', value: 'Status: Online\nVersion: 2.2.1a', inline: true },    
            { name: 'Universal', value: 'Status: Online\nVersion: 2.0.5b', inline: true },    
        )
        .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });

        interaction.reply({embeds: [embed]});
    }
}