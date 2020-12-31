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

  Future getBorrowerLoan({payload}) async {
    String newUrl = "$kBorrowersLoan/$payload";
    print(newUrl);
    return await http.get(url: newUrl);
  }

  Future getBorrowerBalance({payload}) async {
    return await http.post(url: kBorrowerBalance,payload: payload);
  }

  Future getTotalBorrower({payload}) async {
    String newUrl = "$kBorrowerTotal/$payload";
    return await http.get(url: newUrl);
  }

}