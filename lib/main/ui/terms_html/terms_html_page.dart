import 'package:cam_id/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class TermsHtmlPage extends StatelessWidget {
  final String html;

  const TermsHtmlPage({super.key, required this.html});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.terms_and_conditions,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Html(
            data: html,
          ),
        ),
      ),
    );
  }
}
