import 'dart:io';

import 'package:git_hooks/git_hooks.dart';

void main(List arguments) {
  Map<Git, UserBackFun> params = {Git.preCommit: preCommit};
  GitHooks.call(arguments as List<String>, params);
}

Future<bool> preCommit() async {
  try {
    // Use Git diff to get the changes between the HEAD and the index
    var gitDiff = await Process.run('git', ['diff', '--cached', '--name-only']);
    if (gitDiff.exitCode != 0) {
      return false;
    }

    // Filter out any files that are not Dart files
    var dartFiles = gitDiff.stdout
        .toString()
        .split('\n')
        .where((filename) => filename.endsWith('.dart'));
    ProcessResult result;
    bool showWarning = false;
    // Run the pre-commit checks on each Dart file
    for (var dartFile in dartFiles) {
      result = await Process.run('dart', ['fix', '--apply', dartFile]);
      if (result.exitCode != 0) {
        return false;
      }

      result = await Process.run('dart', ['format', dartFile]);
      if (result.exitCode != 0) {
        return false;
      }

      result = await Process.run('dart', ['analyze', dartFile]);
      if (result.exitCode != 0) {
        return false;
      }
      result =
          await Process.run('dart', ['analyze', '--fatal-infos', dartFile]);
      if (result.exitCode != 0) {
        print("Non-Fatal errors in $dartFile Please check");
        showWarning = true;
      }
    }
    if (showWarning) {
      print(
          "Please check:\n 1. Unused imports\n 2. Unused variables\n 3. Redundant null checks\n 4. Unused methods\n 5. Inconsistent return types\n 6. Missing required parameters");
    }
    result =
        await Process.run('dart', ['pub', 'outdated', '--no-dev-dependencies']);
    if (result.exitCode == 0) {
      List<String> lines = (result.stdout as String).split('\n');
      List<String> outdatedPackages = [];
      for (var i = 2; i < lines.length; i++) {
        if (lines[i].startsWith('- ')) {
          outdatedPackages.add(lines[i].substring(2).split(' ')[0]);
        }
      }
    }
    return true;
  } catch (e) {
    return false;
  }
}
