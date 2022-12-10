const { SlashCommandBuilder } = require('@discordjs/builders');
const { EmbedBuilder } = require('discord.js');
const { Client } = require('discord.js');

module.exports = {
    data: new SlashCommandBuilder()
    .setName('embed')
    .setDescription('Shambles Haxx embed.')
	.addStringOption(option => option.setName('message')
	.setDescription('Embed message')
	.setRequired(true)),
    async execute(interaction, client) {
        const embed = new EmbedBuilder()
        .setColor('#008cff')
        .setThumbnail('https://i.imgur.com/G99HUux.png')
        .setDescription(interaction.options.getString('message'))
        .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });

        interaction.reply({embeds: [embed]});
    }
}