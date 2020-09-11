import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'historico.dart';
import 'constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //historico
  var historico = new List<Widget>();

  //variável que controla se o teclado está mudando o n1 ou n2
  var focus = 1;

  //inputs
  var arrendondar = false;
  var cn1 = TextEditingController();
  var cn2 = TextEditingController();
  var cop = TextEditingController();

  //função para editar o texto de um TextEditingController
  void changeTextController(TextEditingController tec, String text) {
    tec.value = tec.value.copyWith(
      text: text,
      selection:
          TextSelection(baseOffset: text.length, extentOffset: text.length),
      composing: TextRange.empty,
    );
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  //resposta de pressionar numero
  void pressNumber(String number) {
    if (focus == 1) {
      changeTextController(cn1, cn1.value.text + number);
    } else {
      changeTextController(cn2, cn2.value.text + number);
    }
  }

  //resposta de pressionar operador
  void pressOperation(String op) {
    changeTextController(cop, op);
    if (focus == 1) {
      focus = 2;
    }
  }

  //resposta de pressionar del
  void del() {
    if (focus == 2) {
      if (cn2.value.text == "") {
        focus = 1;
        changeTextController(cop, "");
      } else {
        changeTextController(
            cn2, cn2.value.text.substring(0, cn2.value.text.length - 1));
      }
    } else {
      changeTextController(
          cn1, cn1.value.text.substring(0, cn1.value.text.length - 1));
    }
  }

  //resposta de pressionar result que retona um alert
  Future<void> result() async {
    var result;

    //checa se n1 e n2 é numeros caso contrário retorna um alert avisando o usuário
    if (!isNumeric(cn1.value.text) || !isNumeric(cn2.value.text)) {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erro!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("'" +
                      cn1.value.text +
                      "' ou '" +
                      cn2.value.text +
                      "' não é um número"),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok!'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    //faz a conta
    switch (cop.value.text) {
      case "+":
        result = int.parse(cn1.value.text) + int.parse(cn2.value.text);
        break;
      case "-":
        result = int.parse(cn1.value.text) - int.parse(cn2.value.text);
        break;
      case "*":
        result = int.parse(cn1.value.text) * int.parse(cn2.value.text);
        break;
      case "/":
        //checa divisão por zero primeiro
        if (cn2.value.text == "0") {
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Erro!'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text("Não é possível fazer divisão por 0 ;("),
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok!'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
        result = int.parse(cn1.value.text) / int.parse(cn2.value.text);
        break;
      default:
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erro!'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("'" + cop.value.text + "' não é um operador válido"),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
    }
    if (arrendondar) {
      result = result.round();
    }

    //adicinoa no histórico
    historico.add(Text(
        result.toString() +
            (arrendondar ? String.fromCharCode(8773) : "=") +
            cn1.value.text +
            cop.value.text +
            cn2.value.text,
        style: TextStyle(fontSize: 32.0)));

    //mostra o resultado
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resultado da sua conta!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(result.toString()),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //estilo dos inputs
    var decoracaoInput = InputDecoration(
      border: OutlineInputBorder(),
    );

    //input para o n1
    var input1 = Expanded(
        child: TextFormField(
      controller: cn1,
      decoration: decoracaoInput,
      textAlign: TextAlign.center,
    ));

    //input para o n2
    var input2 = Expanded(
        child: TextFormField(
      controller: cn2,
      decoration: decoracaoInput,
      textAlign: TextAlign.center,
    ));

    //input para a operação
    var inputOp = Expanded(
        child: TextFormField(
      controller: cop,
      decoration: decoracaoInput,
      textAlign: TextAlign.center,
    ));

    //variável para adicionar padding entre as roll ou column
    var padding = Padding(padding: const EdgeInsets.all(8.0));

    //definição do teclado numérico
    var tecladoNumerico = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
                child: Text("1"),
                onPressed: () {
                  this.pressNumber("1");
                }),
            RaisedButton(
                child: Text("2"),
                onPressed: () {
                  this.pressNumber("2");
                }),
            RaisedButton(
                child: Text("3"),
                onPressed: () {
                  this.pressNumber("3");
                }),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
                child: Text("4"),
                onPressed: () {
                  this.pressNumber("4");
                }),
            RaisedButton(
                child: Text("5"),
                onPressed: () {
                  this.pressNumber("5");
                }),
            RaisedButton(
                child: Text("6"),
                onPressed: () {
                  this.pressNumber("6");
                }),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
                child: Text("7"),
                onPressed: () {
                  this.pressNumber("7");
                }),
            RaisedButton(
                child: Text("8"),
                onPressed: () {
                  this.pressNumber("8");
                }),
            RaisedButton(
                child: Text("9"),
                onPressed: () {
                  this.pressNumber("9");
                }),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RaisedButton(
                child: Text("del"),
                onPressed: () {
                  del();
                }),
            RaisedButton(
                child: Text("0"),
                onPressed: () {
                  this.pressNumber("0");
                }),
            RaisedButton(
                child: Text("="),
                onPressed: () {
                  result();
                }),
          ],
        ),
      ],
    ); //teclado numérico

    //definição do teclado de operações
    var tecladoOperacao = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RaisedButton(
            child: Text("+"),
            onPressed: () {
              this.pressOperation("+");
            }),
        RaisedButton(
            child: Text("-"),
            onPressed: () {
              this.pressOperation("-");
            }),
        RaisedButton(
            child: Text("/"),
            onPressed: () {
              this.pressOperation("/");
            }),
        RaisedButton(
            child: Text("*"),
            onPressed: () {
              this.pressOperation("*");
            }),
      ],
    );

    // botão para acessar o histórico
    var btnHistorico = RaisedButton(
        child: Text("Historico"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Historico(historico)),
          );
        });

    // checkbox para verificar se o usuário deseja arredondar
    var selectBoxRound =
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      SizedBox(
          height: 25.0,
          child: Checkbox(
            value: this.arrendondar,
            onChanged: (bool value) {
              setState(() {
                this.arrendondar = value;
              });
            },
          )),
      Text("Arredondar para numero natural")
    ]);

    //construção da pagina
    return Scaffold(
        appBar: AppBar(
          title: Text(APP_NAME),
        ),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              padding,
              input1,
              padding,
              inputOp,
              padding,
              input2,
              padding
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [selectBoxRound],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [tecladoNumerico, tecladoOperacao],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [btnHistorico],
          ),
        ]));
  }
}

//função para verificar se uma string é parseável para inteiro
bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}
