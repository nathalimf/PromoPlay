import requests
import mysql.connector
from mysql.connector import Error

try:
mydb = mysql.connector.connect(
      host="localhost",  
      user="usuario",
      password="enha",
      database="nome_do_banco_de_dados"
    )
    mycursor = mydb.cursor()
 
 url = ('https://www.cheapshark.com/api/1.0/deals?storeID=1&title=Iratus Lord of the Dead')
 response = requests.get(url)
 response.raise_for_status()

dados_api = response.json()

if dados_api:
      jogo = dado_api[0]

      titulo = jogo.get('title')                 

 
title = (r.text.title)
 
'''mycursor.execute("INSERT INTO filme (Titulo,Preco,NotaDaCritica) VALUES (title,normalPrice,metacriticScore)")'''



'''import requests
import mysql.connector
from mysql.connector import Error

# 1. Usando a biblioteca 'requests' para buscar dados de uma API
try:
    print("Buscando dados da API...")
    # Faz uma requisição GET para a URL da API de teste JSONPlaceholder
    response = requests.get('https://jsonplaceholder.typicode.com/todos/1')

    # Verifica se a requisição foi bem-sucedida (código 200)
    response.raise_for_status() 

    # Converte a resposta para formato JSON (dicionário Python)
    dados_api = response.json()
    print("Dados recebidos com sucesso!")
    print(f"Título da tarefa: {dados_api['title']}")
    print("-" * 30)

except requests.exceptions.RequestException as e:
    print(f"Ocorreu um erro ao acessar a API: {e}")


# 2. Usando 'mysql.connector' para conectar ao banco de dados
conexao = None # Inicializa a variável de conexão
try:
    print("Tentando conectar ao banco de dados MySQL...")
    conexao = mysql.connector.connect(
        host='localhost',          # ou o IP do seu servidor de banco de dados
        database='seu_banco_de_dados', # Nome do seu banco de dados
        user='seu_usuario',        # Seu usuário do MySQL
        password='sua_senha'       # Sua senha do MySQL
    )

    if conexao.is_connected():
        db_info = conexao.get_server_info()
        print(f"Conectado ao servidor MySQL! Versão: {db_info}")
        
        cursor = conexao.cursor()
        cursor.execute("SELECT DATABASE();")
        record = cursor.fetchone()
        print(f"Você está conectado ao banco de dados: {record[0]}")

except Error as e:
    print(f"Ocorreu um erro ao conectar ao MySQL: {e}")

finally:
    # Garante que a conexão seja fechada ao final
    if conexao is not None and conexao.is_connected():
        cursor.close()
        conexao.close()
        print("Conexão com o MySQL foi encerrada.")'''



'''import requests
import mysql.connector
from mysql.connector import Error

# Parte 1: Busca dados de uma API (não precisa alterar nada aqui)
try:
    print("Buscando dados da API...")
    response = requests.get('https://jsonplaceholder.typicode.com/todos/1')
    response.raise_for_status() 
    dados_api = response.json()
    print("Dados recebidos com sucesso!")
    print(f"Título da tarefa: {dados_api['title']}")
    print("-" * 30)
except requests.exceptions.RequestException as e:
    print(f"Ocorreu um erro ao acessar a API: {e}")


# Parte 2: Conecta ao seu banco de dados (ALTERE AS LINHAS ABAIXO)
conexao = None
try:
    print("Tentando conectar ao banco de dados MySQL...")
    conexao = mysql.connector.connect(
        host='localhost',                  # <-- Altere aqui se necessário
        database='meu_banco_teste',        # <-- Altere para o nome do seu banco
        user='root',                       # <-- Altere para o seu usuário
        password='sua_senha_secreta'       # <-- Coloque sua senha aqui
    )

    if conexao.is_connected():
        db_info = conexao.get_server_info()
        print(f"Conectado ao servidor MySQL! Versão: {db_info}")
        
        cursor = conexao.cursor()
        cursor.execute("SELECT DATABASE();")
        record = cursor.fetchone()
        print(f"Você está conectado ao banco de dados: {record[0]}")

except Error as e:
    print(f"Ocorreu um erro ao conectar ao MySQL: {e}")

finally:
    if conexao is not None and conexao.is_connected():
        cursor.close()
        conexao.close()

        print("Conexão com o MySQL foi encerrada.")'''
