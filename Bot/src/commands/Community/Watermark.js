const { SlashCommandBuilder } = require('@discordjs/builders');
const { EmbedBuilder } = require('discord.js');
const { Client } = require('discord.js');

module.exports = {
    data: new SlashCommandBuilder()
    .setName('watermark')
    .setDescription('Shambles Haxx watermark properties.'),
    async execute(interaction, client) {
        const embed = new EmbedBuilder()
        .setColor('#008cff')
        .setTitle('Watermark Command')
        .setThumbnail('https://i.imgur.com/G99HUux.png')
        .addFields(
            { name: '{user}', value: 'Prints out your user. (office)' },    
            { name: '{time}', value: 'Prints out your time. (00:00:00)' },
            { name: '{ap}', value: 'Prints out your typography. (PM, AM)' },
            { name: '{month}', value: 'Prints out your month. (Nov)' },
            { name: '{day}', value: 'Prints out your day. (15)' },
            { name: '{year}', value: 'Prints out your year. (2022)' },
            { name: '{version}', value: 'Prints out version. (3.5.1b)' },
            { name: '{fps}', value: 'Prints out your fps. (123)' },
            { name: '{ping}', value: 'Prints out your ping. (123)' },
            { name: '{game}', value: 'Prints out your game. (Da Hood)' },
        )
        .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });

        interaction.reply({embeds: [embed]});
    }
} 