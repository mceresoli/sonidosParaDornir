import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:sonidos_de_lluvia_para_dormir/util/app_review.dart';
import 'package:url_launcher/url_launcher.dart';


class PropertiesPageScreen extends StatelessWidget {
  const PropertiesPageScreen({super.key});

Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sonidos para dormir',style: TextStyle(color: Colors.white70),),
        centerTitle: true,
        backgroundColor: Colors.blue[400],
      ),
     body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: size.height * 0.8,
            width: size.width,
            padding: const EdgeInsets.only(left: 15.0,right: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _valora(size.width), 
                const Text('Aplicaciones Recomendadas',
                            style: TextStyle( color: Colors.blueGrey, 
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.normal
                                                          ),),
                _aplicacion('lib/assets/icon/senal_icon 512x512.png'    ,'Exámen de conducir '                                   ,'https://play.google.com/store/apps/details?id=com.mceresoli.simuladorExamenSeguridadVial', size.width ),
                _aplicacion('lib/assets/icon/ExamenPracticoLogo.png'  ,'Examen Práctico de conducir ','https://play.google.com/store/apps/details?id=com.mc.examen_practico_de_manejo', size.width ),
                _aplicacion('lib/assets/icon/preguntasLogo.png'       ,'Preguntas de examen de manejo','https://play.google.com/store/apps/details?id=com.marcosMC.preguntasExamenDeConducir', size.width ),
                _aplicacion('lib/assets/icon/examenMotoLogo.png'      ,'Examen de conducir Motos','https://play.google.com/store/apps/details?id=com.mceresoli.simuladorExamenSeguridadVialMoto', size.width ),
                _aplicacion('lib/assets/icon/senialesEEUUlogo.png'    ,'Señales de tráfico de EEUU' ,'https://play.google.com/store/apps/details?id=com.marcosMC.US.traffic.signs&hl=es_AR', size.width ),                            
              ],
            )
            ),
             ),
      ),
   );
  }

GestureDetector _aplicacion(String logo,String descripcion,String url,double anchoTotal){
    final card = Row(
      children: <Widget>[
         FadeInImage(
          width: 45,
          height: 45,
          placeholder: const AssetImage('lib/assets/giphy.gif'),
          image: AssetImage(logo),
        ),
        Container(
          width: anchoTotal - 150,
            padding: const EdgeInsets.all(5.0), 
            child: Text(descripcion,
                        style: const TextStyle( color: Colors.blueGrey, 
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal
                                               ),
                        )
        ),
      ],
    );

    return GestureDetector(
      onTap: (){_launchUrl(url);},
      child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                            offset: Offset(2.0, 10.0)),
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Padding(
                      padding: const EdgeInsets.all( 6.0),
                      child: card,
                    ),
      )),
    );
  }

Future<void> _launchUrl(String url) async {
   final Uri _url = Uri.parse(url);
   if (!await launchUrl(_url,mode: LaunchMode.externalNonBrowserApplication,)) {
    throw 'Could not launch $_url';
   }
}

_valora(double anchoTotal) {

  final card = Row(
      children: <Widget>[
        Container(
          color: Colors.amber[900],
          width: 45,
          height: 45,
          child: const Icon(Icons.star_border,)
        ),

        Container(
          width: anchoTotal - 150,
          padding: const EdgeInsets.all(10.0), 
                   child: const Text('Valoranos en Play Store',
                                    style: TextStyle( color: Colors.blueGrey, 
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal
                                               ),
                   ),                
         ),
      ],
    );

 return GestureDetector(
      onTap: (){ Util().showValorateApp();},
      child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                            offset: Offset(2.0, 10.0)),
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: card,
      )),
    );    
  }


}