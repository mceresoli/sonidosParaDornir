
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gdpr_dialog/gdpr_dialog.dart';
import 'package:sonidos_de_lluvia_para_dormir/openAds/appOpenAdsManager.dart';
import 'package:sonidos_de_lluvia_para_dormir/shared_prefs/preferencias_usuario.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  AppOpenAdManager appOpenAdManager = AppOpenAdManager();


  final prefs = PreferenciasUsuario();
  String status = 'none';

  @override
  void initState() {
   super.initState();
   const Text('Show dialog');
   GdprDialog.instance.resetDecision();
   GdprDialog.instance.showDialog(isForTest: false, testDeviceId: '').then((onValue) {
                    setState(() => status = 'dialog result == $onValue');
   });

    appOpenAdManager.loadAd();
    Future.delayed(const Duration(milliseconds: 8000)).then((value) {
             appOpenAdManager.showAdIfAvailable();
             prefs.lenguaje == 'lenguajePage' 
                      ? Navigator.pushReplacementNamed(context, '') 
                      : Navigator.pushReplacementNamed(context, 'menu');
    }
    );
  }






  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Container(
                  decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage('lib/assets/fondoSplash.jpg'),
                                                fit: BoxFit.cover,
                                            ),),
                  width: double.infinity,
                  height: double.infinity,  
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       const Center(
                         child: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image( image: AssetImage('assets/icon/logo.png'),)),
                       ),
                      indicadorDeProgreso(),
                    ],
                  ),
                
          ),
      ),
    );
  }

  Center indicadorDeProgreso() {
    return const Center(
      child: SizedBox(
                        width: 50,
                        height: 50,  
                        child: CircularProgressIndicator()
                    ),
    );
  }
}


