
  import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
  import 'package:dio/dio.dart';
  import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';
import 'package:flutterwear_companion/dtabase/database.dart';
import 'package:flutterwear_companion/dtabase/info.dart';
import 'package:flutterwear_companion/dtabase/info_dao.dart';
import 'package:flutterwear_companion/provider/appdata.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

  class Login extends StatefulWidget {
     const Login({Key? key}) : super(key: key);

    @override
    State<Login> createState() => _LoginState();
  }

  class _LoginState extends State<Login> {
     late AppDatabase database;
     late InfoDao infoDao;
    final _formKey = GlobalKey<FormState>();
     List<WearOsDevice> _deviceList = [];
    final _nameController = TextEditingController();
    String tokendata='';
    String pwd='';
    String username='';

    final _passwordController = TextEditingController();
    FlutterWearOsConnectivity _flutterWearOsConnectivity =FlutterWearOsConnectivity();
     @override
  void initState() {
    super.initState();
    initializedb();
    //  final database = await $FloorAppDatabase.databaseBuilder('database.dart').build();
    // // Initialize the database
  }
initializedb() async {
       final database = await $FloorAppDatabase.databaseBuilder('database.db').build();
       infoDao = database.infoDao;
}
Future<void> printDataFromDB() async {
  try {
    // Retrieve all data from the Info table
    final List<Info> infoList = await infoDao.findinfo();

    // Print each row of data
    for (Info info in infoList) {
      // Convert JSON string to list
      List<String> installations = jsonDecode(info.installations).cast<String>();

      print('idSite: ${info.idsite}, identifier: ${info.identifier}, uuid: ${info.uuid}, username: ${info.username}, installations: $installations');
    }
  } catch (e) {
    print('Error printing data from DB: $e');
  }
}


  Future<void> callinginstallapi(String token,int iduserr,BuildContext context,overalldata) async {
  print("in install api called");
  print(context);
  print("i am install pwd ata");
  // final totdata=context.watch<Overalldata>();
  print(overalldata.passworddata);
    
  print(overalldata.tokendata);
  print("checking uname");
  print(overalldata.usernamedata);

  final String bearerToken = "Bearer $token";
    print(token);
    print("i am okn");
    String apiUrl = 'https://vrmapi.victronenergy.com/v2/users/$iduserr/installations?extended=1';
    print(apiUrl);
  print("Making API call installed...");


  Dio dio = Dio();
  try {

    Response response = await dio.get(
      apiUrl,options: Options(
        headers: {
          'x-authorization': bearerToken,
        },
      ),
    );
print(response);
print("installe api resp");
if (response.statusCode == 200) {
        List<dynamic> records = response.data['records'];
      
        int idsite=0;
        String identifier='';
        String uuid='';
        String name='';
List<String> installdata=[];
        
        for (var record in records) {
          idsite = record['idSite'];
          String idsiteval=idsite.toString();
          print('Name: $idsiteval');
          identifier = record['identifier'];
          print('Name: $identifier');
         uuid= Uuid().v4();
          name=record['name'];
         
         installdata.add(name);
        //  print('uuid');
        //  print(uuid);
        }
        username=overalldata.usernamedata;
        print(username);
        print("i am uname");
        
        pwd=overalldata.passworddata;
        tokendata=overalldata.tokendata;
         
         final jsonStringfrinstall = jsonEncode(installdata);
         final infodata=Info(uuid,idsite,identifier,pwd,username,tokendata,jsonStringfrinstall);
         infoDao.insertinfo(infodata);
         printDataFromDB();
      } else {
        print('Error fetching installations: ${response.statusCode}');
      }

  } catch (e) {
    print('Error fetching data: $e');
  }
}
getdatafromprovider(BuildContext context){
pwd=context.watch<Overalldata>().passworddata;
print("Password data: $pwd");

tokendata=context.watch<Overalldata>().tokendata;
username=context.watch<Overalldata>().usernamedata;
  
}
Future<void> makeloginCall(BuildContext context,overalldata) async {
  print("Making API call...");


  Dio dio = Dio();
  try {
    Response response = await dio.post(
      'https://vrmapi.victronenergy.com/v2/auth/login',
      data:{
"username":_nameController.text,
"password":_passwordController.text
      },
      options: Options(
        headers: {
          'content-type':"application/json"
        },
      ),
    );
     // Check if the login was successful
      if (response.statusCode == 200) {
        // Successful login, do something
        print('Login successful!');
        print(response.data['token']);
        overalldata.updatetoken(response.data['token']);
        overalldata.updateuserdata(response.data['idUser']);
        overalldata.updateuname(_nameController.text);
        overalldata.updatepwd(_passwordController.text);

        callinginstallapi(response.data['token'],response.data['idUser'],context,overalldata);

      } else {
        // Login failed
        print('Login failed');
      }

    

     
    // Print the length of the powerenergy list
    // print('Length of powerenergy list: ${battery.length}');
  } catch (e) {
    print('Error fetching data: $e');
  }
}
    bool isChecked = false;
    @override
    Widget build(BuildContext context) {

     final overalldata = Provider.of<Overalldata>(context,listen: false); 
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Container(
              child: Column(
            children: [
              SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
                  child: Column(
                    children: [
                      Container(

                        padding: EdgeInsets.only(top: 10),
                        child: Align(
                            alignment: Alignment.center,
                            child: Center(
                              child: Image.asset(
                                                  "assets/logo.jpg",
                                                  width: 200,
                                                  height: 80,
                                                ),
                            ))
                        ),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Form(
                            key: _formKey,
                            child: Column(children: [
                              Container(
                                width: 400,
                                child: Text("Email"),
                              ),
                              Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Add border radius
                                  border: Border.all(
                                    color: Colors.grey, // Border color
                                    width: 2.0, // Border width
                                  ),
                                ),
                                margin: EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  controller: _nameController,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                      hintText: "Name",
                                      contentPadding: EdgeInsets.only(left: 20),
                                      border: InputBorder.none // Add a border
                                      ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please fill this field';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: 400,
                                child: Text("Password"),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 13),
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Add border radius
                                  border: Border.all(
                                    color: Colors.grey, // Border color
                                    width: 2.0, // Border width
                                  ),
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                      hintText: 'Password',
                                      contentPadding: EdgeInsets.only(left: 20),
                                      border: InputBorder.none // Add a border
                                      ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please fill this field';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey, // Border color
                                      width: 2.0, // Border width
                                    ),
                                    borderRadius: BorderRadius.circular(20.0)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: InkWell(
                                  onTap: () {
                                    makeloginCall(context,overalldata);
                                  },
                                  child: Center(child: Text("Login"))),
                              ),
                              
                              
                            ])),
                      ),
                    ],
                  )),
            ],
          )),
        ),
      );
    }
  }
