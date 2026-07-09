import 'package:playon/core/models/response/banner_model.dart';
import 'package:playon/feature/home/datasource/home_datasource.dart';

class BannerAdsUsecase {
  final HomeDatasource _homeDatasource;

  BannerAdsUsecase({required this._homeDatasource});

  Future<List<BannerModel>> call() async {
    return await _homeDatasource.allBanner();
  }
}