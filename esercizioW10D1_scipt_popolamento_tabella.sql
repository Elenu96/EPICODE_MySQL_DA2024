CREATE DATABASE store_videogiochi2; #creazione database

CREATE TABLE store_videogiochi2.store (  #creazione tabella con inserimento colonne
codice_store INT
, indirizzo_fisico VARCHAR(45)
, numero_telefono VARCHAR(45)
);

INSERT INTO store VALUES #popolamento tabella
(1,'Via Roma 123, Milano','+39021234567')
, (2,'Corso Italia 465, Roma','+3906754321')
, (3,'Piazza San Marco 789, Venezia','+390419876543');

SELECT * FROM store_videogiochi2.store; #visualizzazione/selezione della tabella store completa

CREATE TABLE store_videogiochi2.impiegato (
    codice_fiscale VARCHAR(16),
    nome VARCHAR(45),
    titolo_di_studio VARCHAR(45),
    recapito VARCHAR(45),
    CONSTRAINT PK_impiegato PRIMARY KEY (codice_fiscale)
);

INSERT INTO store_videogiochi2.impiegato VALUES
('ABC12345XYZ67890', 'Mario Rossi', 'Laureato in economia', 'mario.rossi@gmail.com');

CREATE TABLE store_videogiochi2.servizio_impiegato (
    codice_fiscale VARCHAR(16),
    codice_store INT,
    data_inizio DATE,
    data_fine DATE,
    carica VARCHAR (45),
    CONSTRAINT PK1_servizio_impiegato PRIMARY KEY (codice_fiscale),
    CONSTRAINT PK2_servizio_impiegato PRIMARY KEY (codice_store),
    CONSTRAINT FK_si_impiegato FOREIGN KEY (codice_fiscale) REFERENCES impiegato (codice_fiscale)
);

INSERT INTO store_videogiochi2.servizio_impiegato VALUES
('ABC12345XYZ67890', 1 , '2023-01-01', '2023-12-31', 'cassiere');