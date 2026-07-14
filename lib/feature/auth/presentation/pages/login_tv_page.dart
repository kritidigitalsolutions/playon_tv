// ignore_for_file: unused_element

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/animated.dart';
import 'package:playon/core/widgets/app_button.dart';
import 'package:playon/core/widgets/app_snack_bar.dart';
import 'package:playon/core/widgets/app_textstyle.dart';
import 'package:playon/feature/auth/bloc/auth/auth_bloc.dart';
import 'package:playon/static/app_color.dart';
import 'package:playon/static/app_image.dart';
import 'package:playon/static/app_navigation.dart';

class LoginTvPage extends StatefulWidget {
  const LoginTvPage({super.key});

  @override
  State<LoginTvPage> createState() => _LoginTvPageState();
}

class _LoginTvPageState extends State<LoginTvPage> {
  static const int _pinLength = 4;

  final otpController = TextEditingController();

  // Focus node for the real (invisible) text field that the PIN digits
  // sit on top of. Requesting focus on this is what brings up the
  // platform's own system keyboard on Android TV — no custom on-screen
  // keypad needed.
  final _pinFieldFocusNode = FocusNode(debugLabel: 'pin-text-field');

  final _submitFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Repaint the focus ring on the PIN boxes whenever the underlying
    // field's focus state changes.
    _pinFieldFocusNode.addListener(_onPinFieldFocusChange);

    // Fetch and dispatch the device name once the first frame is up,
    // and send initial focus to the PIN field so the system keyboard
    // is ready to go as soon as the page loads.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDeviceName();
      _pinFieldFocusNode.requestFocus();
    });
  }

  void _onPinFieldFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    otpController.dispose();
    _pinFieldFocusNode.removeListener(_onPinFieldFocusChange);
    _pinFieldFocusNode.dispose();
    _submitFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();

    String deviceName = "Unknown Device";

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      deviceName = "${info.manufacturer} ${info.model}";
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      deviceName = info.name;
    } else if (Platform.isWindows) {
      final info = await deviceInfo.windowsInfo;
      deviceName = info.computerName;
    }

    if (mounted) {
      context.read<AuthBloc>().add(AuthEvent.deviceName(deviceName));
    }
  }

  /// Single source of truth for PIN input, fed by the real TextField's
  /// onChanged below — works identically whether the digits came from
  /// Android TV's system keyboard overlay, a connected Bluetooth
  /// keyboard, or a remote with a numeric keypad.
  void _onPinChanged(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    final trimmed = digitsOnly.length > _pinLength
        ? digitsOnly.substring(0, _pinLength)
        : digitsOnly;

    if (trimmed != value) {
      // Keep the field's own text in sync if we stripped non-digits
      // or truncated past the max length.
      otpController.value = TextEditingValue(
        text: trimmed,
        selection: TextSelection.collapsed(offset: trimmed.length),
      );
    }

    context.read<AuthBloc>().add(AuthEvent.otp(trimmed));

    if (trimmed.length == _pinLength) {
      debugPrint('PIN entered: $trimmed');
      _submitFocusNode.requestFocus();
    }

    setState(() {}); // refresh PIN digits
  }

  void _submit() {
    if (otpController.text.length == _pinLength) {
      context.read<AuthBloc>().add(AuthEvent.loginTv());
    }
  }

  // Helper to build PIN indicator showing actual digits for TV
  Widget _buildPinDisplay() {
    final hasFieldFocus = _pinFieldFocusNode.hasFocus;
    final pinText = otpController.text;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(_pinLength, (index) {
        final bool isFilled = index < pinText.length;
        final String digit = isFilled ? pinText[index] : '';
        final bool isFocused =
            hasFieldFocus &&
            index == pinText.length &&
            pinText.length < _pinLength;

        return Container(
          width: 76,
          height: 88,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: isFilled
                ? AppColors.primary.withOpacity(0.15)
                : AppColors.background,
            border: Border.all(
              color: isFocused ? AppColors.primary : AppColors.grey400,
              width: isFocused ? 3 : 2,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isFocused
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isFilled
                ? Text(
                    digit,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : isFocused
                ? Container(width: 30, height: 3, color: AppColors.primary)
                : null,
          ),
        );
      }),
    );
  }

  /// PIN entry control: the digit display renders on top, and underneath
  /// it sits a real (invisible) TextField. Tapping/selecting this area
  /// focuses that field, which is what triggers Android TV's own
  /// system keyboard overlay — no custom keypad UI is drawn by us.
  Widget _buildPinInput() {
    return SizedBox(
      width: _pinLength * 76 + (_pinLength - 1) * 12,
      height: 88,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          _buildPinDisplay(),
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                focusNode: _pinFieldFocusNode,
                controller: otpController,
                autofocus: true,
                keyboardType: TextInputType.number,
                maxLength: _pinLength,
                onChanged: _onPinChanged,
                showCursor: false,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final horizontalPadding = size.width * 0.06;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.loginStatus == Status.success) {
          AppNavigation.pushReplacement(context, "/");
          AppSnackbar.success(context, 'login success');
        } else if (state.loginStatus == Status.error) {
          AppSnackbar.error(context, 'incorrect code');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: BackgroundWithOneLight(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Center(
                          child: AnimatedBox(
                            height: size.height * 0.6,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.primary),
                            child: Image.asset(
                              AppImage.tv,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Activate on TV", style: text24()),
                              const SizedBox(height: 12),
                              Text(
                                "Stream on your Big Screen",
                                style: text17(color: AppColors.grey500),
                              ),
                              const SizedBox(height: 28),
                              Text(
                                "Enjoy every match on your TV with a\nquick and easy setup",
                                style: text17(color: AppColors.grey500),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Open the app on your TV and enter\nthe code shown to connect",
                                style: text17(),
                              ),
                              const SizedBox(height: 24),

                              // PIN digits + underlying real TextField.
                              // Selecting/focusing this brings up the
                              // system keyboard — no custom keypad.
                              _buildPinInput(),

                              const SizedBox(height: 8),
                              Text(
                                "Select the code field and use your TV's keyboard to enter the digits",
                                style: text14(color: AppColors.grey500),
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                height: 56,
                                width: 220,
                                child: TvFocusable(
                                  focusNode: _submitFocusNode,
                                  borderRadius: BorderRadius.circular(10),
                                  onSelect: _submit,
                                  child: AppButton(
                                    radius: 10,
                                    title: "Submit your code",
                                    onTap: _submit,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}