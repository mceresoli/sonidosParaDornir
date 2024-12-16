
import 'package:flutter/cupertino.dart';
import 'package:sonidos_de_lluvia_para_dormir/pages/pages.dart';


final Map<String, Widget Function(BuildContext)> appRoutes = {
  'initialPage'                              : (_)=> LluviaPageScreen(),
  'splash'                                   : (_)=> SplashScreen(),    
  'menu'                                     : (_)=> MenuPage(),  
};
