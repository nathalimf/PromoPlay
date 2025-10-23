const mysql = require('mysql2');

const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'root',
    database: 'db_promoplay'
});


connection.connect(err => {
    if (err) {
        console.error('Erro ao conectar ao banco :(', err);
        return;
    }
    console.log('Conectado ao banco com sucesso!!!!');
});

