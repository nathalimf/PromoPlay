import bcrypt
import mysql.connector
from mysql.connector import Error

db_config = {
    'host': 'localhost',
    'user': 'root',     
    'password': 'root',    
    'database': 'db_promoplay'
}

def hash_senha(senha_texto_puro):
    senha_bytes = senha_texto_puro.encode('utf-8')
    sal = bcrypt.gensalt()
    senha_hash = bcrypt.hashpw(senha_bytes, sal)
    return senha_hash.decode('utf-8')

def criar_usuario(cursor, db, nome, email, senha_texto_puro):
    if not nome or not email or not senha_texto_puro:
        return False, "Nome, e-mail e senha não podem estar vazios."
    
    try:
        senha_hashed = hash_senha(senha_texto_puro)
    except Exception as e:
        return False, f"Erro ao processar a senha: {e}"

    try:
        sql = "INSERT INTO usuarios (nome, email, senha_hash) VALUES (%s, %s, %s)"
        valores = (nome, email, senha_hashed)
        cursor.execute(sql, valores)
        db.commit()
        id_novo_usuario = cursor.lastrowid
        print(f"-> Usuário '{nome}' criado com sucesso no banco! ID: {id_novo_usuario}")
        return True, "Usuário cadastrado com sucesso!"
    
    except Error as err:
        db.rollback() 
        if err.errno == 1062: 
            print(f"ERRO ao criar usuário '{nome}': E-mail já cadastrado.")
            return False, "O e-mail informado já está em uso."
        else:
            print(f"ERRO ao criar usuário: {err}")
            return False, "Ocorreu um erro inesperado. Tente novamente mais tarde."


if __name__ == "__main__":
    mydb = None
    mycursor = None
    try:
        mydb = mysql.connector.connect(**db_config)
        mycursor = mydb.cursor()
        print("✅ Conexão com o banco de dados 'db_promoplay' bem-sucedida!\n")
        
        print("--- Simulando cadastros de um site ---")
        
        print("\n1. Cadastrando 'Maria'...")
        sucesso, mensagem = criar_usuario(mycursor, mydb, 'Maria', 'maria@email.com', 'senhaForte123')
        print(f"   Resultado para o usuário: {mensagem}")

        print("\n2. Cadastrando 'Joao' com o mesmo e-mail de Maria...")
        sucesso, mensagem = criar_usuario(mycursor, mydb, 'Joao', 'joao@email.com', 'outraSenha456')
        print(f"   Resultado para o usuário: {mensagem}")
        
        print("\n3. Cadastrando 'Logan'...")
        sucesso, mensagem = criar_usuario(mycursor, mydb, 'Logan', 'logan@email.com', 'logan@pass')
        print(f"   Resultado para o usuário: {mensagem}")
        
        print("\n4. Tentando cadastrar com dados faltando...")
        sucesso, mensagem = criar_usuario(mycursor, mydb, 'Ana', '', 'senha123')
        print(f"   Resultado para o usuário: {mensagem}")


    except Error as e:
        print(f"ERRO DE CONEXÃO: Não foi possível conectar ao banco de dados: {e}")

    finally:
        if mydb and mydb.is_connected():
            mycursor.close()
            mydb.close()
            print("\n❌ Conexão com o MySQL foi encerrada.")




