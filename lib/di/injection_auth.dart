part of 'injection.dart';

Future<void> _authDependency() async {
  //Auth Datasource
  final datasource = AuthDatasource();
  getIt.registerLazySingleton<AuthDatasource>(() => datasource);
  //Home Datasource
  final homeDatasource = HomeDatasource();
  getIt.registerLazySingleton<HomeDatasource>(() => homeDatasource);

  //Highlight Datasource
  final highlightDatasource = HighLightDatasource();
  getIt.registerLazySingleton<HighLightDatasource>(() => highlightDatasource);

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
}
