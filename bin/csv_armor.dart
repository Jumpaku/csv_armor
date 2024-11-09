import 'package:logging/logging.dart';

import 'cli.g.dart';

Logger _logger = Logger('csv_armor_cli');

void main(List<String> args) {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  final cli = CLI();
  cli.FUNC = (subcommands, input, err) {
    if (err != null) {
      _logger.severe(
          "invalid command line arguments: to see help '<program> -help'", err);
      return;
    }
    _logger.info(getDoc(subcommands));
    return;
  };
  cli.validate.FUNC = (subcommands, input, err) {
    if (err != null) {
      _logger.severe(
        "invalid command line arguments: to see help '<program> ${subcommands.join(" ")} -help'",
        err,
      );
      return;
    }
    input = input!;
    if (input.optHelp) {
      _logger.info(getDoc(subcommands));
      return;
    }
    _logger.info(getDoc(subcommands));
  };

  run(cli, args);
}
