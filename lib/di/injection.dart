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
import 'package:playon/feature/highlights/usecase/high_light_deatil_usecase.dart';
import 'package:playon/feature/home/bloc/banner_ads/banner_ads_bloc.dart';
import 'package:playon/feature/home/bloc/social_media/social_media_cubit.dart';
import 'package:playon/feature/home/bloc/star_player/star_payer_cubit.dart';
import 'package:playon/feature/home/datasource/home_datasource.dart';
import 'package:playon/feature/home/usecase/all_star_player_usecase.dart';
import 'package:playon/feature/home/usecase/banner_ads_usecase.dart';
import 'package:playon/feature/live_tv/bloc/channel_catagory/channel_catagory_bloc.dart';
import 'package:playon/feature/live_tv/bloc/channels/channels_bloc.dart';
import 'package:playon/feature/live_tv/bloc/watch_live/watch_live_bloc.dart';
import 'package:playon/feature/live_tv/datasource/live_tv_datasource.dart';
import 'package:playon/feature/live_tv/usecase/all_channel_usecase.dart';
import 'package:playon/feature/live_tv/usecase/channel_catagory_usecase.dart';
import 'package:playon/feature/live_tv/usecase/watch_live_usecase.dart';
import 'package:playon/feature/series/bloc/match/match_bloc.dart';
import 'package:playon/feature/series/bloc/series/series_bloc.dart';
import 'package:playon/feature/series/datasource/series_datasource.dart';
import 'package:playon/feature/series/usecase/all_series_usecase.dart';
import 'package:playon/feature/series/usecase/match_detail_usecase.dart';
import 'package:playon/feature/series/usecase/series_detail_usecase.dart';

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
