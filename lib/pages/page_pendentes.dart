

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PagePendentes extends StatefulWidget {
  const PagePendentes({Key? key}) : super(key: key);

  @override
  State<PagePendentes> createState() => _PagePendentesState();
}

class _PagePendentesState extends State<PagePendentes> {
  var db = FirebaseFirestore.instance.collection("pendentes_odontolife");
  final CollectionReference _clientes =
      FirebaseFirestore.instance.collection('pendentes_odontolife');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text("Lista de Pendentes"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            StreamBuilder(
                stream: _clientes.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    // final users = snapshot.data!;
                    return ListView.builder(
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
                                  title: Text(documentSnapshot['nome']),
                                  subtitle: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('CPF ${documentSnapshot['cpf']}'),
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
                                      Text('Data: ${documentSnapshot['data']}'),
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
                                            icon: const Icon(Icons.delete)),
                                        IconButton(
                                            onPressed: () async {
                                              var msg =
                                                  ('Olá ${documentSnapshot['nome']}, você não compareceu a consulta no dia ${documentSnapshot['data']} no horário das ${documentSnapshot['horario']}, vamos remarcar? ');
                                              final Uri url = Uri.parse(
                                                  "https://web.whatsapp.com/send?phone=55${documentSnapshot['número de whatsapp']}&text=${msg}");
                                              await launchUrl(url);
                                            },
                                            icon: const Icon(Icons.ad_units)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
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
                  onPressed: () => _delete(user.cpf),
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
      .collection('pendentes')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

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

/*
                Future<QuerySnapshot> queryCollection(queryString) async {
                  //retorna o snapshot equivalente aos objetos json onde
                  // o nome é igual ao passado como argumento
                  return await .where('data', isEqualTo: queryString).get();
                }
*/

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
        title: Text('Apagar Pendência?'),
        //titulo
        content: Text('Você tem certeza que deseja apagar esta pendência? '),
        //conteúdo
        actions: [
          TextButton(
            //botãode cancelar
            onPressed: () {
              Navigator.of(context).pop(); //fecha a caixa do dialogo
            },
            style: TextButton.styleFrom(backgroundColor:  Color(0xff00d7f3)),
            child: Text('Cancelar',style: TextStyle(
              color: Colors.white,
            ),),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); //fecha a caixa do dialogo
              _delete(id); //chamando a função pra limpar tudo
            }, //botão de limpar tudo
            style: TextButton.styleFrom(backgroundColor: Colors.red),
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
