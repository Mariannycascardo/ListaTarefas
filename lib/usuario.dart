import 'package:sistema_gerenciamento_tarefa/tarefa.dart';

class Usuario {
   // Propriedades do usuário
  late String nome;
  List<Tarefa>? tarefas;

  // Construtor para inicializar a classe
  Usuario(this.nome,this.tarefas);
}