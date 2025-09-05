import requests
import mysql.connector
from mysql.connector import Error

db_config = {
      'host': 'localhost',
      'user': 'usuario',
      'password': 'senha',
      'database': 'db_promoplay'      
}
 
def criar_usuario(cursor, db, nome, email):
    """
    Insere um novo usuário na tabela 'usuarios'.
    """
    try:
        sql = "INSERT INTO usuarios (nome, email) VALUES (%s, %s)"
        valores = (nome, email)
        cursor.execute(sql, valores)
        db.commit() 
        id_novo_usuario = cursor.lastrowid
        print(f"-> Usuário '{nome}' criado com sucesso! ID: {id_novo_usuario}")
        return id_novo_usuario
    except Error as e:
        print(f"ERRO ao criar usuário: {e}")
        db.rollback() 
        return None

if __name__ == "__main__":
    mydb = None
    mycursor = None
    try:
        mydb = mysql.connector.connect(**db_config)
        mycursor = mydb.cursor()
        print("✅ Conexão com o banco de dados 'db_promoplay' bem-sucedida!\n")
        print("--- Criando um novo usuário ---")
        id_usuario_logan = criar_usuario(mycursor, mydb, 'Logan', 'logan@email.com')
        id_usuario_maria = criar_usuario(mycursor, mydb, 'Maria', 'maria@email.com')

    except Error as e:
        print(f"ERRO DE CONEXÃO: Não foi possível conectar ao banco de dados: {e}")

    finally:
        if mydb and mydb.is_connected():
            mycursor.close()
            mydb.close()
            print("\n❌ Conexão com o MySQL foi encerrada.")
