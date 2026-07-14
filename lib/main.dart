import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/di/injection.dart';
import 'package:playon/static/app_route.dart';

void main() async {
  // Must be the very first call — Injection.initial() and the
  // HardwareKeyboard handler below both touch Flutter engine
  // services, which aren't available until the binding exists.
  WidgetsFlutterBinding.ensureInitialized();

  await Injection.initial();

  HardwareKeyboard.instance.addHandler((KeyEvent event) {
    debugPrint('RAW KEY: ${event.logicalKey} (${event.runtimeType})');
    return false; // don't consume, just observe
  });

  runApp(const MyApp());
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
        BlocProvider(create: (context) => InjectionBlock.seriesBloc),
        BlocProvider(create: (context) => InjectionBlock.channelCatagoryBloc),
        BlocProvider(create: (context) => InjectionBlock.socialMediaCubit),
        BlocProvider(create: (context) => InjectionBlock.channelsBloc),
        BlocProvider(create: (context) => InjectionBlock.watchLiveBloc),
        BlocProvider(create: (context) => InjectionBlock.matchBloc),
        BlocProvider(create: (context) => InjectionBlock.starPayerCubit),
        BlocProvider(create: (context) => InjectionBlock.podcastBloc),
      ],
      child: MaterialApp.router(
        title: "PlayOn",
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
