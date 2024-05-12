import 'exports.dart';
import 'style/common_system_ui.dart';
import 'pages/home/view/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/home/repository/home_repository.dart';
import 'package:nexoft/pages/home/cubit/home_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final HomeRepository _homeRepository;

  @override
  void initState() {
    super.initState();
    _homeRepository = HomeRepository();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _homeRepository,
      child: BlocProvider(
        create: (context) => HomeCubit(homeRepository: _homeRepository)..getUsersList(),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      title: 'Nexoft',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('tr'), // Turkish
      ],
      theme: ThemeData.dark().copyWith(
        snackBarTheme: SnackBarThemeData(
          elevation: 4,
          backgroundColor: ColorConstants.pageColor,
          contentTextStyle: TextStyle(color: ColorConstants.black),
        ),
        textTheme: GoogleFonts.nunitoTextTheme().apply(bodyColor: ColorConstants.black),
        scaffoldBackgroundColor: ColorConstants.pageColor,
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.transparent,
          systemOverlayStyle: SystemUi.darkStyle(),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        snackBarTheme: SnackBarThemeData(
          elevation: 4,
          backgroundColor: ColorConstants.pageColor,
          contentTextStyle: TextStyle(color: ColorConstants.black),
        ),
        textTheme: GoogleFonts.nunitoTextTheme().apply(bodyColor: ColorConstants.black),
        scaffoldBackgroundColor: ColorConstants.pageColor,
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.transparent,
          systemOverlayStyle: SystemUi.darkStyle(),
        ),
      ),
      home: const HomePage(),
    );
  }
}
