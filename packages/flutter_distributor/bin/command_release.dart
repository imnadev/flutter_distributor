import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:flutter_distributor/flutter_distributor.dart';
import 'package:flutter_distributor/src/extensions/extensions.dart';

/// Release (package and publish) an application based on the config
///
/// This command wrapper defines, parses and transforms all passed arguments,
/// so that they may be passed to `flutter_distributor`. The distributor will
/// then use the `distribute_options.yaml` file in the Flutter project root
/// to run a release with one or multiple release jobs.
///
/// Each release job will package and optionally also publish the application
/// based on the configuration on `distribute_options.yaml`.
class CommandRelease extends Command {
  CommandRelease(this.distributor) {
    argParser.addOption(
      'name',
      valueHelp: '',
      help: 'The name of the release to run.',
    );

    argParser.addOption(
      'jobs',
      valueHelp: '',
      help: 'Comma-separated list of jobs to run for the specified release.',
    );

    argParser.addOption(
      'skip-jobs',
      valueHelp: '',
      help: 'Comma-separated list of jobs to skip for the specified release.',
    );

    argParser.addFlag(
      'clean',
      help: 'Whether or not to \'flutter clean\' before packaging.',
    );
  }

  final FlutterDistributor distributor;

  @override
  String get name => 'release';

  @override
  String get description => 'Release the current Flutter application';

  @override
  Future run() async {
    String? name = argResults?['name'] ?? '';
    List<String> jobNameList = (argResults?['jobs'] ?? '')
        .split(',')
        .where((String e) => e.isNotEmpty)
        .toList();
    List<String> skipJobNameList = (argResults?['skip-jobs'] ?? '')
        .split(',')
        .where((String e) => e.isNotEmpty)
        .toList();
    bool isClean = argResults?.wasParsed('clean') ?? false;

    // At least `name` must be passed to select a release
    if (name == null) {
      print('\nThe \'name\' options is mandatory!'.red(bold: true));
      exit(1);
    }

    return distributor.release(
      name,
      jobNameList: jobNameList,
      skipJobNameList: skipJobNameList,
      cleanBeforeBuild: isClean,
    );
  }
}
