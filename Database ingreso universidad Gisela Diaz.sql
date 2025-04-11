CREATE DATABASE Ingreso;
USE Ingreso;
CREATE TABLE alumnos (
		id_alumno INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
        nombre VARCHAR (30) NOT NULL,
        apellido VARCHAR (40) NOT NULL,
        email VARCHAR (100) UNIQUE DEFAULT NULL,
        dni INT UNIQUE NOT NULL,
        edad INT,
        telefono VARCHAR (20) UNIQUE DEFAULT NULL,
        nacionalidad VARCHAR (30) DEFAULT "argentino", 
        provincia VARCHAR (30),
        departamento VARCHAR (30)
);       
INSERT INTO alumnos(nombre, apellido, email, dni, edad, telefono, nacionalidad, provincia, departamento)
VALUES 
("Marcela", "Perez", "marce@mail.com", 45025368, 18, "3815556616", 'argentino', "Tucumán", "Capital"),
("Marcelo", "Acosta", "marcelo@mail.com", 40666677, 20, "3883045876", 'argentino', "Jujuy", NULL),
("Enzo", "Godoy", "enzo@mail.com", 46996677, 17, "3815048965", 'argentino', "Tucumán", "Tafí Viejo"),
("Emilia", "Gutierrez", "emig@gmail.com", 43996677, 25, "3875048565", 'argentino', "Salta",NULL),
("Catalina", "Diaz", "catidiaz@gmail.com", 46225987, 17, "3815087965", 'argentino', "Tucumán", "Lules"),
("Julian", "Alvarez", "julian@gmail.com", 93041784, 28, "3815493254", 'peruano', NULL, NULL),
("Cristian", "Diaz", "cris@gmail.com", 43222677, 26, "3814596324", 'argentino', "Tucumán", "Famaillá" ),
("Luciana", "Leiva", "luli126@gmail.com", 45321654, 18, "3882459874", 'argentino', "Jujuy",NULL),
("Solana", "Nara", "solnara@mail.com", 94503215, 21, "381454545", 'venezolano', NULL, NULL),
("Bruno", "Baron", "bruno@gmail.com", 93658731, 27, "0112564890", 'peruano', NULL, NULL),
("Thiago", "Suarez", "tsuarez@mail.com", 44569823, 19, "3813201455", 'argentino', "Tucumán", "Chicligasta"),
("Carlos", "Méndez", "carlosm@hotmail.com", 36567803, 32, "3811261455", 'argentino', "Tucumán", "Monteros"),
("Camila", "Lopez", "cami15@gmail.com", 45325854, 17, "3872459874", 'argentino', "Salta",NULL),
("Tomás", "González", "tomig@gmail.com", 44225677, 19, "3814896324", 'argentino', "Tucumán", "Lules"),
("Nicolás", "Benitez", "nico2001@gmail.com", 41249077, 22, "3815563324", 'argentino', "Tucumán", "Capital");

    
CREATE TABLE alumnos_secundaria (
		id_alumno INT,
        tipo1 VARCHAR(2) NOT NULL,
        tipo2 VARCHAR (2) NOT NULL,
		turno VARCHAR (1) NOT NULL,
		PRIMARY KEY (id_alumno),
		FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno)
);

INSERT INTO alumnos_secundaria(id_alumno, tipo1, tipo2, turno) VALUES 
	(1, "PU", "NT", "M"),
	(2, "PU", "TE","M"),
	(3, "PU", "NT", "M"),
    (4, "PR", "TE", "T"),
    (5, "PU", "NT", "T"),
	(6, "PU", "TE", "T"),
	(7, "PR", "NT", "M"),
    (8, "PU", "NT", "T"),
    (9, "PR", "TE", "M"),
    (10, "PR", "TE", "T"),
    (11, "PU", "NT", "M"),
    (12, "PR", "TE", "M"),
    (13, "PR", "NT", "Y"),
    (14, "PU", "NT", "M"),
    (15, "PU", "NT", "T");

CREATE TABLE cursos (
	id_curso INT PRIMARY KEY AUTO_INCREMENT,
    nombre_curso VARCHAR(50) NOT NULL
);

INSERT INTO cursos (nombre_curso) VALUES 
	("Intensivo febrero"),
    ("Regular 1er cuat"),
	("Regular 2do cuat"),
    ("Suficiencia");
    
CREATE TABLE inscripciones (
	id_alumno INT,
    id_curso INT,
    modalidad VARCHAR(1), 
    turno VARCHAR(1), 
    inscription_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_alumno, id_curso),
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno),
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
);

CREATE TABLE examen (
	id_examen INT PRIMARY KEY AUTO_INCREMENT,
	nombre_examen VARCHAR(30)
); 

INSERT INTO examen(nombre_examen) VALUES 
("Primer Parcial"),
("Segundo Parcial"),
("Recuperación Primer Parcial"),
("Recuperación Segundo Parcial"),
("Primera Recuperación Integral"),
("Segunda Recuperación Integral"),
("Suficiencia");

CREATE TABLE notas (
	id_alumno INT,
    id_curso INT,
    id_examen INT,
    cuatrimestre INT(1),
    año INT(4),
    nota DECIMAL(10,2),
    PRIMARY KEY (id_alumno, id_curso, id_examen),
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno),
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso),
    FOREIGN KEY (id_examen) REFERENCES examen(id_examen)
    );
    
INSERT INTO inscripciones(id_alumno, id_curso, modalidad, turno) VALUES 
(2, 4, null, null);

INSERT INTO notas (id_alumno, id_curso, id_examen, año, nota) VALUES 
(2, 4, 7, "2025", 5.65);

INSERT INTO inscripciones(id_alumno, id_curso, modalidad, turno) VALUES 
(4, 1, "V", "T"),
(8, 1, "P", "T"),
(9, 1, "P", "M");
    
INSERT INTO notas (id_alumno, id_curso, id_examen, año, nota) VALUES 

(4, 1, 1, "2024", 4.25),
(8, 1, 1, "2024", 2.80),
(9, 1, 1, "2024", 9.25),
(4, 1, 2, "2024", 5.15),
(8, 1, 2, "2024", null),
(9, 1, 2, "2024", 8.45),
(4, 1, 3, "2024", 6.05),
(8, 1, 5, "2024", 3.10),
(8, 1, 6, "2024", 4.30);

INSERT INTO inscripciones(id_alumno, id_curso, modalidad, turno) VALUES 
(1, 2, "P", "M"),
(5, 2, "V", "M"),
(7, 2, "V", "T"),
(8, 2, "P", "N"),
(10, 2, "V", "T"),
(11, 2, "V", "M"),
(12, 2, "P", "M");

INSERT INTO notas (id_alumno, id_curso, id_examen, año, nota) VALUES 

(1, 2, 1, "2024", 3.85),
(5, 2, 1, "2024", 5.25),
(7, 2, 1, "2024", 1.80),
(8, 2, 1, "2024", 4.60),
(10, 2, 1, "2024", 7.25),
(11, 2, 1, "2024", 3.15),
(12, 2, 1, "2024", 5.45),

(1, 2, 2, "2024", 5.90),
(5, 2, 2, "2024", 6.80),
(7, 2, 2, "2024", 1.50),
(8, 2, 2, "2024", 5.50),
(10, 2, 2, "2024", 8.05),
(11, 2, 2, "2024", 2.95),
(12, 2, 2, "2024", 3.15),

(1, 2, 3, "2024", 4.50),
(7, 2, 5, "2024", 1.50),
(8, 2, 3, "2024", 5.05),
(11, 2, 5, "2024", 3.40),
(12, 2, 4, "2024", 5.10),

(1, 2, 6, "2024", 6.20),
(7, 2, 6, "2024", 2.05),
(11, 2, 6, "2024", 3.60);

INSERT INTO inscripciones(id_alumno, id_curso, modalidad, turno) VALUES 
(3, 3, "V", "N"),
(6, 3, "P", "M"),
(7, 3, "P", "M"),
(11, 3, "P", "M"),
(13, 3, "V", "T"),
(14, 3, "V", "M"),
(15, 3, "P", "T");

INSERT INTO notas (id_alumno, id_curso, id_examen, año, nota) VALUES 

(3, 3, 1, "2024", 8.85),
(6, 3, 1, "2024", 6.25),
(7, 3, 1, "2024", 6.40),
(11, 3, 1, "2024", 3.05),
(13, 3, 1, "2024", 2.80),
(14, 3, 1, "2024", 4.45),
(15, 3, 1, "2024", 1.00),

(3, 3, 2, "2024", null),
(6, 3, 2, "2024", 7.80),
(7, 3, 2, "2024", 7.20),
(11, 3, 2, "2024", 2.90),
(13, 3, 2, "2024", 5.15),
(14, 3, 2, "2024", 2.95),
(15, 3, 2, "2024", 1.15),

(3, 3, 4, "2024", 8.25),
(11, 3, 5, "2024", 4.10),
(13, 3, 3, "2024", 6.50),
(14, 3, 5, "2024", 5.05),
(15, 3, 5, "2024", 1.10),

(11, 3, 6, "2024", 5.25),
(15, 3, 6, "2024", 1.60);

 
INSERT INTO inscripciones(id_alumno, id_curso, modalidad, turno) VALUES 
(15, 4, null, null);

INSERT INTO notas (id_alumno, id_curso, id_examen, año, nota) VALUES 

(15, 4, 7, "2025", 2.65);


