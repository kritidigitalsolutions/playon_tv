import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart';
import 'package:playon/di/injection.dart';
import 'package:playon/static/app_route.dart';

void main() async {
  await Injection.initial();

  WidgetsFlutterBinding.ensureInitialized();
  HardwareKeyboard.instance.addHandler((KeyEvent event) {
    debugPrint('RAW KEY: ${event.logicalKey} (${event.runtimeType})');
    return false; // don't consume, just observe
  });
  MediaKit.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => InjectionBlock.authBloc),
        BlocProvider(create: (context) => InjectionBlock.bannerAdsBloc),
        BlocProvider(create: (context) => InjectionBlock.highlightBloc),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
