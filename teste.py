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
        db.rollback() # Desfaz a operação em caso de erro
        return None

def iniciar_conversa(cursor, db, id_usuario):
    """Inicia uma nova conversa para um usuário e retorna o ID da conversa."""
    try:
        sql = "INSERT INTO conversas (id_usuario) VALUES (%s)"
        valores = (id_usuario,)
        cursor.execute(sql, valores)
        db.commit()
        id_nova_conversa = cursor.lastrowid
        print(f"-> Conversa iniciada para o usuário ID {id_usuario}! ID da conversa: {id_nova_conversa}")
        return id_nova_conversa
    except Error as e:
        print(f"ERRO ao iniciar conversa: {e}")
        db.rollback()
        return None

def enviar_mensagem(cursor, db, id_conversa, tipo, texto):
    try:
        sql = "INSERT INTO mensagens (id_conversa, tipo, texto) VALUES (%s, %s, %s)"
        valores = (id_conversa, tipo, texto)
        cursor.execute(sql, valores)
        db.commit()
        print(f"   - Mensagem do '{tipo}' salva: '{texto}'")
    except Error as e:
        print(f"ERRO ao enviar mensagem: {e}")
        db.rollback()

def buscar_historico_conversa(cursor, id_conversa):
    try:
        sql = "SELECT tipo, texto, timestamp FROM mensagens WHERE id_conversa = %s ORDER BY timestamp ASC"
        valores = (id_conversa,)
        cursor.execute(sql, valores)
        historico = cursor.fetchall()
        return historico
    except Error as e:
        print(f"ERRO ao buscar histórico: {e}")
        return []

if __name__ == "__main__":
    mydb = None
    mycursor = None
    try:
        mydb = mysql.connector.connect(**db_config)
        mycursor = mydb.cursor()
        print("✅ Conexão com o banco de dados 'db_promoplay' bem-sucedida!\n")

        print("--- PASSO 1: Criando um novo usuário ---")
        id_usuario_logan = criar_usuario(mycursor, mydb, 'Logan', 'logan@email.com')

        if id_usuario_logan:
            print("\n--- PASSO 2: Iniciando uma nova conversa ---")
            id_conversa_logan = iniciar_conversa(mycursor, mydb, id_usuario_ana)

            if id_conversa_logan:
                print("\n--- PASSO 3: Trocando mensagens ---")
                enviar_mensagem(mycursor, mydb, id_conversa_logan, 'usuario', 'Olá! Gostaria de ...')
                
                resposta_bot = "Olá, Logan!"
                enviar_mensagem(mycursor, mydb, id_conversa_logan, 'bot', resposta_bot)
                
                enviar_mensagem(mycursor, mydb, id_conversa_logan, 'usuario', 'Sim, por favor.')

                print("\n--- PASSO 4: Exibindo o histórico da conversa ---")
                historico = buscar_historico_conversa(mycursor, id_conversa_logan)
                
                if historico:
                    print("\n--- Histórico da Conversa ---")
                    for tipo, texto, hora in historico:
                        print(f"[{hora.strftime('%H:%M:%S')}] {tipo.capitalize()}: {texto}")
                    print("-----------------------------\n")

    except Error as e:
        print(f"ERRO DE CONEXÃO: Não foi possível conectar ao banco de dados: {e}")

    finally:
        if mydb and mydb.is_connected():
            mycursor.close()
            mydb.close()
            print("❌ Conexão com o MySQL foi encerrada.")

