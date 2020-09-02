import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

import '../utils.dart' as utils;

class OwnerCommands {
  CommandGroup group = CommandGroup(beforeHandler: checkForAdmin)
    ..registerSubCommand('shutdown', shutdownCommand)
    ..registerSubCommand('selfNick', selfNickCommand);
}

Future<bool> checkForAdmin(CommandContext context) async {
  if(env['ADMIN_ID'].toString().isNotEmpty) {
    return context.author!.id == int.parse(env['ADMIN_ID'].toString());
  }

  return false;
}
Future<void> shutdownCommand(CommandContext ctx, String content) async {
  final embed = utils.miniEmbed(':wave: Bye bye', DiscordColor.fromRgb(255, 0, 255));

  await ctx.reply(embed: embed);
  Process.killPid(pid);
}

Future<void> selfNickCommand(CommandContext ctx, String content) async {
  if (ctx.guild == null) {
    await ctx.reply(content: 'Cannot change nick in DMs');
    return;
  }
  final newName = ctx.getArguments().join(' ');
  final embed = utils.miniEmbed(':thumbsup: I changed my name to `${newName}`', DiscordColor.fromRgb(255, 0, 255));
  await ctx.guild?.changeSelfNick(newName);
  await ctx.reply(embed: embed);
}