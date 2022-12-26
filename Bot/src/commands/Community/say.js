const { SlashCommandBuilder } = require('@discordjs/builders');
const { EmbedBuilder } = require('discord.js');
const { Client } = require('discord.js');
const { PermissionFlagsBits } = require('discord.js');

module.exports = {
    data: new SlashCommandBuilder()
    .setName('say')
	.setDescription('say message')
    .addStringOption(option =>
		option.setName('text')
		.setDescription('The text to sy.')
        .setRequired(true))
    .addBooleanOption(option =>
        option.setName('embed')
        .setDescription('Should the message be embedded.'))
    .setDefaultMemberPermissions(PermissionFlagsBits.BanMembers),
    async execute(interaction, client) {
        const target = interaction.options.getUser('target');
        const text = interaction.options.getString('text');
        const embed = interaction.options.get('embed') && interaction.options.get('embed').value || false;

        if (embed)
        {
            const embed = new EmbedBuilder()
            .setColor('#008cff')
            .setTitle('Shambles Haxx:tm:')
            .setThumbnail('https://i.imgur.com/G99HUux.png')
            .setDescription(text)
            .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });

            interaction.channel.send({embeds: [embed]})
            interaction.reply({ content: 'Sending message.', ephemeral: true })
        }
        else
        {
            interaction.channel.send(text)
            interaction.reply({ content: 'Sending message.', ephemeral: true })
        }
    }
}