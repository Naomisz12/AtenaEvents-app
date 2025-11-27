import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildAppTheme() {
  const primary = Color(0xFF8E97FD);

  final colorScheme = ColorScheme.fromSeed(seedColor: primary).copyWith(
    primary: primary,
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFDDE0FF),
    onPrimaryContainer: const Color(0xFF212559),
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,                  
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  );

  return base.copyWith(
    textTheme: GoogleFonts.robotoTextTheme(base.textTheme),

    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF2F3F7),
      hintStyle: TextStyle(color: Colors.black38),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide.none,
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
        foregroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.2),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 18),
        ),
        shape: const WidgetStatePropertyAll(StadiumBorder()),
        elevation: const WidgetStatePropertyAll(0),
      ),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.primary,
      centerTitle: true,
      elevation: 0,
    ),

    chipTheme: base.chipTheme.copyWith(
      color: WidgetStatePropertyAll(colorScheme.surface),
      labelStyle: TextStyle(color: colorScheme.onSurface),
      selectedColor: colorScheme.primaryContainer,
    ),
  );
}
