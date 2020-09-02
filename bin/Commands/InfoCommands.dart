import 'dart:io';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as time_ago;

import '../utils.dart' as utils;

class InfoCommands {
  CommandGroup group = CommandGroup(name: 'info')
    ..registerSubCommand('guild', guildInfoCommand)
    ..registerSubCommand('user', userInfoCommand)

    ..registerDefaultCommand(guildInfoCommand2);
}

Future<void> guildInfoCommand(CommandContext ctx,String content) async {
  final guild = ctx.guild;
  final curuser = ctx.client.self;
  final formatter = DateFormat('dd.MM.yyyy hh:mm');
  final roles = guild?.roles;

  final embed = EmbedBuilder()
  ..addAuthor((author) {
    author.name = curuser.tag;
    author.iconUrl = curuser.avatarURL();
  })
  ..addFooter((footer) { 
    footer.text = 'Info requested by ${ctx.author?.username}';
    footer.iconUrl = ctx.author?.avatarURL();    
  })
  ..color = DiscordColor.fromRgb(255, 0, 255)
    ..timestamp = DateTime.now()
  ..addField(
    name: 'ID',
    content: guild?.id.toString(),
    inline: true)
  ..addField(
    name: 'Owner',
    content: 'x',
    inline: true)
  ..addField(
    name: 'Members',
    content: guild?.members.count,
    inline: true)
  ..addField(
    name: 'Channels',
    content: guild?.channels.count,
    inline: true)
  ..addField(
    name: 'Created At',
    content: formatter.format(guild?.createdAt),
    inline: true)
  ..addField(
    name: 'Region',
    content: guild?.region,
    inline: true)
  ..addField(
    name: 'Roles (${roles?.count})',
    content: '${roles?.values.join(",").replaceAll('@', '').replaceAll('everyone', '').replaceFirst(',', '')}',
    inline: false)
  ..addField(
    name: 'Custom Emojis ()',
    content: 'uwu',
    inline: false);

  await ctx.reply(embed: embed);
}
Future<void> guildInfoCommand2(CommandContext ctx,String content) async {
  await ctx.reply(content: 'test2');
}

Future<void> userInfoCommand(CommandContext ctx,String content) async {
  final formatter = DateFormat('dd.MM.yyyy hh:mm');
  final roles = (ctx.author! as CacheMember).roles;
  final embed = EmbedBuilder()
      ..addAuthor((author) {
        author.name = ctx.client.self.tag;
        author.iconUrl = ctx.client.self.avatarURL();
      })
      ..addFooter((footer) {
        footer.text = 'Info requested by ${ctx.author?.username}';
        footer.iconUrl = ctx.author?.avatarURL();
      })
      ..color = DiscordColor.fromRgb(255, 0, 255)
      ..addField(
        name: 'ID',
        content: ctx.author?.id,
        inline: true)
      ..addField(
        name: 'Username',
        content: (await ctx.guild!.getMember(ctx.author as IMember) as CacheMember).nickname ?? 'oof no nickname',
        inline: true)
      ..addField(
        name: 'Joined Discord at',
        content: formatter.format(ctx.author!.createdAt),
        inline: true
      )
      ..addField(
        name: 'Joined ${ctx.guild!.name}',
        content: formatter.format((await ctx.guild!.getMember(ctx.author! as IMember) as CacheMember).joinedAt),
        inline: true
      )
      ..addField(
        name: 'Shared Guilds',
        content: 'I (the bot) share ${(await getSharedAsync(ctx.author! as IMember, ctx))} guilds with ${ctx.author!.username}',
        inline: true
      )
      ..addField(
        name: 'Roles (${roles.length})',
        content: '${roles.join(",").replaceAll('@', ' ')}',
        inline: false
      );
  await ctx.reply(embed: embed);
}

Future<int> getSharedAsync(IMember u, CommandContext ctx) async {
  final selfguilds = ctx.client.guilds;
  return selfguilds.find((item) => item.members.hasValue(u)).length;
}

Future<void> infoCommand(CommandContext ctx, String content) async {
  final color = DiscordColor.fromRgb(
      Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));

  final embed = EmbedBuilder()
    ..addAuthor((author) {
      author.name = ctx.client.self.tag;
      author.iconUrl = ctx.client.self.avatarURL();
      author.url = 'https://github.com/l7ssha/nyxx';
    })
    ..addFooter((footer) {
      footer.text = 'Nyxx 1.0.0 | Shard [${ctx.shardId + 1}] of [${ctx.client.shards}] | ${utils.dartVersion}';
    })
    ..color = color
    ..addField(
        name: 'Uptime',
        content: time_ago.format(ctx.client.startTime, locale: 'en_short'),
        inline: true)
    ..addField(
        name: 'DartVM memory usage',
        // ignore: prefer_single_quotes
        content: "${(ProcessInfo.currentRss / 1024 / 1024).toStringAsFixed(2)} MB",
        inline: true)
    ..addField(name: 'Created at', content: ctx.client.app.createdAt, inline: true)
    ..addField(name: 'Guild count', content: ctx.client.guilds.count, inline: true)
    ..addField(name: 'Users count', content: ctx.client.users.count, inline: true)
    ..addField(
        name: 'Channels count',
        content: ctx.client.channels.count,
        inline: true)
    ..addField(
        name: 'Users in voice',
        content: ctx.client.guilds.values
            .map((g) => g.voiceStates.count)
            .reduce((f, s) => f + s),
        inline: true)
    ..addField(name: 'Shard count', content: ctx.client.shards, inline: true)
    ..addField(name: 'Cached messages', content: ctx.client.channels.find((item) => item is MessageChannel).cast<MessageChannel>().map((e) => e.messages.count).fold(0, (first, second) => (first as int) + second), inline: true);

  await ctx.reply(embed: embed);
}
