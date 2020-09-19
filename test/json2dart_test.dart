import 'package:test/test.dart';
import 'package:json2dart/json2dart.dart';

void main() {
  test('adds one to input values', () {
    run([
      '--src=../app/jsons',
      '--dist=../app/lib/models'
    ]); //run方法为json2dart暴露的方法；
  });
}
