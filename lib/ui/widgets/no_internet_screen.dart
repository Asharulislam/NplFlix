import 'package:flutter/material.dart';
import 'package:npflix/ui/widgets/button.dart';
import 'package:npflix/ui/widgets/text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class NoInternetScreen extends StatelessWidget {
  final Function onPressed;

  const NoInternetScreen({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          TextGray(text: AppLocalizations.of(context)!.no_internet_connection,),
          const SizedBox(height: 10),
          TextWhite(text:
          AppLocalizations.of(context)!.please_check_your_connection_and_try_again,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ButtonWidget(onPressed:  () => onPressed(), text: AppLocalizations.of(context)!.retry),
          )

        ],
      ),
    );
  }
}