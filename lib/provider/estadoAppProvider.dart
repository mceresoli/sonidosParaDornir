

import 'package:flutter/material.dart';

class EstadoAppProvider with ChangeNotifier{
    

  double totalSize = 0;



  void setInicio()  {
    notifyListeners();    
  }


// -----------------------------------------------------
// TotalSize
// -----------------------------------------------------


  void setTotalSize(double t) {
    totalSize = t;
  }

  double getTotalSize(){
    return totalSize;
  }
  
  void restarSize(double delta){
    totalSize -= delta;
  }
 

}