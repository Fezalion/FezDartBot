import 'dart:io';

import 'package:nyxx/nyxx.dart';

String get dartVersion {
  final platformVersion = Platform.version;
  return platformVersion.split('(').first;
}

String helpCommandGen(String commandName, String description, { String? additionalInfo }) {
  final buffer = StringBuffer();

  buffer.write('**commandName**');

  if (additionalInfo != null) {
    buffer.write(" `$additionalInfo`");
  }

  buffer.write(" - $description.\n");

  return buffer.toString();
}

EmbedBuilder miniEmbed(String text,DiscordColor color) {
  return EmbedBuilder()
    ..description = text
    ..color = color;
}