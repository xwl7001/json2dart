// import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as path;
import 'package:mustache/mustache.dart';
import './src/build_runner.dart' as br;
import './src/model_generator.dart';
import './src/helpers.dart';

// const tpl="import 'package:json_annotation/json_annotation.dart';\n%t\npart '%s.g.dart';\n\n@JsonSerializable()\nclass %s {\n    %s();\n\n    %s\n    factory %s.fromJson(Map<String,dynamic> json) => _\$%sFromJson(json);\n    Map<String, dynamic> toJson() => _\$%sToJson(this);\n}\n";
// const tpl="""
// import 'package:json_annotation/json_annotation.dart';
// %t
// part '%s.g.dart';

// @JsonSerializable()
// class %s {
//     %s();

//     %s
//     factory %s.fromJson(Map<String,dynamic> json) => _\$%sFromJson(json);
//     Map<String, dynamic> toJson() => _\$%sToJson(this);
// }
// """;

const tplSource="""
import 'package:json_annotation/json_annotation.dart';

//part '{{&className}}.g.dart';

@JsonSerializable()
{{&classBody}}
""";

var template = new Template(tplSource, name: 'template-class.html');

void main(List<String> args) {
  String src;
  String dist;
  String tag;
  var parser = new ArgParser();
  parser.addOption('src', defaultsTo: './jsons', callback: (v) => src = v, help: "Specify the json directory.");
  parser.addOption('dist', defaultsTo: 'lib/models', callback: (v) => dist = v, help: "Specify the dist directory.");
  parser.addOption('tag', defaultsTo: '\$', callback: (v) => tag = v, help: "Specify the tag ");
  parser.parse(args);
  if(walk(src, dist,tag)) {
    br.run(['build', '--delete-conflicting-outputs']);
  }
}

//遍历JSON目录生成模板
bool walk(String srcDir, String distDir, String tag ) {
  if(srcDir.endsWith("/")) srcDir=srcDir.substring(0, srcDir.length-1);
  if(distDir.endsWith("/")) distDir=distDir.substring(0, distDir.length-1);
  var src = Directory(srcDir);
  var list = src.listSync(recursive: true);
  String indexFile="";
  if(list.isEmpty) return false;
  if(!Directory(distDir).existsSync()){
    Directory(distDir).createSync(recursive: true);
  }
//  var tpl=path.join(Directory.current.parent.path,"model.tpl");
//  var template= File(tpl).readAsStringSync();
//  File(path.join(Directory.current.parent.path,"model.tplx")).writeAsString(jsonEncode(template));
  File file;
  list.forEach((f) {
    if (FileSystemEntity.isFileSync(f.path)) {
      file = File(f.path);
      var paths=path.basename(f.path).split(".");
      String name=paths.first;
      if(paths.last.toLowerCase()!="json"||name.startsWith("_")) return ;
      if(name.startsWith("_")) return;
      //生成
      var jsonRawData = file.readAsStringSync();
      String  className= camelCase(name) ;// name[0].toUpperCase()+name.substring(1);
      final classGenerator = new ModelGenerator(className, true);
      String dartClassesStr = classGenerator.generateDartClasses(jsonRawData);

      var dist = template.renderString({'className': className, 'classBody': dartClassesStr});
      //将生成的模板输出
      var p=f.path.replaceFirst(srcDir, distDir).replaceFirst(".json", ".dart");
      File(p)..createSync(recursive: true)..writeAsStringSync(dist);
      var relative=p.replaceFirst(distDir+path.separator, "");
      relative = relative.replaceAll('\\', '/');
      indexFile+="export '$relative' ; \n";
    }
  });
  if(indexFile.isNotEmpty) {
    File(path.join(distDir, "index.dart")).writeAsStringSync(indexFile);
  }
  return indexFile.isNotEmpty;
}

String changeFirstChar(String str, [bool upper=true] ){
  return (upper?str[0].toUpperCase():str[0].toLowerCase())+str.substring(1);
}

bool isBuiltInType(String type){
  return ['int','num','string','double','map','list'].contains(type);
}

//将JSON类型转为对应的dart类型
String getType(v,Set<String> set,String current, tag){
  current=current.toLowerCase();
  if(v is bool){
    return "bool";
  }else if(v is num){
    return "num";
  }else if(v is Map){
    return "Map<String,dynamic>";
  }else if(v is List){
    return "List";
  }else if(v is String){ //处理特殊标志
    if(v.startsWith("$tag[]")){
      var type=changeFirstChar(v.substring(3),false);
      if(type.toLowerCase()!=current&&!isBuiltInType(type)) {
        set.add('import "$type.dart"');
      }
      return "List<${changeFirstChar(type)}>";

    }else if(v.startsWith(tag)){
      var fileName=changeFirstChar(v.substring(1),false);
      if(fileName.toLowerCase()!=current) {
        set.add('import "$fileName.dart"');
      }
      return changeFirstChar(fileName);
    }else if(v.startsWith("@")){
      return v;
    }
    return "String";
  }else{
    return "String";
  }
}