import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sonidos_de_lluvia_para_dormir/provider/estadoAppProvider.dart';
import 'package:sonidos_de_lluvia_para_dormir/routes/appRoutes.dart';
import 'package:sonidos_de_lluvia_para_dormir/shared_prefs/preferencias_usuario.dart';

void main() async{  
  WidgetsFlutterBinding.ensureInitialized();    

  final prefs =  PreferenciasUsuario();
  await prefs.initPref();  
  runApp(AppState());
}

class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (_) =>  EstadoAppProvider(),lazy: false,),
      ],
      child: MyApp(),
    );
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sonido de lluvia para dormir',
      theme: _theme(),
      initialRoute: 'splash' ,
      routes: appRoutes,
    );
  }



  ThemeData _theme() {
    return ThemeData(primarySwatch: Colors.indigo,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color:Colors.indigo,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color:Colors.indigo,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color:Colors.indigo,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodySmall: TextStyle(
          color:Colors.indigo,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(
          color:Colors.indigo,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color:Colors.indigo,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
       )
      );
  }



}