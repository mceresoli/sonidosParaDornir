import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  CustomScrollView(
        slivers:[
          _CustomAppBar(),
          SliverList(delegate: SliverChildListDelegate([
              _detalle(),
          ]))
      ],
      )   
      
    );
   
  }

  Column _detalle() {
    return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
               const Padding(
                 padding: EdgeInsets.all(20.0),
                 child: Text('Calmantes sonidos que le ayudarán a relajarse, concentrarse durante el trabajo o a conciliar el sueño.', 
                              style: TextStyle( color: Colors.blueGrey, 
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold
                                               )
                            ),
               ),
                _descripcion_seniales()
              ],
        );
  }

  Container _descripcion_seniales() {
    return Container(
        padding: const EdgeInsets.only(left: 25,right: 25,bottom: 20),
          child: Center(  
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  const SizedBox(height: 10,),                 
                  Row(
                    children: [
                      const Image(image: AssetImage('lib/assets/nubes.jpg'),
                      width: 70,
                      height: 70,),
                      const SizedBox(width: 20,),
                      Text('Lluvia', style: TextStyle(color: Colors.blueGrey[600], fontSize: 17,fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10,),                
                  Text('Los sonidos de la lluvia tienen efectos beneficiosos para el cuerpo y calmantes para la mente porque favorecen la relajación y ayudan en diferentes ocasiones: para dormir mejor, para concentrarse en el trabajo, estudio o lectura, para meditar, etc. ', style: TextStyle(color: Colors.blueGrey[500], fontSize: 14,)),
                  const SizedBox(height: 10,),
                  Text(' - Varios sonidos de lluvia para seleccionar', style: TextStyle(color: Colors.blueGrey[500], fontSize: 14,)),
                  Text(' - Truenos mezclables con la lluvia.', style: TextStyle(color: Colors.blueGrey[500], fontSize: 14,)),
                  Text(' - Sonido del paso del tren mezclable con la lluvia', style: TextStyle(color: Colors.blueGrey[500], fontSize: 14,)),
                  Text(' - Simulacion de luz de relámpago configurable', style: TextStyle(color: Colors.blueGrey[500], fontSize: 14,)),
                  Text(' - Seleccion de imagen de fondo.', style: TextStyle(color: Colors.blueGrey[500], fontSize: 14,)),

                  const SizedBox(height: 10,),                
                  Row(
                    children: [
                      const Image(image: AssetImage('lib/assets/venti.jpg'),
                      width: 70,
                      height: 70,),
                      const SizedBox(width: 10,),
                      Text('Ventilador', style: TextStyle(color: Colors.blueGrey[600], fontSize: 17,fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10,),                
                  Text('El ruido relajante del ventilador es un ruido blanco natural que loquea los ruidos extraños y te ayuda a dormir rápidamente y mejor.', style: TextStyle(color: Colors.blueGrey[500], fontSize: 14,)),
                  const SizedBox(height: 10,),    

               ],
            )
      ,),
  );
  }


}
  
class _CustomAppBar extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.blue[400],
      foregroundColor: Colors.white,
      expandedHeight: 120,
      floating: false,
      pinned: true,
      flexibleSpace:  FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Sonidos para dormir',
            style: TextStyle(fontSize: 25,color: Colors.white70)),
          ),
        ),
        background: const FadeInImage(placeholder: AssetImage('lib/assets/banner.jpg'), 
                                image: AssetImage('lib/assets/banner.jpg'),
                                fit: BoxFit.cover,),
        ),
    );
  }
}