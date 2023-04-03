import 'package:flutter/material.dart';

/// Constant sizes to be used in the app (paddings, gaps, rounded corners etc.)
class Sizes {
  static const p4 = 4.0;
  static const p8 = 8.0;
  static const p12 = 12.0;
  static const p16 = 16.0;
  static const p20 = 20.0;
  static const p24 = 24.0;
  static const p28 = 28.0;
  static const p32 = 32.0;
  static const p36 = 36.0;
  static const p48 = 48.0;
  static const p64 = 64.0;
}

/// Constant gap width and height using [SizedBox]
class Gaps {
  static const w4 = SizedBox(width: Sizes.p4);
  static const w8 = SizedBox(width: Sizes.p8);
  static const w12 = SizedBox(width: Sizes.p12);
  static const w16 = SizedBox(width: Sizes.p16);
  static const w20 = SizedBox(width: Sizes.p20);
  static const w24 = SizedBox(width: Sizes.p24);
  static const w32 = SizedBox(width: Sizes.p32);
  static const w48 = SizedBox(width: Sizes.p48);
  static const w64 = SizedBox(width: Sizes.p64);

  static const h4 = SizedBox(height: Sizes.p4);
  static const h8 = SizedBox(height: Sizes.p8);
  static const h12 = SizedBox(height: Sizes.p12);
  static const h16 = SizedBox(height: Sizes.p16);
  static const h20 = SizedBox(height: Sizes.p20);
  static const h24 = SizedBox(height: Sizes.p24);
  static const h32 = SizedBox(height: Sizes.p32);
  static const h48 = SizedBox(height: Sizes.p48);
  static const h64 = SizedBox(height: Sizes.p64);
  static const divider = Divider(height: 0.0);
}
