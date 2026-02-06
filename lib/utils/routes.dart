import 'package:flutter/material.dart';
import 'package:inspecaosegurancacipa/pages/predio/inspecao_page.dart';
import 'package:inspecaosegurancacipa/pages/predio/perguntas_page.dart';
import 'package:inspecaosegurancacipa/pages/predio/resumo_page.dart';
import 'package:inspecaosegurancacipa/pages/subestacao/inspecao_page.dart';
import 'package:inspecaosegurancacipa/pages/subestacao/perguntas_page.dart';
import 'package:inspecaosegurancacipa/pages/usina/inspecao_page.dart';
import 'package:inspecaosegurancacipa/pages/usina/perguntas_page.dart';
import 'package:inspecaosegurancacipa/pages/usina/resumo_page.dart';
import 'package:inspecaosegurancacipa/pages/usina/usina_page.dart';

import '../pages/home_page.dart';
import '../pages/predio/predio_page.dart';
import '../pages/subestacao/resumo_page.dart';
import '../pages/subestacao/subestacao_page.dart';
import '../pages/veiculo/inspecao_page.dart';
import '../pages/veiculo/perguntas_page.dart';
import '../pages/veiculo/resumo_page.dart';
import '../pages/veiculo/veiculo_page.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => const HomePage());

      case "/subestacao":
        return MaterialPageRoute(builder: (context) => const SubestacaoPage());

      case "/inspecao-subestacao":
        return MaterialPageRoute(builder: (context) => const InspecaoSubestacaoPage());

      case "/perguntas-subestacao":
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => PerguntasSubestacaoPage(id: args['id']));

      case "/inspecao-subestacao-resumo":
        return MaterialPageRoute(builder: (context) => const ResumoInspecaoSubestacaoPage());

      case "/usina":
        return MaterialPageRoute(builder: (context) => const UsinaPage());

      case "/inspecao-usina":
        return MaterialPageRoute(builder: (context) => const InspecaoUsinaPage());

      case "/perguntas-usina":
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => PerguntasUsinaPage(id: args['id']));

      case "/inspecao-usina-resumo":
        return MaterialPageRoute(builder: (context) => const ResumoInspecaoUsinaPage());

      case "/predio":
        return MaterialPageRoute(builder: (context) => const PredioPage());

      case "/inspecao-predio":
        return MaterialPageRoute(builder: (context) => const InspecaoPredioPage());

      case "/perguntas-predio":
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => PerguntasPredioPage(id: args['id']));

      case "/inspecao-predio-resumo":
        return MaterialPageRoute(builder: (context) => const ResumoInspecaoPredioPage());

      case "/veiculo":
        return MaterialPageRoute(builder: (context) => const VeiculoPage());

      case "/inspecao-veiculo":
        return MaterialPageRoute(builder: (context) => const InspecaoVeiculoPage());

      case "/perguntas-veiculo":
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => PerguntasVeiculoPage(id: args['id']));

      case "/inspecao-veiculo-resumo":
        return MaterialPageRoute(builder: (context) => const ResumoInspecaoVeiculoPage());

      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }

  static String initial = '/';

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
