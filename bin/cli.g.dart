// GENERATED CODE - DO NOT MODIFY BY HAND
// generator: github.com/Jumpaku/cyamli v1.1.7

// ignore_for_file: unused_local_variable

typedef Func<Input> = Function(List<String> subcommand, Input? input, Exception? inputErr);





class CLI {
  Func<CLI_Input>? FUNC;
  
  final CLI_Validate validate = CLI_Validate();
  
}


typedef CLI_Input = ({
  
  bool optHelp,
  
  
});


CLI_Input _resolve_CLI_Input(List<String> restArgs) {
  
  bool var_optHelp = false;
  
  List<String> arguments = [];
  for (int idx = 0; idx < restArgs.length; ++idx) {
    final arg = restArgs[idx];
    if (arg == "--") {
      arguments.addAll(restArgs.sublist(idx + 1));
      break;
    }
    if (!arg.startsWith("-")) {
      arguments.add(arg);
      continue;
    }
    final eqPos = arg.indexOf("=");
    final cut = eqPos >= 0;
    final optName = cut?arg.substring(0,eqPos) : arg;
    var lit = cut?arg.substring(eqPos+1) : "";

    switch (optName) {
    
    case "-help" || "-h":
      if (!cut) {
        lit = "true";
        
      }
      var_optHelp = _parseValue(var_optHelp.runtimeType, [lit]) as bool;
    
    default:
      throw Exception("unknown option ${optName}");
    }
  }

  

  return (
  
    optHelp: var_optHelp,
  
  
  );
}






class CLI_Validate {
  Func<CLI_Validate_Input>? FUNC;
  
}


typedef CLI_Validate_Input = ({
  
  bool optHelp,
  
  
  List<String> argSchemaPath,
  
});


CLI_Validate_Input _resolve_CLI_Validate_Input(List<String> restArgs) {
  
  bool var_optHelp = false;
  
  List<String> arguments = [];
  for (int idx = 0; idx < restArgs.length; ++idx) {
    final arg = restArgs[idx];
    if (arg == "--") {
      arguments.addAll(restArgs.sublist(idx + 1));
      break;
    }
    if (!arg.startsWith("-")) {
      arguments.add(arg);
      continue;
    }
    final eqPos = arg.indexOf("=");
    final cut = eqPos >= 0;
    final optName = cut?arg.substring(0,eqPos) : arg;
    var lit = cut?arg.substring(eqPos+1) : "";

    switch (optName) {
    
    case "-help" || "-h":
      if (!cut) {
        lit = "true";
        
      }
      var_optHelp = _parseValue(var_optHelp.runtimeType, [lit]) as bool;
    
    default:
      throw Exception("unknown option ${optName}");
    }
  }

  

  
  if (arguments.length <= 0 - 1) {
    throw Exception("too few arguments");
  }
  List<String> var_argSchemaPath = _parseValue(List<String>, arguments.sublist(0)) as List<String>;
  

  

  return (
  
    optHelp: var_optHelp,
  
  
    argSchemaPath: var_argSchemaPath,
  
  );
}




void run(CLI cli, List<String> args) {
  var (subcommandPath: subcommandPath, restArgs: restArgs) = _resolveSubcommand(args);
  switch (subcommandPath.join(" ")) {

  case "":
    final funcMethod = cli.FUNC;
    if (funcMethod == null) {
      throw Exception("'${ "" }' is unsupported: cli.FUNC not assigned");
    }

    CLI_Input? input;
    Exception? err;
    try {
      input = _resolve_CLI_Input(restArgs);
    } on Exception catch (e) {
      err = e;
    }
    funcMethod(subcommandPath, input, err);


  case "validate":
    final funcMethod = cli.validate.FUNC;
    if (funcMethod == null) {
      throw Exception("'${ "validate" }' is unsupported: cli.validate.FUNC not assigned");
    }

    CLI_Validate_Input? input;
    Exception? err;
    try {
      input = _resolve_CLI_Validate_Input(restArgs);
    } on Exception catch (e) {
      err = e;
    }
    funcMethod(subcommandPath, input, err);

  }
}


({List<String> subcommandPath, List<String> restArgs}) _resolveSubcommand(List<String> args) {
  final subcommandSet = {
    "": true,
    "validate": true,
    
  };

  List<String> subcommandPath = [];
  for (var arg in args) {
    if (arg == "--") {
      break;
    }
    final pathLiteral = ([]..addAll(subcommandPath)..add(arg)).join(" ");
    if (!subcommandSet.containsKey(pathLiteral)) {
      break;
    }

    subcommandPath.add(arg);
  }

  return (subcommandPath: subcommandPath, restArgs: args.sublist(subcommandPath.length));
}

dynamic _parseValue(Type t, List<String> strValue) {
  switch (t) {
  case const (List<bool>):
    return strValue.map((s)=>_parseValue(bool, [s]) as bool).toList();
  case const (List<int>):
    return strValue.map((s)=>_parseValue(int, [s]) as int).toList();
  case const (List<double>):
    return strValue.map((s)=>_parseValue(double, [s]) as double).toList();
  case const (List<String>):
    return strValue.map((s)=>_parseValue(String, [s]) as String).toList();
  case bool when strValue.length == 1:
    return switch(strValue[0]) {
      "1" || "t" || "T" || "true" || "TRUE" || "True" => true,
      "0" || "f" || "F" || "false" || "FALSE" || "False" => false,
      _ => throw Exception("invalid boolean value: ${strValue[0]}"),
    };
  case int when strValue.length == 1:
    return int.parse(strValue[0]);
  case double when strValue.length == 1:
    return double.parse(strValue[0]);
  case String when strValue.length == 1:
    return strValue[0];
  }

  throw Exception("invalid type: ${t}");
}


String getDoc(List<String> subcommands) {
  switch (subcommands.join(" ")) {

  case "":
    return "csv_armor (v0.0.0)\n\ncsv_armor\n\n    Description:\n        A CLI tool to check integrity of CSV files organized in a file system based on schema files.\n\n    Syntax:\n        \$ csv_armor  [<option>]...\n\n    Options:\n        -help[=<boolean>], -h[=<boolean>]  (default=false):\n            Shows help text.\n\n    Subcommands:\n        validate:\n            Check the integrity of CSV files.\n\n\n";


  case "validate":
    return "csv_armor (v0.0.0)\n\ncsv_armor validate\n\n    Description:\n        Check the integrity of CSV files.\n\n    Syntax:\n        \$ csv_armor validate [<option>|<argument>]... [-- [<argument>]...]\n\n    Options:\n        -help[=<boolean>], -h[=<boolean>]  (default=false):\n            Shows help text.\n\n    Arguments:\n        1. [<schema_path:string>]...\n            The CSV file paths to check.\n\n\n";

  default:
    throw Exception("invalid subcommands: ${subcommands}");
  }
}
