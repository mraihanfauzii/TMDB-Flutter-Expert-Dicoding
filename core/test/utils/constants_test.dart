import 'package:core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Constants Test', () {
    test('BASE_IMAGE_URL is correct', () {
      expect(BASE_IMAGE_URL, 'https://image.tmdb.org/t/p/w500');
    });

    test('Colors check', () {
      expect(kRichBlack, const Color(0xFF000814));
      expect(kOxfordBlue, const Color(0xFF001D3D));
      expect(kPrussianBlue, const Color(0xFF003566));
      expect(kMikadoYellow, const Color(0xFFffc300));
      expect(kDavysGrey, const Color(0xFF4B5358));
      expect(kGrey, const Color(0xFF303030));
    });

    test('kHeading5 and kBodyText come from GoogleFonts.poppins', () {
      final heading = kHeading5;
      // Hanya pastikan memuat "Poppins"
      expect(heading.fontFamily, contains('Poppins'));

      final body = kBodyText;
      expect(body.fontFamily, contains('Poppins'));
    });

    test('kHeading6 uses Poppins w500', () {
      final heading6 = kHeading6;
      expect(heading6.fontFamily, contains('Poppins'));
      expect(heading6.fontWeight, FontWeight.w500);
    });

    test('kSubtitle uses Poppins w400', () {
      final subtitle = kSubtitle;
      expect(subtitle.fontFamily, contains('Poppins'));
      expect(subtitle.fontWeight, FontWeight.w400);
    });

    test('kColorScheme is dark scheme', () {
      expect(kColorScheme.brightness, Brightness.dark);
    });

    test('kColorScheme each property check', () {
      expect(kColorScheme.primary, kMikadoYellow);
      expect(kColorScheme.secondary, kPrussianBlue);
      expect(kColorScheme.surface, kRichBlack);
      expect(kColorScheme.onPrimary, kRichBlack);
    });

    test('kDrawerTheme is not null', () {
      expect(kDrawerTheme.backgroundColor, isA<Color>());
    });
  });
}
