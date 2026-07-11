part of 'social_media_cubit.dart';

@freezed
abstract class SocialMediaState with _$SocialMediaState {
  const factory SocialMediaState({
    @Default([])List<SocialModel> socialMedia,
    @Default(Status.init)Status socialMediaStatus,
  })=_SocialMediaState;
}
