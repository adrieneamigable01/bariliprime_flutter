import 'package:flutter/material.dart';
import 'package:barili_prime/constant/httphelper.dart';
import 'package:barili_prime/constant/api-links.dart';

class HttpUsers {

  var http = HttpHelper();

  Future getUsers({payload}) async {
    String newUrl = "$kGetUsers/$payload";
    return await http.get(url: newUrl);
  }

}