import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'pages.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  int selectedPage = 0;
  final _pageOption = [HomePage(),LluviaPageScreen(),VentiladorPageScreen(),PropertiesPageScreen()];


  @override
  Widget build(BuildContext context) {

   // final estadoProvider = Provider.of<EstadoAppProvider>(context);

    return Scaffold(
//      appBar: AppBar(title:const Text('Señales de transito')),
      body: _pageOption[selectedPage],
      bottomNavigationBar: ConvexAppBar(
          items: const [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.water_drop , title: 'Lluvia'),
            TabItem(icon: Icons.wind_power, title: 'Ventilador'),
            TabItem(icon: Icons.settings  , title: 'Propiedades'),
          ],
          initialActiveIndex: selectedPage,
          onTap: (int i) {
            setState(() {
              selectedPage=i;
//              if(i==2) {
//                    estadoProvider.setInicio();     
//              }
            });
            },
        ) 
    );
  }
}