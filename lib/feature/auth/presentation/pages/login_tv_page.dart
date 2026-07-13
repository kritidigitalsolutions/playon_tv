// ignore_for_file: unused_element

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playon/core/service/enum.dart';
import 'package:playon/core/service/tv_focus_navigation.dart';
import 'package:playon/core/widgets/animated.dart';
import 'package:playon/core/widgets/app_button.dart';
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

  final _pinKeyFocusNode = FocusNode(debugLabel: 'pin-hardware-input');

  final _submitFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Fetch and dispatch the device name once the first frame is up.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDeviceName();
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    _pinKeyFocusNode.dispose();
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

  KeyEventResult _handlePinKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;

    // Backspace / Delete removes the last digit.
    if (key == LogicalKeyboardKey.backspace ||
        key == LogicalKeyboardKey.delete) {
      if (otpController.text.isNotEmpty) {
        setState(() {
          otpController.text = otpController.text.substring(
            0,
            otpController.text.length - 1,
          );
        });
        // Update the bloc with the new value
        context.read<AuthBloc>().add(AuthEvent.otp(otpController.text));
      }
      return KeyEventResult.handled;
    }

    final digit = _digitFor(key);
    if (digit != null && otpController.text.length < _pinLength) {
      setState(() {
        otpController.text += digit;
      });
      // Update the bloc with the new value
      context.read<AuthBloc>().add(AuthEvent.otp(otpController.text));

      if (otpController.text.length == _pinLength) {
        debugPrint('PIN entered: ${otpController.text}');
        _submitFocusNode.requestFocus();
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  static final Map<LogicalKeyboardKey, String> _digitKeyMap = {
    LogicalKeyboardKey.digit0: '0',
    LogicalKeyboardKey.digit1: '1',
    LogicalKeyboardKey.digit2: '2',
    LogicalKeyboardKey.digit3: '3',
    LogicalKeyboardKey.digit4: '4',
    LogicalKeyboardKey.digit5: '5',
    LogicalKeyboardKey.digit6: '6',
    LogicalKeyboardKey.digit7: '7',
    LogicalKeyboardKey.digit8: '8',
    LogicalKeyboardKey.digit9: '9',
    LogicalKeyboardKey.numpad0: '0',
    LogicalKeyboardKey.numpad1: '1',
    LogicalKeyboardKey.numpad2: '2',
    LogicalKeyboardKey.numpad3: '3',
    LogicalKeyboardKey.numpad4: '4',
    LogicalKeyboardKey.numpad5: '5',
    LogicalKeyboardKey.numpad6: '6',
    LogicalKeyboardKey.numpad7: '7',
    LogicalKeyboardKey.numpad8: '8',
    LogicalKeyboardKey.numpad9: '9',
  };

  String? _digitFor(KeyboardKey key) => _digitKeyMap[key];

  void _submit() {
    if (otpController.text.length == _pinLength) {
      context.read<AuthBloc>().add(AuthEvent.loginTv());
    }
  }

  // Helper to build PIN indicator dots for TV
  Widget _buildPinDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(_pinLength, (index) {
        final bool isFilled = index < otpController.text.length;
        final bool isFocused =
            index == otpController.text.length &&
            otpController.text.length < _pinLength;

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
                ? Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final horizontalPadding = size.width * 0.06;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.loginStatus == Status.success) {
          AppNavigation.pushReplacement(context, "/");
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

                            // Custom PIN input for TV with hardware keyboard support
                            Focus(
                              focusNode: _pinKeyFocusNode,
                              autofocus: true,
                              onKeyEvent: _handlePinKey,
                              child: _buildPinDisplay(),
                            ),

                            const SizedBox(height: 8),
                            Text(
                              "Use number keys on your remote to enter the code",
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
