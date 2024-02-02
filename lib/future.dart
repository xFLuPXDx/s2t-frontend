
import 'dart:convert';

import 'package:http/http.dart'  as http;
import 'package:shared_preferences/shared_preferences.dart';

class Group_Backend{
  
  String API_URL = "http://192.168.56.1:8000";
  List<dynamic> ListOfGroups = [];
  
  Future getGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    http.Response response = await http.get(
      Uri.parse("$API_URL/group/fetch"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    List<dynamic> data = json.decode(response.body);
    ListOfGroups = data;
  }
  List<dynamic> group(){
    Future.wait([
      getGroups(),
    ]);
    return ListOfGroups;
  }
}