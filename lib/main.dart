import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // VARIAVEIS
  var gorjeta = false;
  var infoText = "Coloque os valores!";
  var quantosPorcento = "0";
  var valor1 = TextEditingController();
  var qtd1 = TextEditingController();
  var valor2 = TextEditingController();
  var qtd2 = TextEditingController();
  //var porcentagem = TextEditingController();
  double porcentagem = 50;
  var resultado1 = "Conta de quem NÃO bebe:\n";
  var resultado2 = "Conta de quem bebe:\n";
  var resultado3 = "Gorjeta do Garçom:\n";
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("APP Racha Conta"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh),
              onPressed: _resetFields)
        ],
      ),
      body: _body(),
    );
  }

  // PROCEDIMENTO PARA LIMPAR OS CAMPOS
  void _resetFields(){
    valor1.text = "";
    valor2.text = "";
    qtd1.text = "";
    qtd2.text = "";
    quantosPorcento = "0";
    porcentagem = 50;
    setState(() {
      infoText = "Digite os Valores:";
      resultado1 = "Conta de quem NÃO bebe:\n";
      resultado2 = "Conta de quem bebe:\n";
      resultado3 = "Gorjeta do Garçom:\n";
      _formKey = GlobalKey<FormState>();
    });
  }

  _body() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _textInfo2("Valor da comida:"),
              _editText("Valor", valor1),
              _textInfo3("Valor das bebidas: "),
              _editText("Valor", valor2),
              _textInfo2("Pessoas que bebem: "),
              _editText("Quantidade", qtd1),
              _textInfo3("Pessoas que NÃO bebem: "),
              _editText("Quantidade", qtd2),
             // _textInfo("Porcentagem do Garçom: "),
              //_editText("Porcentagem", porcentagem),
              _mostrarGorjeta(),
              if (gorjeta)
                _sliderGarcom(),
              calcular(),
              _textInfo2(resultado1),
              _textInfo3(resultado2),
              if (gorjeta)
                _textInfo(resultado3),
            ],
          ),
        ));
  }

  // Widget text
  _editText(String field, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (s) => _validate(s, field),
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 22,
        color: Colors.grey,
      ),
      decoration: InputDecoration(
        labelText: field,
        labelStyle: TextStyle(
          fontSize: 22,
          color: Colors.grey,
        ),
      ),
    );
  }

  _mostrarGorjeta (){
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 10),
      child: Column (
        children: <Widget>[
          Padding (
            padding: EdgeInsets.all(0),
        ),
          _textInfo("Gorjeta do Garçom"),
        Switch(
          value: gorjeta,
          onChanged: (bool valor) {
            setState(() {
              gorjeta = valor;
            });
            if (gorjeta)
              porcentagem = 50;
            else
              porcentagem = 0;
            //print(porcentagem.toString() + " bool");
          }
        ),
        ],
      ),
    );
  }

  _sliderGarcom () {
      return Container(
        margin: EdgeInsets.only(top: 20.0, bottom: 10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(0),
            ),
            Slider(
                value: porcentagem,
                min: 1,
                max: 100,
                label: quantosPorcento,
                divisions: 100,
                onChanged: (double valor) {
                  setState(() {
                    porcentagem = valor.toInt().toDouble();
                    quantosPorcento = porcentagem.toInt().toString() + "%";
                  });
                }
            ),
          ],
        ),
      );
}
  // CALCULAR VALOR DO RACHA CONTA
  calcular(){
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 20),
      width: 25,
      height: 50,
      child: RaisedButton(
        color: Colors.red,
        child:
        Text(
          "Calcular",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        onPressed: () {
          if(_formKey.currentState.validate()){
            setState(() {
              //comida pra cada
              double resp1 = (double.parse(valor1.text) / (double.parse(qtd1.text) + double.parse(qtd2.text)));
              //comida + bebida pra quem bebe
              double resp2 = resp1 + (double.parse(valor2.text)/double.parse(qtd2.text));
              //garcom
              double garcom = porcentagem/100 * (double.parse(valor1.text) + double.parse(valor2.text));

              double total = double.parse(valor1.text) + double.parse(valor2.text) + garcom;

              resp1 += garcom*(resp1/total);
              resp2 += garcom*(resp2/total);

              resultado1 = ("Conta de quem NÃO bebe: " + resp1.toString() + "\n");
              resultado2 = ("Conta de quem bebe: " + resp2.toString() + "\n");

              if (gorjeta)
                resultado3 = ("Gorjeta do Garçom: " + garcom.toString() + "\n");
              else
                resultado3 = "Gorjeta do Garçom: ";
            });
          }
        },
      ),
    );
  }

  // PROCEDIMENTO PARA VALIDAR OS CAMPOS
  String _validate(String text, String field) {
    if (text.isEmpty) {
      infoText = "nenhum valor inserido";
      return "Digite a $field";
    }
    return null;
  }

  // // Widget text
  _textInfo(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black, fontSize: 25.0),
    );
  }

  _textInfo2(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.blue, fontSize: 25.0),
    );
  }

  _textInfo3(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.green, fontSize: 25.0),
    );
  }

}