// ignore_for_file: prefer_initializing_formals

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:playon/core/models/response/user_model.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/feature/auth/usecase/fetch_user_usecase.dart';
import 'package:playon/feature/auth/usecase/login_tv_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginTvUsecase _loginTvUsecase;
  final FetchUserUsecase _fetchUserUsecase;
  
  AuthBloc({
    required LoginTvUsecase loginTvUsecase,
    required FetchUserUsecase fetchUserUsecase,
  }) : _loginTvUsecase = loginTvUsecase,
   _fetchUserUsecase = fetchUserUsecase,
   super(AuthState()) {
    on<_Otp>((event, emit) {
      emit(state.copyWith(otp: event.value));
    });
    on<_LoginTv>((event, emit) async {
      emit(state.copyWith(loginStatus: Status.loading));
      final result=await _loginTvUsecase(code: state.otp,deviceName: state.devicename);
      if(result){
        emit(state.copyWith(loginStatus: Status.success));
        debugPrint("login tv success");
        debugPrint(state.devicename);
        add(_FetchUser());
        emit(state.copyWith(otp: ""));
      }else{
        emit(state.copyWith(loginStatus: Status.error));
      }
    });
  on<_DeviceName>((event, emit) => emit(state.copyWith(devicename: event.value)),);
    
    on<_FetchUser>((event, emit) async {
      emit(state.copyWith(fetchStatus: Status.loading));
      final UserModel? user=await _fetchUserUsecase();
      if(user!=null){
        emit(state.copyWith(user: user, fetchStatus: Status.success));
      }
      else{
        emit(state.copyWith(fetchStatus: Status.error));
      }
    },);
  }
}
