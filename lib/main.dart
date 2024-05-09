import 'constants/common_system_ui.dart';
import 'exports.dart';
import 'home/view/home_page.dart';
import 'home/repository/home_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexoft/home/cubit/home_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

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
        create: (context) => HomeCubit(homeRepository: _homeRepository),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

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
      theme: ThemeData.light().copyWith(
        snackBarTheme: SnackBarThemeData(
          elevation: 4,
          backgroundColor: ColorConstants.pageColor,
          contentTextStyle: const TextStyle(color: Colors.white),
        ),
        textTheme: GoogleFonts.nunitoTextTheme().apply(bodyColor: Colors.white),
        scaffoldBackgroundColor: ColorConstants.white,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          systemOverlayStyle: SystemUi.darkStyle(),
        ),
      ),
      darkTheme: ThemeData.light().copyWith(
        textTheme: GoogleFonts.nunitoTextTheme().apply(bodyColor: Colors.white),
        scaffoldBackgroundColor: ColorConstants.pageColor,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          systemOverlayStyle: SystemUi.darkStyle(),
        ),
      ),
      home: const HomePage(),
    );
  }
}
