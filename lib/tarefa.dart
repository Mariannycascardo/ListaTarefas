class Tarefa {
  late String titulo;
  late String descricao;
  late String status;
  late bool situacaoStatus;

   Tarefa(this.titulo,this.descricao,this.status,this.situacaoStatus, {required String priority, DateTime? dueDate});

  void adicionarTarefa() {
  }

  void excluirTarefa() {
  }

  void atualizarSituacaoStatus() {
  }
}