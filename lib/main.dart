import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/zhuyin_service.dart';
import 'services/vision_service.dart';
import 'models/zhuyin_mapping.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ZhuyinMapping.loadDictionary();

  runApp(
    MultiProvider(
      providers: [
        Provider<VisionService>(create: (_) => VisionService()),
        ChangeNotifierProxyProvider<VisionService, ZhuyinService>(
          create: (context) => ZhuyinService(context.read<VisionService>()),
          update: (_, vision, previous) => previous ?? ZhuyinService(vision),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '拍照轉注音',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
