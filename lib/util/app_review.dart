import 'package:in_app_review/in_app_review.dart';


class Util {

static final  Util _instance =  Util._init();

factory Util() => _instance;

Util._init();

Future<void> showValorateApp({bool forceStore = false}) async {

    InAppReview.instance.isAvailable().then((value) => {

      if(value && !forceStore){
        InAppReview.instance.requestReview()
        }
        else{
        InAppReview.instance.openStoreListing()
        }
      });
}


}