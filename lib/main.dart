import 'package:flutter/material.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initApp(); // Initialize the app

  runApp(const App());
}
