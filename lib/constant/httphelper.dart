import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpHelper {

  // get data using http
  Future <dynamic> get({@required url,payload}) async {
    http.Response response = await http.get(url);
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      print(response.statusCode);
    }
  }
  Future <dynamic> post({@required url,payload}) async {
      http.Response response = await http.post(url,body: payload);
      if(response.statusCode == 200){
        return jsonDecode(response.body);
      }else{
        print(response.statusCode);
      }
  }
}
