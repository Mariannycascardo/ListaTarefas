import 'package:sistema_gerenciamento_tarefa/tarefa.dart';
import 'package:sistema_gerenciamento_tarefa/usuario.dart';

void main() {

  Tarefa task1 = Tarefa('varrer', 'varrer quintal', 'pendente', false, priority: '');
  List<Tarefa> tarefasUser1 = [task1];
Usuario user1 = Usuario('Marianny', tarefasUser1);

  Tarefa task2 = Tarefa('lavar','lavar quintal', 'pendente', false, priority: '');
  List<Tarefa> tarefasUser2 = [task2];
Usuario user2 = Usuario('Tyler', tarefasUser2);

Tarefa task3 = Tarefa('Secar', 'Secar quintal', 'pendente', false, priority: '');
  List<Tarefa> tarefasUser3 = [task3];
Usuario user3 = Usuario('Ana', tarefasUser3);
List<Usuario> usuarios = [user1, user2, user3];


for (var user in usuarios) {
    logger ('Usuário: ${user.nome}');
    if (user.tarefas != null) { 
      for (var tarefa in user.tarefas!) {  
        logger('  Tarefa: ${tarefa.titulo} - ${tarefa.descricao} (${tarefa.status})');
      }
    } else {
      logger('  Nenhuma tarefa atribuída.');
   }
 }
}

void logger(String s) {
  logger(s);
}