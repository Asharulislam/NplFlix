import 'package:flutter/material.dart';

class JoinRoom extends StatelessWidget {
  final Map map;
  const JoinRoom({super.key, required this.map});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(onPressed: () {}, child: const Text("JOIN ROOM")),
      ),
    );
  }
}
