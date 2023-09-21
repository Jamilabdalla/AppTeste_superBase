import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://kyjojbphykgctmtnkxqd.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5am9qYnBoeWtnY3RtdG5reHFkIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTUwNDE2MTcsImV4cCI6MjAxMDYxNzYxN30.LzT9_1RKKHLwrBOOz5PB_ulxs96YPbomv8Js2jFrgWk",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Produtos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 
  List<Map<String, dynamic>> _notes = []; // Variável para armazenar notas localmente
  
  final _notesStream = Supabase.instance.client.from('notes').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _buildNoteList(), // Use uma função separada para criar a lista de notas
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: const Text('Adicione a nota'),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  TextFormField(onFieldSubmitted: (value) async {
                    await Supabase.instance.client
                        .from('notes')
                        .insert({'body': value});
                  })
                ],
              );
            },
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildNoteList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _notesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _notes = snapshot.data!; // Atualize as notas locais com os dados recebidos
        }

        return ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black), // Cor da borda
                borderRadius:
                    BorderRadius.circular(10.0), // Cantos arredondados
              ),
              margin: const EdgeInsets.all(8.0), // Margem ao redor do container
              child: ListTile(
                title: Text(
                  _notes[index]['body'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                dense: true,
                subtitle: Row(
                  children: [
                    Text(
                      'R\$ ${_notes[index]['price'].toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                      onPressed: () {
                        // Lógica a ser executada quando o botão de adição for pressionado
                        // Pode ser deixado em branco ou substituído pela ação desejada
                      },
                    ),
                    const Text(
                      '0',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.remove,
                        size: 30,
                      ),
                      onPressed: () {
                        // Lógica a ser executada quando o botão de remoção for pressionado
                        // Pode ser deixado em branco ou substituído pela ação desejada
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
