const { SlashCommandBuilder } = require('@discordjs/builders');
const { EmbedBuilder } = require('discord.js');
const { Client } = require('discord.js');
const { PermissionFlagsBits } = require('discord.js');

function getRandomInt(max) {
    return Math.floor(Math.random() * max);
}

module.exports = {
    data: new SlashCommandBuilder()
    .setName('question')
	.setDescription('ask question')
    .addStringOption(option =>
		option.setName('text')
		.setDescription('The question.')
        .setRequired(true)),
    async execute(interaction, client) {
        const target = interaction.options.getUser('target');
        const text = interaction.options.getString('text');
        const answer = getRandomInt(2) == 1 && "Yes" || "No"

        const embed = new EmbedBuilder()
        .setColor('#008cff')
        .setTitle('Shambles Haxx:tm:')
        .setThumbnail('https://i.imgur.com/G99HUux.png')
        .setDescription("Question: " + text + "\nAnswer: " + answer)
        .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });

        interaction.reply({embeds: [embed]})
    }
}