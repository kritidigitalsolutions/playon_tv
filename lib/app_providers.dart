import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/di/injection.dart';

class AppProviders {
  static List<BlocProvider> providers = [
    BlocProvider(create: (_) => InjectionBlock.authBloc),
    BlocProvider(create: (_) => InjectionBlock.bannerAdsBloc),
    BlocProvider(create: (_) => InjectionBlock.highlightBloc),
    BlocProvider(create: (_) => InjectionBlock.seriesBloc),
    BlocProvider(create: (_) => InjectionBlock.channelCatagoryBloc),
    BlocProvider(create: (_) => InjectionBlock.socialMediaCubit),
    BlocProvider(create: (_) => InjectionBlock.channelsBloc),
    BlocProvider(create: (_) => InjectionBlock.watchLiveBloc),
    BlocProvider(create: (_) => InjectionBlock.matchBloc),
    BlocProvider(create: (_) => InjectionBlock.starPayerCubit),
    BlocProvider(create: (_) => InjectionBlock.podcastBloc),
  ];
}