defmodule Socket do
  def servidor(porta) do

    # Criar Socktes
    {:ok, socket} = :gen_tcp.listen(porta, active: false)

    # Aguarda Conexão do Cliente
    IO.puts("Porta da Conexão: #{porta}\n")
    recebe_conexao(socket)

    #Fecha Socket
    :gen_tcp.close(socket)
  end

  def recebe_conexao(socket)do
    # Aceitar Conexão
    {:ok, client} = :gen_tcp.accept(socket)

    # Receber o Request
    {:ok, pacote} = :gen_tcp.recv(client, 0)

    # Enviar a Respost
    resposta = Http.gera_resposta(pacote)
    :gen_tcp.send(client, resposta)

    # fechar Conexão
    :gen_tcp.close(client)

    # Loop Para Conxeão
    recebe_conexao(socket)
  end

end
