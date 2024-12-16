
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario{

  static final PreferenciasUsuario _instancia =  PreferenciasUsuario._internal();

  factory PreferenciasUsuario(){

    return _instancia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPref() async{

    _prefs = await SharedPreferences.getInstance();

  }

  get lenguaje{
    return _prefs.getString('lenguaje') ?? '';
  }

  set lenguaje(valor){

    _prefs.setString('lenguaje', valor);
  }

}