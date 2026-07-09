import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:playon/core/service/navigator_service.dart';
import 'package:playon/feature/auth/bloc/auth/auth_bloc.dart';
import 'package:playon/feature/auth/datasource/auth_datasource.dart';
import 'package:playon/feature/auth/usecase/fetch_user_usecase.dart';
import 'package:playon/feature/auth/usecase/login_tv_usecase.dart';
import 'package:playon/feature/highlights/bloc/highlight/highlight_bloc.dart';
import 'package:playon/feature/highlights/datasource/high_light_datasource.dart';
import 'package:playon/feature/highlights/usecase/all_highlight_usecase.dart';
import 'package:playon/feature/home/bloc/bloc/banner_ads_bloc.dart';
import 'package:playon/feature/home/datasource/home_datasource.dart';
import 'package:playon/feature/home/usecase/banner_ads_usecase.dart';

part 'injection_auth.dart';
part 'injection_block.dart';

final GetIt getIt = GetIt.instance;

class Injection {
  static BuildContext get currentContext {
    final ctx = navigatorState.currentContext;
    if (ctx == null) {
      throw FlutterError("Context not available");
    }
    return ctx;
  }

  static NavigationService get navigationService => getIt<NavigationService>();
  static GlobalKey<NavigatorState> get navigatorState =>
      getIt<NavigationService>().navigatorKey;
  static Future<void> initialDependency() async {
    final navigationService = NavigationService();
    getIt.registerLazySingleton<NavigationService>(() => navigationService);
    await _authDependency();
  }

  static Future<void> initial() async {
    await initialDependency();
  }
}
