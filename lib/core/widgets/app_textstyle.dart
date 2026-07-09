import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playon/static/app_color.dart';

// 🔥 Base function (reusable) with Google Fonts
TextStyle _base({
  required double size,
  FontWeight fontWeight = FontWeight.normal,
  Color color = AppColors.textPrimary,
  double lineHeight = 1.4,
  double letterSpacing = 0.2,
}) {
  return GoogleFonts.poppins(
    fontSize: size,
    fontWeight: fontWeight,
    color: color,
    height: lineHeight,
    letterSpacing: letterSpacing,
  );
}

// ================= SIZES =================

TextStyle text10({
  FontWeight fontWeight = FontWeight.normal,
  Color color = AppColors.textPrimary,
}) => _base(size: 10, fontWeight: fontWeight, color: color);

TextStyle text11({
  FontWeight fontWeight = FontWeight.normal,
  Color color = AppColors.textPrimary,
}) => _base(size: 11, fontWeight: fontWeight, color: color);

TextStyle text12({
  FontWeight fontWeight = FontWeight.normal,
  Color color = AppColors.textPrimary,
}) => _base(size: 12, fontWeight: fontWeight, color: color);

TextStyle text13({
  FontWeight fontWeight = FontWeight.normal,
  Color color = AppColors.textPrimary,
}) => _base(size: 13, fontWeight: fontWeight, color: color);

TextStyle text14({
  FontWeight fontWeight = FontWeight.normal,
  Color color = AppColors.textPrimary,
}) => _base(size: 14, fontWeight: fontWeight, color: color);

TextStyle text15({
  FontWeight fontWeight = FontWeight.normal,
  Color color = AppColors.textPrimary,
}) => _base(size: 15, fontWeight: fontWeight, color: color);

TextStyle text16({
  FontWeight fontWeight = FontWeight.normal,
  Color color = AppColors.textPrimary,
}) => _base(size: 16, fontWeight: fontWeight, color: color);

TextStyle text17({
  FontWeight fontWeight = FontWeight.w600,
  Color color = AppColors.textPrimary,
}) => _base(size: 17, fontWeight: fontWeight, color: color, lineHeight: 1.3);

TextStyle text18({
  FontWeight fontWeight = FontWeight.w600,
  Color color = AppColors.textPrimary,
}) => _base(size: 18, fontWeight: fontWeight, color: color, lineHeight: 1.3);

TextStyle text20({
  FontWeight fontWeight = FontWeight.w600,
  Color color = AppColors.textPrimary,
}) => _base(size: 20, fontWeight: fontWeight, color: color, lineHeight: 1.3);

TextStyle text24({
  FontWeight fontWeight = FontWeight.bold,
  Color color = AppColors.textPrimary,
}) => _base(size: 24, fontWeight: fontWeight, color: color, lineHeight: 1.2);

TextStyle text30({
  FontWeight fontWeight = FontWeight.bold,
  Color color = AppColors.textPrimary,
}) => _base(size: 30, fontWeight: fontWeight, color: color, lineHeight: 1.1);

// ================= EXTRA =================

TextStyle heading({Color color = AppColors.textPrimary}) => _base(
  size: 22,
  fontWeight: FontWeight.bold,
  color: color,
  lineHeight: 1.2,
  letterSpacing: 0.3,
);

TextStyle subtitle({Color color = AppColors.textSecondary}) => _base(
  size: 14,
  fontWeight: FontWeight.w500,
  color: color,
  lineHeight: 1.4,
  letterSpacing: 0.2,
);
