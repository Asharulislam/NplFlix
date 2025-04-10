import 'package:flutter/material.dart';
import 'package:npflix/routes/index.dart';

class JoinRoom extends StatelessWidget {
  final Map map;
  const JoinRoom({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100,),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      welcomeScreen, (Route<dynamic> route) => false);
                },
                child: Text("GOO BAK")),
            TextButton(
                onPressed: () {},
                child: Text("JOIN ROOM +\n ${map["roomId"]}")),
          ],
        ),
      ),
    );
  }
}
