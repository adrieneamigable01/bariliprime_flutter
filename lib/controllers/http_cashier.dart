import 'package:flutter/material.dart';
import 'package:barili_prime/constant/httphelper.dart';
import 'package:barili_prime/constant/api-links.dart';

class HttpCashier {

  var http = HttpHelper();

  Future getCashierVault({@required payload}) async {
    return await http.post(url: kGetCashierVault,payload: payload);
  }
  Future miniVaultDeposit({@required payload}) async {
    return await http.post(url: kMiniVaultDeposit,payload: payload);
  }


}