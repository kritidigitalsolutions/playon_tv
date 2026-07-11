part of 'banner_ads_bloc.dart';

@freezed
class BannerAdsEvent with _$BannerAdsEvent {
  const factory BannerAdsEvent.fetchBannerAds() = _FetchBanner;
}
