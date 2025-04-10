import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:npflix/controller/account_create_controller.dart';
import 'package:npflix/controller/add_favorite_controller.dart';
import 'package:npflix/controller/content_controller.dart';
import 'package:npflix/controller/create_room_controller.dart';
import 'package:npflix/controller/create_user_controller.dart';
import 'package:npflix/controller/language_change_controller.dart';
import 'package:npflix/controller/list_controller.dart';
import 'package:npflix/controller/manage_room_participants_controller.dart';
import 'package:npflix/controller/otp_controller.dart';
import 'package:npflix/controller/payment_controller.dart';
import 'package:npflix/controller/plan_controller.dart';
import 'package:npflix/controller/search_content_controller.dart';
import 'package:npflix/controller/watch_time_controller.dart';
import 'package:npflix/routes/index.dart';
import 'package:npflix/routes/router.dart';
import 'package:npflix/services/applinkDeeplinks_service.dart';
import 'package:npflix/sources/shared_preferences.dart';
import 'package:npflix/ui/screens/room/join_room.dart';
import 'package:npflix/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'controller/dowload_controller.dart';
import 'controller/login_controller.dart';
import 'controller/saveplan_controller.dart';

// In a globals.dart file or similar
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is ready
  // Initialize deep link service
  AppLinksService().initDeepLinks();
  await Firebase.initializeApp(); // Initialize Firebase
  await SharedPreferenceManager.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => LoginController(),
          ),
          ChangeNotifierProvider(
            create: (_) => AccountCreateController(),
          ),
          ChangeNotifierProvider(
            create: (_) => ContentController(),
          ),
          ChangeNotifierProvider(
            create: (_) => PlanController(),
          ),
          ChangeNotifierProvider(
            create: (_) => SearchContentController(),
          ),
          ChangeNotifierProvider(
            create: (_) => CreateUserController(),
          ),
          ChangeNotifierProvider(
            create: (_) => ListController(),
          ),
          ChangeNotifierProvider(
            create: (_) => DowloadController(),
          ),
          ChangeNotifierProvider(create: (_) => AddFavoriteController()),
          ChangeNotifierProvider(create: (_) => LanguageChangeController()),
          ChangeNotifierProvider(create: (_) => PaymentController()),
          ChangeNotifierProvider(create: (_) => WatchTimeController()),
          ChangeNotifierProvider(create: (_) => OtpController()),
          ChangeNotifierProvider(create: (_) => SaveplanController()),
          ChangeNotifierProvider(create: (_) => CreateRoomController()),
          ChangeNotifierProvider(
              create: (_) => ManageRoomParticipantsController()),
        ],
        child: Consumer<LanguageChangeController>(
          builder: (context, provider, child) {
            return MaterialApp(
              title: 'NPLFLIX',
              navigatorKey: navigatorKey,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
              locale: provider.appLocale,
              supportedLocales: const [
                Locale('en'), // nepali
                Locale('ne'), // english
              ],
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: AppColors.btnColor),
                useMaterial3: true,
              ),
              initialRoute: splashScreen,
              onGenerateRoute: MyRouter().generateRoute, // onGenerateRoute: MyRouter().generateRoute,
            );
          },
        ));
  }
}
