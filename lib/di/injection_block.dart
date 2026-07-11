part of 'injection.dart';

class InjectionBlock {
  static AuthBloc get authBloc => AuthBloc(
    loginTvUsecase: getIt<LoginTvUsecase>(),
    fetchUserUsecase: getIt<FetchUserUsecase>(),
  );
  static BannerAdsBloc get bannerAdsBloc =>
      BannerAdsBloc(bannerAdsUsecase: getIt<BannerAdsUsecase>());
  static HighlightBloc get highlightBloc => HighlightBloc(
    allHighlightUsecase: getIt<AllHighlightUsecase>(),
    highlightDeatilUsecase: getIt<HighLightDeatilUsecase>(),
  );

  static SeriesBloc get seriesBloc => SeriesBloc(
    allSeriesUsecase: getIt<AllSeriesUsecase>(),
    seriesDetailUsecase: getIt<SeriesDetailUsecase>(),
  );

  static ChannelCatagoryBloc get channelCatagoryBloc => ChannelCatagoryBloc(
    channelCatagoryUsecase: getIt<ChannelCatagoryUsecase>(),
  );
  static SocialMediaCubit get socialMediaCubit => SocialMediaCubit();
  static ChannelsBloc get channelsBloc =>
      ChannelsBloc(allChannelUsecase: getIt<AllChannelUsecase>());

  static WatchLiveBloc get watchLiveBloc => WatchLiveBloc(
    watchLiveUsecase: getIt<WatchLiveUsecase>(),
  );
  static MatchBloc get matchBloc => MatchBloc(
    matchDetailUsecase: getIt<MatchDetailUsecase>(),
  );
  static StarPayerCubit get starPayerCubit => StarPayerCubit(
    allStarPlayerUseCase: getIt<AllStarPlayerUseCase>(),
  );
}
