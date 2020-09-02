import 'dart:io';
import 'dart:math';

import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as time_ago;

import '../utils.dart' as utils;

class GeneralCommands {
  CommandGroup group = CommandGroup()
    ..registerSubCommand('ping', pingCommand);
}

Future<void> pingCommand(CommandContext ctx, String content) async {
  final color = DiscordColor.fromRgb(255,0,255);
  final gatewayDelayInMilis = ctx.client.shardManager.shards.firstWhere((element) => element.id == ctx.shardId).gatewayLatency.inMilliseconds;
  final stopwatch = Stopwatch()..start();

  final embed = EmbedBuilder()
    ..color = color
    ..addField(name: 'Gateway latency', content: '$gatewayDelayInMilis ms', inline: true)
    ..addField(name: 'Message roundup time', content: 'Pending...', inline: true);

  final message = await ctx.reply(embed: embed);

  embed
    ..replaceField(name: "Message roundup time", content: "${stopwatch.elapsedMilliseconds} ms", inline: true);

  await message.edit(embed: embed);
}
