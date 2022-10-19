

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class FuncionarioPage extends StatefulWidget {
  const FuncionarioPage({Key? key}) : super(key: key);

  @override
  State<FuncionarioPage> createState() => _FuncionarioPageState();
}

class _FuncionarioPageState extends State<FuncionarioPage> {
  final formatdata = DateFormat("dd-MM-yyyy");
  final TextEditingController controllerDATA = TextEditingController();

  var db = FirebaseFirestore.instance.collection("pendentes_odontolife");

  final CollectionReference _clientes =
      FirebaseFirestore.instance.collection('odontolife1');
  Future<QuerySnapshot>? posdocumentList;
  String userNametxt = '';

  initProcura(String txtEntered) {
    posdocumentList = FirebaseFirestore.instance
        .collection('odontolife1')
        .where('data', isEqualTo: txtEntered)
        .get();
    setState(() {
      posdocumentList;
    });
  }

  var pessoas = new Map();
  List list1 = [];
  List<Object?> list2 = [];
  var cont = 0;
  String? data;
  var c;
  String link1 =
      ("https://web.whatsapp.com/send?phone={5598986087623}&text={mensagem}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text("Lista de Agendamentos"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DateTimeField(
              decoration: InputDecoration(labelText: "DATA"),
              controller: controllerDATA,
              format: formatdata,
              onChanged: (textEntered) {
                setState(() {
                  userNametxt = controllerDATA.text;
                });
                initProcura(controllerDATA.text);
              },
              onShowPicker: (context, currentValue) async {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(2022),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
            ),
            SizedBox(
              height: 50,
            ),
            /* StreamBuilder(
                stream: getuser(context),
                builder: (context, AsyncSnapshot<QuerySnapshot> streamsnapshot) {
                  if (streamsnapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: streamsnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamsnapshot.data!.docs[index];
                           // print(documentSnapshot.data());
                            streamsnapshot.data!.docs.forEach((element) {
                              if(element['data']=='2022-09-02'){
                                print(element.data());
                              }
                            });
                            return Card(
                              margin: const EdgeInsets.all(20),
                              child: ListTile(
                                title: Text(documentSnapshot['nome']),
                                subtitle: Text(documentSnapshot['cpf']),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () =>
                                              _delete(documentSnapshot.id),
                                          icon: const Icon(Icons.delete))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),*/
            FutureBuilder<QuerySnapshot>(
               future: posdocumentList,
                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    // final users = snapshot.data!;
                    return Column(
                      children: [
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: streamSnapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    final DocumentSnapshot documentSnapshot =
                                        streamSnapshot.data!.docs[index];
                                    return Card(
                                      margin: const EdgeInsets.all(5),
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        children: [
                                          Expanded(
                                            child: ListTile(
                                              title: Text(
                                                  'Nome: ${documentSnapshot['nome']}'),
                                              subtitle: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                      'CPF ${documentSnapshot['cpf']}'),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                      'Doutor: ${documentSnapshot['doutor']}'),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                      'Whatsapp: ${documentSnapshot['número de whatsapp']}'),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                      'Data: ${documentSnapshot['data']}'),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                      'Horário: ${documentSnapshot['horario']}'),
                                                ],
                                              ),
                                              trailing: SizedBox(
                                                width: 150,
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () async {
                                                          setState(() {
                                                            showDeleteTodosConfirmationDialog(documentSnapshot.id);
                                                          });
                                                          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => FuncionarioPage()));
                                                        },
                                                        icon: const Icon(
                                                            Icons.delete)),
                                                    IconButton(
                                                        onPressed: () async {
                                                          var msg =
                                                              ('Olá ${documentSnapshot['nome']}, estamos passando para confirmar o seu agendamento para o dia ${documentSnapshot['data']}, com o Doutor ${documentSnapshot['doutor']}, no horário${documentSnapshot['horario']} CONFIRMA? [SIM/NÃO]');
                                                          final Uri url = Uri.parse(
                                                              "https://web.whatsapp.com/send?phone=55${documentSnapshot['número de whatsapp']}&text=${msg}");
                                                          await launchUrl(url);
                                                        },
                                                        icon: const Icon(
                                                            Icons.ad_units)),
                                                    IconButton(
                                                        onPressed: () {
                                                          final json = {
                                                            'nome':
                                                                documentSnapshot[
                                                                    'nome'],
                                                            'cpf':
                                                                documentSnapshot[
                                                                    'cpf'],
                                                            'número de whatsapp':
                                                                documentSnapshot[
                                                                    'número de whatsapp'],
                                                            'data':
                                                                documentSnapshot[
                                                                    'data'],
                                                            'horario':
                                                                documentSnapshot[
                                                                    'horario'],
                                                            'doutor':
                                                                documentSnapshot[
                                                                    'doutor'],
                                                          };
                                                          db
                                                              .doc(
                                                                  documentSnapshot[
                                                                      'cpf'])
                                                              .set(json);
                                                        },
                                                        icon: const Icon(Icons
                                                            .access_alarm_rounded)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ],
        ),
      ),
    );
  }

  Future<void> _delete(String clienteId) async {
    //setState(() async{

      await _clientes.doc(clienteId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Agendamento deletado com sucesso')));

    
    // });
  }

  /*
  Future<String> _delete(String clienteId) async {
    //setState(() async{
    final itemremove = await Future.delayed(const Duration(seconds:  1), (){return clienteId; });
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agendamento deletado com sucesso')));
    // });
    return itemremove;

  }
*/
  Widget buildUser(User user) => ListTile(
        leading: CircleAvatar(),
        title: Text(user.nome),
        subtitle: Row(
          children: [
            Text(user.cpf),
            SizedBox(
              width: 20,
            ),
            Text(user.numero),
            SizedBox(
              width: 20,
            ),
            Text(user.data),
            SizedBox(
              width: 20,
            ),
            Text(user.horario),
          ],
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  onPressed: () => //showDeleteTodosConfirmationDialog(user),
           _delete(user.cpf),
                  icon: const Icon(Icons.delete)),
              IconButton(
                  onPressed: () async {
                    var msg =
                        ('Olá ${user.nome}, estamos passando para confirmar o seu agendamento para o dia ${user.data}, no horário${user.horario} COMFIRMA? [SIM/NÃO]');
                    final Uri url = Uri.parse(
                        "https://web.whatsapp.com/send?phone=${user.numero}&text=${msg}");
                    await launchUrl(url);
                  },
                  icon: const Icon(Icons.ad_units))
            ],
          ),
        ),
      );

  Stream<List<User>> readUsers() => FirebaseFirestore.instance
          .collection('odontolife1')
          .where('data', isEqualTo: controllerDATA.text)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => User.fromJson(doc.data())).toList();
      });

/*
  Stream<QuerySnapshot> getuser(BuildContext context) async* {
    var conec = FirebaseFirestore.instance
        .collection('odontolife')
        .where('data', isLessThanOrEqualTo: '2022-09-03')
        .snapshots();
  }*/

/*
  Widget buildUser(User user) => ListTile(
    leading: CircleAvatar(),
    title: Text(user.nome),
    subtitle: Row(
      children: [
        Text(user.cpf),
        SizedBox(width: 20,),
        Text(user.numero),
        SizedBox(width: 20,),
        Text(user.data),
        SizedBox(width: 20,),
        Text(user.horario),
      ],
    ),
);
*/

  /* snapshot.docs.forEach((element) {
  //para cada elemento eu printo
  if (element['data'] == controller.text) {
  return snapshot.docs.map((doc) => User.fromJson(doc.data())).toList();
  }

  });*/

  void getDATA(String controller) async {
    var db =
        FirebaseFirestore.instance; //instanciado a classe de coneção com o db

    QuerySnapshot snapshot1 = (await db
        .collection("odontolife1")
        .get()); //fazendo a consulta e armazenando na variavel snapshot(1 mesagem especifica)

/*
                Future<QuerySnapshot> queryCollection(queryString) async {
                  //retorna o snapshot equivalente aos objetos json onde
                  // o nome é igual ao passado como argumento
                  return await .where('data', isEqualTo: queryString).get();
                }
*/

    snapshot1.docs.forEach((element) {
      //para cada elemento eu printo
      if (element['data'] == controller) {
        return list1.add(element.data());
        //print(element.data());
      }
    });
  }

/*
  getUsurio()async{
    var db = FirebaseFirestore
        .instance; //instanciado a classe de coneção com o db

    QuerySnapshot snapshot1 = (await db
        .collection("odontolife")
        .get()); //fazendo a consulta e armazenando na variavel snapshot(1 mesagem especifica)
    return snapshot1.docs.forEach((element) {
      list2.add(element.data());
    });
  }
*/

  void showDeleteTodosConfirmationDialog(String id) {
    //caixa de dialogo
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Apagar Agendamento?'),
        //titulo
        content: Text('Você tem certeza que deseja apagar este agedamento?'),
        //conteúdo
        actions: [
          TextButton(
            //botãode cancelar
            onPressed: () {
              Navigator.of(context).pop(); //fecha a caixa do dialogo
            },
            style: TextButton.styleFrom(backgroundColor: Color(0xff00d7f3)),
            child: Text('Cancelar',style: TextStyle(
              color: Colors.white,
            ),),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); //fecha a caixa do dialogo
              _delete(id); //chamando a função pra limpar tudo
            }, //botão de limpar tudo
            style: TextButton.styleFrom(backgroundColor:  Colors.red),
            child: Text('apagar',style: TextStyle(
              color: Colors.white,
            ),),
          ),
        ], //conteúdo
      ),
    );
  }
}

class User {
  late String cpf;
  late String nome;
  late String data;
  late String horario;
  late String numero;

  User({
    this.cpf = '',
    required this.nome,
    required this.data,
    required this.horario,
    required this.numero,
  });

  Map<String, dynamic> toJson() => {
        'cpf': cpf,
        'nome': nome,
        'data': data,
        'horario': horario,
        'número de whatsapp': numero,
      };

  static User fromJson(Map<String, dynamic> json) => User(
      cpf: json['cpf'],
      nome: json['nome'],
      data: json['data'],
      horario: json['horario'],
      numero: json['número de whatsapp']);


}

