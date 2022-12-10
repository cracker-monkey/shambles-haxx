const { Client, GatewayIntentBits, Collection } = require('discord.js');
const fs = require('fs');
const { EmbedBuilder } = require('discord.js');
const client = new Client({ intents: [GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages, GatewayIntentBits.MessageContent]});

client.commands = new Collection();

require('dotenv').config();

const functions = fs.readdirSync("./src/functions").filter(file => file.endsWith(".js"));
const eventFiles = fs.readdirSync("./src/events").filter(file => file.endsWith(".js"));
const commandFolders = fs.readdirSync("./src/commands");
const WebSocket = require("ws");
const wss = new WebSocket.Server({ port: 8022 });

wss.broadcast = function broadcast(msg) {
    wss.clients.forEach(function each(client) {
        client.send(msg);
    });
};

const jokes = [
    "I'm afraid for the calendar. Its days are numbered.",
    "My wife said I should do lunges to stay in shape. That would be a big step forward.",
    "Why do fathers take an extra pair of socks when they go golfing? In case they get a hole in one!",
    "I once wrote a song about a tortilla, but it's more of a wrap.",
    "A witch's vehicle goes brrroom brrroom!",
    "If you see a crime at an Apple store, are you an iWitness?",
    "If the early bird catches the worm, I'll sleep in until there are pancakes.",
    "The wedding was so beautiful, even the cake was in tiers.",
    "I used to be able to play the piano by ear, but now I have to use my hands.",
]

const prefix = ">";

function getRandomInt(max) {
    return Math.floor(Math.random() * max);
}

(async () => {
    for (file of functions) {
        require(`./functions/${file}`)(client);
    }
    client.handleEvents(eventFiles, "./src/events");
    client.handleCommands(commandFolders, "./src/commands");
    client.login(process.env.token)
})();

client.on("ready", async() => {
    console.log("Bot online and on.")
    client.user.setActivity("Discord bot for the users at shambles haxx.");
})


client.on("messageCreate", (message) => {
    if (!message.content.startsWith(prefix) || message.author.bot) return;

    const args = message.content.slice(1, message.content.length);
    const command = args.toLowerCase();

    if (message.member.roles.cache.has("1043556280758972536") || message.member.roles.cache.has("1048725179100037241")) {
        if (command.includes("@everyone") || command.includes("@here") || command.includes("@ everyone") || command.includes("@ here"))
        {
            message.reply({content: "Nice try ;/"});
            return;
        }
        
        if (command.includes("say"))
        {
            if (message.content.slice(4, message.content.length).toString() != null) {
                const embed = new EmbedBuilder()
                .setColor('#008cff')    
                .setTitle('Web-Sockets')
                .setDescription("Sending data to clients: " + message.content.slice(5, message.content.length).toString())
                .setThumbnail('https://i.imgur.com/G99HUux.png')
                .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });
                message.reply({embeds: [embed]})
                wss.broadcast("saycmd " + message.content.slice(5, message.content.length).toString())
            }   
            else
            {
                const embed = new EmbedBuilder()
                .setColor('#008cff')
                .setTitle('Web-Sockets')
                .setDescription('Invalid string.')
                .setThumbnail('https://i.imgur.com/G99HUux.png')
                .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });
                message.reply({embeds: [embed]})
            }
        }
        else if (command.includes("fpscap"))
        {
            const embed = new EmbedBuilder()
            .setColor('#008cff')
            .setTitle('Web-Sockets')
            .setDescription("Sending data to clients: " + message.content.slice(7, message.content.length).toString())
            .setThumbnail('https://i.imgur.com/G99HUux.png')
            .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });
            message.reply({embeds: [embed]})
            wss.broadcast("fpscap " + message.content.slice(7, message.content.length).toString())
        }
        else if (command === "botcount")
        {
            const embed = new EmbedBuilder()
            .setColor('#008cff')
            .setTitle('Web-Sockets')
            .setDescription("Clients connected to the server: " + wss.clients.size)
            .setThumbnail('https://i.imgur.com/G99HUux.png')
            .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });
            message.reply({embeds: [embed]})
            wss.broadcast("botcount " + wss.clients.size)
        }
        else if (command === "fps")
        {
            const embed = new EmbedBuilder()
            .setColor('#008cff')
            .setTitle('Web-Sockets')
            .setDescription("Sending data to clients: FPS")
            .setThumbnail('https://i.imgur.com/G99HUux.png')
            .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });
            message.reply({embeds: [embed]})
            wss.broadcast("fps")
        }
        else if (command === "help" || command === "commands" || command === "cmds")
        {
            const embed = new EmbedBuilder()
            .setColor('#008cff')
            .setTitle('Web-Sockets')
            .setDescription("Commands: Say (msg), BotCount, FPS, Joke, Commands.")
            .setThumbnail('https://i.imgur.com/G99HUux.png')
            .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });
            message.reply({embeds: [embed]})
            wss.broadcast("commands Commands: Say (msg), BotCount, FPS, Joke, Commands.")
        }
        else if (command === "joke")
        {
            var ranj = jokes[getRandomInt(jokes.length)]
            const embed = new EmbedBuilder()
             .setColor('#008cff')
            .setTitle('Web-Sockets')
            .setDescription(ranj)
            .setThumbnail('https://i.imgur.com/G99HUux.png')
            .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });
            message.reply({embeds: [embed]})
            wss.broadcast("joke " + ranj);
        }
        else
        {
            const embed = new EmbedBuilder()
            .setColor('#008cff')
            .setTitle('Web-Sockets')
            .setDescription('Invalid command or not enough permission.')
            .setThumbnail('https://i.imgur.com/G99HUux.png')
            .setFooter({ text: 'Shambles Haxx', iconURL: 'https://i.imgur.com/Ukt3bR5.png' });
            message.reply({embeds: [embed]})
        }
    }
})















