import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:playon/core/models/response/social_media_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/feature/home/datasource/home_datasource.dart';

part 'social_media_state.dart';
part 'social_media_cubit.freezed.dart';

class SocialMediaCubit extends Cubit<SocialMediaState> {
  final HomeDatasource homeDatasource=HomeDatasource();
  SocialMediaCubit() : super(SocialMediaState());
  void getSocialMedia() async {
    emit(state.copyWith(socialMediaStatus: Status.loading));
    try {
      final socialMedia = await homeDatasource.allSocialMedia();
      emit(state.copyWith(socialMedia: socialMedia, socialMediaStatus: Status.success));
    } catch (e) {
      emit(state.copyWith(socialMediaStatus: Status.error));
    }
  }
}
