import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'tarefa.dart';
import 'usuario.dart';

// ponto de entrada da aplicação
void main() {
  runApp(const MyApp());
}

// Aplicação principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final logger = Logger(printer: SimplePrinter(printTime: true, colors: true));
  final Set<Usuario> usuarios = {};
  Usuario? _selectedUser;

  final List<Tarefa> tarefasExcluidas = [];
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeUsers();
  }

  void _initializeUsers() {
    Tarefa task1 = Tarefa('Varrer quintal', 'Varrer quintal às 22:40', 'pendente', false, priority: '');
    Usuario user1 = Usuario('Marianny', [task1]);

    Tarefa task2 = Tarefa('Lavar quintal', 'Lavar quintal às 8:30', 'pendente', false, priority: '');
    Usuario user2 = Usuario('Tyler', [task2]);

    Tarefa task3 = Tarefa('Secar quintal', 'Secar quintal quando o Tyler terminar de lavar', 'pendente', false, priority: '');
    Usuario user3 = Usuario('Ana', [task3]);

    usuarios.add(user1);
    usuarios.add(user2);
    usuarios.add(user3);
  }

  void _onUserSelected(Usuario? selectedUser) {
    setState(() {
      _selectedUser = selectedUser;
    });
  }

  void _addTask(String titulo, String descricao) {
    setState(() {
      if (_selectedUser != null) {
        if (!_selectedUser!.tarefas!.any((t) => t.titulo == titulo)) {
            _selectedUser!.tarefas!.add(Tarefa(titulo, descricao, 'pendente', false, priority: ''));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarefa já existe.')),
          );
        }
      }
    });
  }

  void _deleteTask(int index) {
    setState(() {
      if (_selectedUser != null) {
        var tarefaExcluida = _selectedUser!.tarefas!.removeAt(index);
        tarefasExcluidas.add(tarefaExcluida);
      }
    });
  }

  void _restaurarTarefa(Tarefa tarefaRestaurada) {
    setState(() {
      if (_selectedUser != null) {
          _selectedUser!.tarefas!.add(tarefaRestaurada);
          tarefasExcluidas.remove(tarefaRestaurada);
      }
    });

    // Volta para a tela inicial após restaurar a tarefa
    Navigator.of(context).pop();
  }

  void _deleteUser(Usuario usuario) {
    setState(() {
      usuarios.remove(usuario);
      if (_selectedUser == usuario) {
        _selectedUser = null;
      }
    });
  }

  void _showLixeira() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Lixeira(
          tarefasExcluidas: tarefasExcluidas,
          restaurarTarefa: _restaurarTarefa,
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Nova Tarefa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: _usuarioController,
                decoration: const InputDecoration(labelText: 'Nome do Usuário'),
              ),
            ],
          ),
          actions: [
            TextButton(              
              child: const Text('Adicionar'),
              onPressed: () {
                String titulo = _tituloController.text;
                String descricao = _descricaoController.text;
                String usuarioNome = _usuarioController.text;

                if (usuarioNome.isNotEmpty) {
                  if (usuarios.any((user) => user.nome == usuarioNome)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Usuário $usuarioNome já existe.')),
                    );
                  } else {
                    Usuario novoUsuario = Usuario(usuarioNome, []);
                    usuarios.add(novoUsuario);
                    _selectedUser = novoUsuario;
                  }
                }

                _addTask(titulo, descricao);
                _tituloController.clear();
                _descricaoController.clear();
                _usuarioController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } 
// Método que exibe um diálogo com a lista de usuários e permite exclusão
void _showUserListDialog() {
  // Mostra um diálogo pop-up
  showDialog(
    context: context,  // Contexto da tela onde o diálogo vai aparecer
    builder: (BuildContext context) { 
       // Retorna o conteúdo do diálogo
      return AlertDialog(
        title: const Text(
          'Lista de Usuários', // Título do diálogo
          style: TextStyle(color: Colors.pink), // Cor do título
        ),
        content: SizedBox(
          width: double.maxFinite, // Define a largura máxima
          child: ListView.builder(
            shrinkWrap: true,  // Permite que o ListView use apenas o espaço necessário
            itemCount: usuarios.length, // Número de usuários na lista
            itemBuilder: (context, index) {
              // Obtém cada usuário da lista
              Usuario usuario = usuarios.elementAt(index);
               // Exibe cada usuário em uma linha com um botão para excluir
              return ListTile(
                title: Text(
                  usuario.nome,  // Nome do usuário
                  style: const TextStyle(color: Colors.black), // cor do texto
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.pink), // Ícone de lixeira em rosa
                  onPressed: () {
                    Navigator.of(context).pop(); // Fechar o diálogo
                    _deleteUser(usuario); // Excluir o usuário selecionado
                  },
                ),
              );
            },
          ),
        ),
        actions: [
           // Botão "Fechar" que fecha o diálogo
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Fechar', // Texto do botão
              style: TextStyle(color: Colors.pink), // Botão "Fechar" em rosa
            ),
          ),
        ],
      );
    },
  );
}
// Método build, que é a interface principal da tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Tarefas', // Título da aplicação
          style: TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold, // Negrito
            fontSize: 24, // Tamanho da fonte
          ),
        ),
        centerTitle: true, // Centraliza o título
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Fundo branco
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),  // Margem horizontal
            child: SizedBox(
              width: 1800, // Largura do dropdown
              child: DropdownButton<Usuario>(
                hint: const Text(
                  'Escolha um usuário', // Texto de instrução do dropdown
                  style: TextStyle(fontSize: 20),
                ),
                value: _selectedUser, // Valor selecionado
                onChanged: _onUserSelected, // Ação ao selecionar um usuário
                items: usuarios.map((usuario) {
                   // Mapeia a lista de usuários para exibir no dropdown
                  return DropdownMenuItem<Usuario>(
                    value: usuario,
                    child: Text(
                      usuario.nome, // Nome do usuário
                      style: const TextStyle(fontSize: 15),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 50), // Espaçamento vertical
          if (_selectedUser != null) ...[
              // Exibe tarefas se um usuário for selecionado
            Expanded(
              child: ListView.builder(
                itemCount: _selectedUser!.tarefas?.length ?? 0,  // Quantidade de tarefas
                itemBuilder: (context, index) {
                  var tarefa = _selectedUser!.tarefas![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 15), // Margens
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaçamento entre os elementos
                      children: <Widget>[
                        Checkbox(
                          value: tarefa.situacaoStatus,  // Status da tarefa (concluída ou não)
                          onChanged: (bool? newValue) {
                            setState(() {
                              tarefa.situacaoStatus = newValue!; // Atualiza o status
                              tarefa.status = newValue ? 'Concluída' : 'Pendente'; // Altera o status
                            });
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Alinhamento à esquerda
                            children: [
                              const Text(
                                'Tarefa',  // Texto "Tarefa"
                                style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                tarefa.titulo, // Título da tarefa
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20), // Espaçamento horizontal
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Descrição',// Texto "Descrição"
                                style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                tarefa.descricao,  // Descrição da tarefa
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                         Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Status', // Texto "Status"
                                style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                tarefa.status, // Status atual da tarefa
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20), // Espaçamento horizontal
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.pink), // Ícone de lixeira
                          onPressed: () {
                            _deleteTask(index); // excluir a tarrefa ao clicar
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10), // Espaçamento vertical
          ],
        ],
      ),
      // Botões de ação flutuantes
      floatingActionButton: Wrap(
        direction: Axis.horizontal,  // Organiza os botões horizontalmente
        spacing: 10, // Espaçamento entre os botões
        children: [
          FloatingActionButton(
            backgroundColor: Colors.pink, // Cor do botão
            onPressed: _showLixeira, // Função para exibir a lixeira
            child: const Icon(
              Icons.delete, // Ícone de lixeira
              color: Colors.white, // Cor do ícone
            ),
          ),
          FloatingActionButton(
            backgroundColor: Colors.pink, 
            onPressed: _showUserListDialog,// Função para exibir o diálogo de usuários
            child: const Icon(
              Icons.people, // Ícone de pessoas
              color: Colors.white,
            ),
          ),
          FloatingActionButton(
            backgroundColor: Colors.pink,
            onPressed: _showAddTaskDialog, // Função para adicionar uma nova tarefa
            child: const Icon(
              Icons.add,  // Ícone de adição
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
// Classe Lixeira que exibe as tarefas excluídas com possibilidade de restauração
class Lixeira extends StatelessWidget {
  final List<Tarefa> tarefasExcluidas; // Lista de tarefas excluídas
  final Function(Tarefa) restaurarTarefa; // Função para restaurar uma tarefa

  const Lixeira({
    super.key,
    required this.tarefasExcluidas, // Recebe a lista de tarefas excluídas
    required this.restaurarTarefa, // Recebe a função para restaurar uma tarefa
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lixeira',  // Título da página
          style: TextStyle(
            color: Colors.pink,
            fontWeight: FontWeight.bold,  // Negrito
            fontSize: 24, // Tamanho da fonte
          ),
        ),
        centerTitle: true, // Centraliza o título
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Fundo branco
      ),
      body: tarefasExcluidas.isEmpty
          ? const Center(child: Text('Nenhuma tarefa excluída')) // Exibe mensagem se não houver tarefas excluídas
          : ListView.builder(
              itemCount: tarefasExcluidas.length, // Número de tarefas excluídas
              itemBuilder: (context, index) {
                var tarefaExcluida = tarefasExcluidas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15), // Margens
                  child: ListTile(
                    title: Text(tarefaExcluida.titulo), // Título da tarefa excluída
                    subtitle: Text(tarefaExcluida.descricao), // Descrição da tarefa excluída
                    trailing: IconButton(
                      icon: const Icon(Icons.restore, color: Colors.pink), // Ícone de restauração
                      onPressed: () {
                        restaurarTarefa(tarefaExcluida); // Restaura a tarefa ao clicar
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
