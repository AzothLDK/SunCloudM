import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:suncloudm/View/LogView/model/personalPageProvider.dart';
import 'package:suncloudm/View/OAM/oam_workspace/model/oplDataAnalysisProvider.dart';
import 'package:suncloudm/generated/l10n.dart';
import 'package:suncloudm/toolview/personal_info_provider.dart';
import 'View/LogView/login_page.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'dao/storage.dart';
import 'toolview/language_provider.dart'; // 导入新创建的LanguageProvider

void main() async {
  await ScreenUtil.ensureScreenSize();
  await GlobalStorage.getInstance();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PersonalPageProvider()),
        ChangeNotifierProvider(create: (_) => OplDataAnalysisProvider()),
        ChangeNotifierProvider(
            create: (_) => LanguageProvider()), // 添加LanguageProvider
        ChangeNotifierProvider(create: (_) => PersonalInfoProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            locale: languageProvider.currentLocale,
            debugShowCheckedModeBanner: false,
            navigatorKey: globalNavigatorKey,
            onGenerateRoute: (settings) {
              final routeName = settings.name;
              if (routeName == "/login") {
                return MaterialPageRoute(
                  builder: (context) => LoginPage(
                    onLocaleChange: (Locale locale) {
                      languageProvider.changeLanguage(locale);
                    },
                  ),
                );
              }
              return null;
            },
            title: '晟能新能源云',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            ),
            home: LoginPage(onLocaleChange: (Locale locale) {
              languageProvider.changeLanguage(locale);
            }),
            localizationsDelegates: const [
              S.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              MonthYearPickerLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'), // 英文
              Locale('zh', 'CN'), // 简体中文
            ],
          );
        },
      ),
    );
  }
}
