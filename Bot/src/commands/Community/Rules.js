const { SlashCommandBuilder } = require('@discordjs/builders');
const { EmbedBuilder } = require('discord.js');
const { Client } = require('discord.js');

module.exports = {
    data: new SlashCommandBuilder()
    .setName('rules')
    .setDescription('Shambles Haxx rules.'),
    async execute(interaction, client) {
        const embed = new EmbedBuilder()
        .setColor('#008cff')
        .setTitle('Rules Command')
        .setThumbnail('https://i.imgur.com/G99HUux.png')
        .addFields(
            { name: '#1', value: 'You are prohibited from sharing the script with users other than yourself.' },    
            { name: '#2', value: 'It is forbidden to reverse or modify the source code.' },
            { name: '#3', value: 'You are prohibited from refunding the payment you made for the script.' },
            { name: '#4', value: 'It is forbidden to disobey the rules of discord.com/tos.' },
            { name: '#5', value: 'You are forbidden to talk about cheating, hacks or executors.' },

            { name: 'Punishments', value: 'Violation of any of these rules will result in exclusion from the list or exclusion from the discord.' },
        )
        .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });

        interaction.reply({embeds: [embed]});
    }
} 