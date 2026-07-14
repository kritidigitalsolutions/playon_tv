// ignore_for_file: prefer_initializing_formals

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:playon/core/models/response/podcast_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/feature/podcast/usecase/all_podcast_usecase.dart';
import 'package:playon/feature/podcast/usecase/detail_podcast_usecase.dart';

part 'podcast_event.dart';
part 'podcast_state.dart';
part 'podcast_bloc.freezed.dart';

class PodcastBloc extends Bloc<PodcastEvent, PodcastState> {
  final AllPodcastUsecase _allPodcastUsecase;
  final DetailPodcastUsecase _detailPodcastUsecase;
  PodcastBloc({
    required AllPodcastUsecase allPodcastUsecase,
    required DetailPodcastUsecase detailPodcastUsecase,
  }) : _allPodcastUsecase = allPodcastUsecase,
       _detailPodcastUsecase = detailPodcastUsecase,
       super(PodcastState()) {
    on<_AllPodcast>((event, emit) async {
      emit(state.copyWith(allPodcastStatus: Status.loading));
      final result = await _allPodcastUsecase();
      if (result != null) {
        emit(
          state.copyWith(
            allPodcastStatus: Status.success,
            podcastResponse: result,
          ),
        );
      } else {
        emit(state.copyWith(allPodcastStatus: Status.error));
      }
    });
    on<_PodcastDetail>((event, emit) async {
      emit(state.copyWith(podcastDetailStatus: Status.loading));
      final result = await _detailPodcastUsecase(id: event.podcastId);
      if (result != null) {
        emit(
          state.copyWith(
            podcastDetailStatus: Status.success,
            podcastDetail: result,
          ),
        );
      } else if (result == null) {
        emit(
          state.copyWith(
            podcastDetailStatus: Status.success,
            podcastDetail: null,
          ),
        );
      } else {
        emit(state.copyWith(podcastDetailStatus: Status.error));
      }
    });
  }
}
