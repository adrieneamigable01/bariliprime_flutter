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
  Future approveLoan({@required payload}) async {
    return await http.post(url:kApproveLoan,payload: payload);
  }
  Future disapproveLoan({@required payload}) async {
    return await http.post(url: kDisApproveLoan,payload: payload);
  }
  Future releaseLoan({@required payload}) async {
    return await http.post(url: kReleaseLoan,payload: payload);
  }
  Future getTotalLoan({payload}) async {
    String newUrl = "$kLoanTotal/$payload";
    return await http.get(url: newUrl);
  }
}