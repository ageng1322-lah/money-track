// lib/main.dart
import 'package:fintrack/shared/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'core/bindings/initial_binding.dart';
import 'core/router/app_pages.dart';
import 'core/theme/app_theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:      Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: FinTrackApp(),
    ),
  );
}

class FinTrackApp extends ConsumerWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return GetMaterialApp(
      title:              'FinTrack',
      debugShowCheckedModeBanner: false,
      theme:              AppTheme.light,
      darkTheme:          AppTheme.dark,
      themeMode:          themeMode,
      initialRoute:       AppPages.INITIAL,
      getPages:           AppPages.routes,
      initialBinding:     InitialBinding(),
      defaultTransition:  Transition.cupertino,
    );
  }
}
