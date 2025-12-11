import 'package:cookmate/core/static.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EsewaPaymentPage extends StatefulWidget {
  final String bookingId;
  final String productName;
  final String customerName;
  final String customerPhone;

  const EsewaPaymentPage({
    required this.bookingId,
    required this.productName,
    required this.customerName,
    required this.customerPhone,
    super.key,
  });

  @override
  State<EsewaPaymentPage> createState() => _EsewaPaymentPageState();
}

class _EsewaPaymentPageState extends State<EsewaPaymentPage> {
  bool isLoading = false;

  Future<void> initiatePayment() async {
    setState(() => isLoading = true);

    try {
      final uri = Uri.https(StaticClass.serverBaseURL, '${StaticClass.serverApiURL}/payment/initiate');
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          'Accept': 'application/json',
          'Authorization': StaticClass.jsonWebToken!,},
        body: jsonEncode({
          "bookingId": widget.bookingId,
          "paymentGateway": "esewa",
          "customerName": widget.customerName,
          "customerPhone": widget.customerPhone,
          "productName": widget.productName
        }),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final url = body["url"];
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

          // After redirecting to eSewa, listen for result
          // using deep linking
      } else {
        if (mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${body["error"]}")),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to start payment")),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pay with eSewa")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
          onPressed: initiatePayment,
          child: const Text("Pay Now"),
        ),
      ),
    );
  }
}
