part of 'injection.dart';

Future<void> _authDependency() async {
  //Auth Datasource
  final datasource = AuthDatasource();
  getIt.registerLazySingleton<AuthDatasource>(() => datasource);
  //Home Datasource
  final homeDatasource = HomeDatasource();
  getIt.registerLazySingleton<HomeDatasource>(() => homeDatasource);
  //Series Datasource
  final seriesDatasource = SeriesDatasource();
  getIt.registerLazySingleton<SeriesDatasource>(() => seriesDatasource);

  //Highlight Datasource
  final highlightDatasource = HighLightDatasource();
  getIt.registerLazySingleton<HighLightDatasource>(() => highlightDatasource);

  //LIve Tv Datasource
  final liveTvDatasource = LiveTvDatasource();
  getIt.registerLazySingleton<LiveTvDatasource>(() => liveTvDatasource);

  //LOGIN TV
  final loginTvUsecase = LoginTvUsecase(
    authDatasource: getIt<AuthDatasource>(),
  );
  getIt.registerLazySingleton<LoginTvUsecase>(() => loginTvUsecase);

  //FETCH USER
  final fetchUserUsecase = FetchUserUsecase(
    authDatasource: getIt<AuthDatasource>(),
  );
  getIt.registerLazySingleton<FetchUserUsecase>(() => fetchUserUsecase);

  //Banner ads
  final bannerAdsUsecase = BannerAdsUsecase(
    homeDatasource: getIt<HomeDatasource>(),
  );
  getIt.registerLazySingleton<BannerAdsUsecase>(() => bannerAdsUsecase);

  //All Highlights

  final allHighlightUsecase = AllHighlightUsecase(
    highLightDatasource: getIt<HighLightDatasource>(),
  );
  getIt.registerLazySingleton<AllHighlightUsecase>(() => allHighlightUsecase);
  //Highlight Detail
  final highlightDetailUsecase = HighLightDeatilUsecase(
    highLightDatasource: getIt<HighLightDatasource>(),
  );
  getIt.registerLazySingleton<HighLightDeatilUsecase>(
    () => highlightDetailUsecase,
  );

  //All Series
  final allSeriesUsecase = AllSeriesUsecase(
    seriesDatasource: getIt<SeriesDatasource>(),
  );
  getIt.registerLazySingleton<AllSeriesUsecase>(() => allSeriesUsecase);

  //Series Detail

  final seriesDetailUsecase = SeriesDetailUsecase(
    seriesDatasource: getIt<SeriesDatasource>(),
  );
  getIt.registerLazySingleton<SeriesDetailUsecase>(() => seriesDetailUsecase);

  //All Channel Catagory
  final channelCatagoryUsecase = ChannelCatagoryUsecase(
    liveTvDatasource: getIt<LiveTvDatasource>(),
  );
  getIt.registerLazySingleton<ChannelCatagoryUsecase>(
    () => channelCatagoryUsecase,
  );

  //All Channel
  final allChannelUsecase = AllChannelUsecase(
    liveTvDatasource: getIt<LiveTvDatasource>(),
  );
  getIt.registerLazySingleton<AllChannelUsecase>(() => allChannelUsecase);

  //Watch Live
  final watchLiveUsecase = WatchLiveUsecase(
    liveTvDatasource: getIt<LiveTvDatasource>(),
  );
  getIt.registerLazySingleton<WatchLiveUsecase>(() => watchLiveUsecase);
  //Match Detail
  final matchDetailUsecase = MatchDetailUsecase(
    seriesDatasource: getIt<SeriesDatasource>(),
  );
  getIt.registerLazySingleton<MatchDetailUsecase>(() => matchDetailUsecase);
}
