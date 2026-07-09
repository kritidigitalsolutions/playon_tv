// ignore_for_file: prefer_initializing_formals, unused_field

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:playon/core/models/response/banner_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/feature/home/usecase/banner_ads_usecase.dart';

part 'banner_ads_event.dart';
part 'banner_ads_state.dart';
part 'banner_ads_bloc.freezed.dart';

class BannerAdsBloc extends Bloc<BannerAdsEvent, BannerAdsState> {
  final BannerAdsUsecase _bannerAdsUsecase;
  BannerAdsBloc({required BannerAdsUsecase bannerAdsUsecase})
    : _bannerAdsUsecase = bannerAdsUsecase,
      super(BannerAdsState()) {
    on<_FetchBanner>((event, emit) async {
      emit(state.copyWith(bannerStatus: Status.loading));
      final result = await _bannerAdsUsecase();
      if (result.isNotEmpty) {
        emit(state.copyWith(bannerAds: result, bannerStatus: Status.success));
      } else if (result.isEmpty) {
        emit(state.copyWith(bannerStatus: Status.success));
      } else {
        emit(state.copyWith(bannerStatus: Status.error));
      }
    });
  }
}
