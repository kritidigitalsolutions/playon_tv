part of 'banner_ads_bloc.dart';

@freezed
abstract  class BannerAdsState with _$BannerAdsState {
  const factory BannerAdsState({
    @Default(Status.init)Status bannerStatus,
    @Default([])List<BannerModel> bannerAds,
  })=_BannerAdsState;
}
