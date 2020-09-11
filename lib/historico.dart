import 'package:flutter/material.dart';

class Historico extends StatelessWidget {
  var historico;
  Historico(List<Widget> historico) {
    this.historico = historico;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Historico"),
        ),
        body: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start, children: historico),
        ]));
  }
}
