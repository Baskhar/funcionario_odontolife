
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:funcionario_agendamento/pages/page_inicial.dart';

import 'firebase_options.dart';

void main ()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //inicializando a conexão
    options: DefaultFirebaseOptions.currentPlatform,
  ); //inicianizando a conexão
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaginaInicial(),
    );
  }
}
