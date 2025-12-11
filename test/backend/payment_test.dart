import 'package:flutter/material.dart';

void main(){
  testEsewaUrl();
}
void testEsewaUrl() {
  const url =
      "https://rc-epay.esewa.com.np/epay?bookingId=Ki%2FTt%2FcZK9aecIPxSHQIgA%3D%3D";

  final uri = Uri.parse(url);

  debugPrint("Scheme: ${uri.scheme}");
  debugPrint("Host: ${uri.host}");
  debugPrint("Path: ${uri.path}");
  debugPrint("Query: ${uri.queryParameters}");
}