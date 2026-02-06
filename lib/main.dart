import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:inspecaosegurancacipa/pages/subestacao/provider.dart';
import 'package:inspecaosegurancacipa/pages/usina/provider.dart';
import 'package:inspecaosegurancacipa/pages/predio/provider.dart';
import 'package:inspecaosegurancacipa/pages/veiculo/provider.dart';

import 'package:inspecaosegurancacipa/utils/routes.dart';

void main() async {
  // Garante que os widgets sejam inicializados antes de executar o app
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Carrega o splashscreen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configura o modo de exibição da interface do sistema
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));

  // Carrega as variáveis de ambiente do arquivo .env
  // SECURITY NOTE: For production, use --dart-define or secure storage
  // instead of bundling .env file in assets
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // .env file not found - email features will be disabled
    debugPrint('Warning: .env file not found. Email features will be disabled.');
  }

  // Executa o aplicativo
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return MultiProvider(
      // Configura os providers para gerenciar o estado das diferentes páginas
      providers: [
        ChangeNotifierProvider(create: (context) => SubestacaoProvider()),
        ChangeNotifierProvider(create: (context) => UsinaProvider()),
        ChangeNotifierProvider(create: (context) => PredioProvider()),
        ChangeNotifierProvider(create: (context) => VeiculoProvider()),
      ],
      builder: (context, child) => MaterialApp(
        // Configura as localizações suportadas pelo app
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('pt'), // Define o idioma suportado como português
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFEC6500),
            primary: const Color(0xFFEC6500),
            brightness: Brightness.light
          ),
          useMaterial3: true,
        ),
        initialRoute: Routes.initial,
        onGenerateRoute: Routes.onGenerateRoute,
        navigatorKey: Routes.navigatorKey,
      ),
    );
  }
}
