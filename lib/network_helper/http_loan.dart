import 'package:flutter/material.dart';
import 'package:barili_prime/constant/httphelper.dart';
import 'package:barili_prime/constant/api-links.dart';

class HttpLoan {

  var http = HttpHelper();

  Future getAllLoan({payload}) async {
    // payload =
    String newUrl = "$kLoan/$payload";
    print(newUrl);
    return await http.get(url: newUrl);
  }
}