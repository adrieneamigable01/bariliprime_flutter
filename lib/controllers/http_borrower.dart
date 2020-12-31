import 'package:flutter/material.dart';
import 'package:barili_prime/constant/httphelper.dart';
import 'package:barili_prime/constant/api-links.dart';

class HttpBorrower {

  var http = HttpHelper();

  Future getBorrowers({payload}) async {
     // payload =
     String newUrl = "$kBorrowers/$payload";
     print(newUrl);
     return await http.get(url: newUrl);
  }
}