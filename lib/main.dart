import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:here2there_kids/screens/map/map_screen.dart';
import 'package:here2there_kids/screens/travel/travel_screen.dart';
import 'package:here2there_kids/services/location_progress_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocationProgressService(),
      child: const MyApp(),
    ),
  );
}

final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Here2There Kids',
      scaffoldMessengerKey: messengerKey,
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const MapScreen(),
        '/travel': (context) => const TravelScene(),
      },
    );
  }
}
