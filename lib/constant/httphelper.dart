import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpHelper {

  // get data using http
  Future <dynamic> get({@required url}) async {
    try{
      print(url);
      http.Response response = await http.get(url);
      if(response.statusCode == 200){
        return jsonDecode(response.body);
      }else{
        print(response.statusCode);
      }
    }catch (e) {
      print(e);
    }
  }
  Future <dynamic> post({@required url,payload}) async {
      print(url);
      print(payload);
      try{
        http.Response response = await http.post(url,body: payload);
        if(response.statusCode == 200){
          print("im here");
          print(response.body);
          return jsonDecode(response.body);
        }else{
          print(response.statusCode);
        }
      }catch (e) {
        print(e);
      }
  }
}
