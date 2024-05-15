/*A função deste arquivo é iniciar uma database, juntamente
de uma tabela no container db.
Nota: Esse arquivo só precisar estar presente no raspberry pi,
caso o mesmo abrigue um micro-processador 64 bit*/


/*Cria uma database caso a mesma ainda não exista*/
CREATE DATABASE IF NOT EXISTS Forms;
USE Forms;

/*Cria uma tabela com suas variaveis*/
CREATE TABLE IF NOT EXISTS Requests(
    Request_id int primary key auto_increment,
    Request_email varchar(30),
    Request_topic varchar(15),
    Request_content varchar(120)
);