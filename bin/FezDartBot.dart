import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dotenv/dotenv.dart' show env,load;
import 'package:nyxx/nyxx.dart';
import 'package:nyxx_commander/commander.dart';

import 'Commands/GeneralCommands.dart';
import 'Commands/OwnerCommands.dart';
import 'Commands/InfoCommands.dart';

void main() async {
  load(); //load env file
  final bot = Nyxx(env['BOT_TOKEN'].toString(),
      options: ClientOptions(
        guildSubscriptions: false,
        initialPresence: PresenceBuilder.of(
          game: Activity.of('built with Dart using Nyxx <3', type: ActivityType.game)
        )
      ),

  );

  final commander = Commander(bot,prefix: 'f!');
  commander.registerCommandGroup(OwnerCommands().group);
  commander.registerCommandGroup(GeneralCommands().group);
  commander.registerCommandGroup(InfoCommands().group);

}

