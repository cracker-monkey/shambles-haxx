const { SlashCommandBuilder } = require('@discordjs/builders');
const { EmbedBuilder } = require('discord.js');
const { Client } = require('discord.js');

module.exports = {
    data: new SlashCommandBuilder()
    .setName('users')
    .setDescription('Shambles Haxx users.'),
    async execute(interaction, client) {
        const embed = new EmbedBuilder()
        .setColor('#008cff')
        .setTitle('Users Command')
        .setThumbnail('https://i.imgur.com/G99HUux.png')
        .addFields(
            { name: 'Developer', value: 'Office', inline: true }, 
            { name: 'Developer', value: 'J.', inline: true  }, 
            { name: 'Staff', value: 'Cracker Monkey' }, 
            { name: 'Staff', value: 'Evie' },
            { name: 'Staff', value: 'Invaded' }, 
            { name: 'Staff', value: 'Yukino' }, 
        )
        .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });

        interaction.reply({embeds: [embed]});
    }
} 