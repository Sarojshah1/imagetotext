import 'package:flutter/material.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final String selectedLanguage;
  final Function(String?) onLanguageChange;

  const LanguageSelectorWidget({
    required this.selectedLanguage,
    required this.onLanguageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: DropdownButton<String>(
        value: selectedLanguage,
        onChanged: onLanguageChange,
        items: ['English', 'Nepali'].map((String language) {
          return DropdownMenuItem<String>(
            value: language,
            child: Text(language),
          );
        }).toList(),
      ),
    );
  }
}
