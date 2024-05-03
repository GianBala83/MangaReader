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

  def recebe_conexao(socket) do
    case :gen_tcp.accept(socket) do
      {:ok, client} ->
        case :gen_tcp.recv(client, 0) do
          {:ok, pacote} ->
            resposta = Http.gera_resposta(pacote)
            :gen_tcp.send(client, resposta)
            :gen_tcp.close(client)
            recebe_conexao(socket)
          {:error, :closed} ->
            IO.puts "Conexão fechada pelo cliente"
            recebe_conexao(socket)
          _ ->
            IO.puts "Erro desconhecido"
            recebe_conexao(socket)
        end
      _ ->
        IO.puts "Erro ao aceitar a conexão"
        recebe_conexao(socket)
    end
  end

end
