import 'package:flutter/material.dart';
import 'package:npflix/ui/widgets/button.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  final Function onRetry;

  const ErrorScreen({
    Key? key,
    required this.errorMessage, // Custom error message
    required this.onRetry, // Retry callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 100,
            color: Colors.redAccent, // Error-related color
          ),
          const SizedBox(height: 20),
          TextGray(
            text: AppLocalizations.of(context)!.unexpected_error_occurred,
          ),
          const SizedBox(height: 10),
          TextWhite(
            text: errorMessage, // Display custom error message
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ButtonWidget(
              onPressed: () => onRetry(),
              text: AppLocalizations.of(context)!.retry,
            ),
          ),
        ],
      ),
    );
  }
}
