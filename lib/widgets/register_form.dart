import 'dart:ui';

import 'package:internediowidget/utils/responsive.dart';
import 'package:internediowidget/widgets/input_text.dart';
import 'package:flutter/material.dart';
import 'package:internediowidget/widgets/snackbar.dart' as utils;

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _email = "", _password = "";

  _submit() {
    bool isOk = _formKey.currentState.validate();
    if (isOk) {
      utils.Snackbar.showSnackbar(context, "formulario correcto");
    } else {
      utils.Snackbar.showSnackbar(context, "Por favor llenar bien los campos");
    }
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
                keyboardType: TextInputType.text,
                label: "NOMBRE",
                fontSize: responsive.dp(responsive.isTablet ? 1.2 : 1.5),
                onChanged: (text) {
                  _email = text;
                },
                validator: (text) {
                  if (text.length < 5) {
                    return "El nombre debe tener por lo minimo 5 caracteres";
                  }
                  return null;
                },
              ),
              InputText(
                keyboardType: TextInputType.phone,
                label: "TELEFONO",
                fontSize: responsive.dp(responsive.isTablet ? 1.2 : 1.5),
                onChanged: (text) {
                  _email = text;
                },
                validator: (text) {
                  if (text.length < 10) {
                    return "El TRELEFONO DEBE TENER COMO MINIMO 10 NUMEROS";
                  }
                  return null;
                },
              ),
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
                child: InputText(
                  label: "CONTRASEÑA",
                  obsucreText: true,
                  borderEnabled: false,
                  onChanged: (text) {
                    _password = text;
                  },
                  validator: (text) {
                    if (text.trim().length == 0) {
                      return "contraseña invalida";
                    }
                    return null;
                  },
                  fontSize: responsive.dp(responsive.isTablet ? 1.2 : 1.5),
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
                    "REGISTRARME",
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
                    "Ya tienes cuenta?",
                    style: TextStyle(fontSize: responsive.dp(1.5)),
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Iniciar Sesion",
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
                height: responsive.dp(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
