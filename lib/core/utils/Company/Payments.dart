import 'package:dccm/Colors.dart';
import 'package:flutter/material.dart';

class CompanyPayments extends StatefulWidget {
  const CompanyPayments({super.key});

  @override
  State<CompanyPayments> createState() => _CompanyPaymentsState();
}

class _CompanyPaymentsState extends State<CompanyPayments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.getAppBarBackgroundColor(context),
      ),
    );
  }
}
