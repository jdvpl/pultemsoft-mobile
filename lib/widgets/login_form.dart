import 'dart:ui';

import 'package:internediowidget/utils/responsive.dart';
import 'package:internediowidget/widgets/input_text.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _email = "", _password = "";

  _submit() {
    bool isOk = _formKey.currentState.validate();
    print("formulario $isOk");
  }

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Positioned(
      bottom: 30,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: responsive.isTablet ? 4300 : 360,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputText(
                keyboardType: TextInputType.emailAddress,
                label: "CORREO ELECTRONICO",
                fontSize: responsive.dp(responsive.isTablet ? 1.2 : 1.5),
                onChanged: (text) {
                  _email = text;
                },
                validator: (text) {
                  if (!text.contains("@")) {
                    return "Correo invalido";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: responsive.dp(2),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black26,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InputText(
                        label: "CONTRASEÑA",
                        obsucreText: true,
                        borderEnabled: false,
                        onChanged: (text) {
                          _password = text;
                        },
                        validator: (text) {
                          if (text.trim().length == 0) {
                            return "Correo invalidontraseña invalidad";
                          }
                          return null;
                        },
                        fontSize:
                            responsive.dp(responsive.isTablet ? 1.2 : 1.5),
                      ),
                    ),
                    // ignore: deprecated_member_use
                    FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      onPressed: () {},
                      child: Text(
                        "Olvido Contraseña",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.dp(1.5)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: responsive.dp(5),
              ),
              SizedBox(
                width: double.infinity,
                // ignore: deprecated_member_use
                child: FlatButton(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  color: Colors.black,
                  onPressed: this._submit,
                  child: Text(
                    "Iniciar Sesion",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.dp(2),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: responsive.dp(2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "¿No tienes cuenta?",
                    style: TextStyle(fontSize: responsive.dp(1.5)),
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "register");
                    },
                    child: Text(
                      "Registrarme",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: responsive.dp(1.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: responsive.dp(14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
