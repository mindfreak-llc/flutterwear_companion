import 'package:flutter/material.dart';

class Overalldata with ChangeNotifier {
 String token='';
 String get tokendata => token;
 
 int iduser=0;
 List<String> installdata = [];
 String username='';
 String password='';
 int idsite=0;
 int get iddata => iduser;
 String get passworddata => password;
 String get usernamedata => username;
  void updatetoken(dynamic tokendata){
     var instance = tokendata;
print('Formatted Value for key in provider  $instance');
  token=instance;
    print("I am provider data check me: ${token}");
     notifyListeners();
  }
  void updateuserdata(dynamic idval){
    iduser=idval;
    print("I am provider data check me: ${iduser.toString()}");
     notifyListeners();
  }
  void adddatatoarray(dynamic data){
    installdata.add(data); // Method to add data to the array
    print("I am insert data check me: ${installdata.length}");
    notifyListeners(); 
  }
  void removefromarray(String data){
    installdata.remove(data); // Method to add data to the array
    print("I am remove data check me: ${installdata.length}");
    notifyListeners(); 
  }
  void updateuname(dynamic val){
    username=val;
    print("I am provider data check me: ${username}");

     notifyListeners();
  }
  void updatepwd(dynamic pwd){
    print("I am provider  me: ${pwd}");
    password=pwd;
    print("I am provider pass data check me: ${password}");

     notifyListeners();
  }
void updateidiste(int idvalue){
    idsite=idvalue;
    print("I am provider data check me: ${idsite.toString()}");
     notifyListeners();
  }
  List<String> getinstalarray() {
    return installdata;
  }

  
}

