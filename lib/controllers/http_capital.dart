import 'package:flutter/material.dart';
import 'package:barili_prime/constant/httphelper.dart';
import 'package:barili_prime/constant/api-links.dart';

class HttpCapital {

  var http = HttpHelper();

  Future getAllCapital({payload}) async {
    // payload =
    String newUrl = "$kLoanAddedCapital/$payload";
    print(newUrl);
    return await http.get(url: newUrl);
  }
  Future approveCapital({@required payload}) async {
    return await http.post(url:kApproveAddedCapital,payload: payload);
  }
  Future disapproveCapital({@required payload}) async {
    return await http.post(url: kVoidCapital,payload: payload);
  }
  Future releaseCapital({@required payload}) async {
    return await http.post(url: kReleaseAddedCapital,payload: payload);
  }
  Future getTotalCapital({payload}) async {
    String newUrl = "$kTotalCapital/$payload";
    return await http.get(url: newUrl);
  }

}