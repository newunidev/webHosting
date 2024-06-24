



import '../const/const_data.dart';
import '../const/login_user_routes.dart';

class FactorySelector{

  List<String> _branches = ['Bakamuna Factory', 'Hettipola Factory', 'Mathara Factory','Piliyandala Factory','Welioya Factory'];
  List<String> setFactoryOnUser(){
    List<String> branchesNew =[''];
    if(UserDetailRouting.factory == 'Bakamuna Factory'){
      branchesNew =['Bakamuna Factory'];
    }else if(UserDetailRouting.factory == 'Hettipola Factory'){
      branchesNew =['Hettipola Factory'];
    }else if(UserDetailRouting.factory == 'Mathara Factory'){
      branchesNew =['Mathara Factory'];
    }else if(UserDetailRouting.factory == 'Piliyandala Factory'){
      branchesNew =['Piliyandala Factory'];
    }else if(UserDetailRouting.factory == 'Welioya Factory'){
      branchesNew =['Welioya Factory'];
    }else if(UserDetailRouting.factory == 'Admin'){
      branchesNew =['Bakamuna Factory', 'Hettipola Factory', 'Mathara Factory','Piliyandala Factory','Welioya Factory'];
    }
    return branchesNew!;
  }

  String setFactoryOnUserString(){
    String branchesNew ="";
    if(UserDetailRouting.factory == 'Bakamuna Factory'){
      branchesNew ='Bakamuna Factory';


    }else if(UserDetailRouting.factory == 'Hettipola Factory'){
      branchesNew ='Hettipola Factory';


    }else if(UserDetailRouting.factory == 'Mathara Factory'){
      branchesNew ='Mathara Factory';
    }else if(UserDetailRouting.factory == 'Piliyandala Factory'){
      branchesNew ='Piliyandala Factory';
    }else if(UserDetailRouting.factory == 'Welioya Factory'){
      branchesNew ='Welioya Factory';
    }else if(UserDetailRouting.factory == 'Admin'){
      branchesNew ='Bakamuna Factory';
    }
    return branchesNew!;
  }
}