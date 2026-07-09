part of 'injection.dart';

class InjectionBlock {
  static AuthBloc get authBloc => AuthBloc(
    loginTvUsecase: getIt<LoginTvUsecase>(),
    fetchUserUsecase: getIt<FetchUserUsecase>(),
  );
  static BannerAdsBloc get bannerAdsBloc =>
      BannerAdsBloc(bannerAdsUsecase: getIt<BannerAdsUsecase>());
  static HighlightBloc get highlightBloc =>
      HighlightBloc(highlightUsecase: getIt<AllHighlightUsecase>());
}
