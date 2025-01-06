import 'package:flutter_driver/driver_extension.dart';
import 'package:Keyra/main.dart' as app;

void main() {
  // Enable integration testing
  enableFlutterDriverExtension();

  // Start the app
  app.main();
}
