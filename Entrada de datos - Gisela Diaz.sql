INSERT INTO alumnos(nombre, apellido, email, dni, edad, telefono, nacionalidad, provincia)
VALUES 
("Marcela", "Perez", "marce@mail.com", 45025368, 18, "3815556616", 'argentino', "Tucumán"),
("Marcelo", "Acosta", "marcelo@mail.com", 40666677, 20, "3883045876", 'argentino', NULL),
("Enzo", "Godoy", "enzo@mail.com", 46996677, 17, "3815048965", 'argentino', "Tucumán"),
("Emilia", "Gutierrez", "emig@gmail.com", 43996677, 25, "3875048565", 'argentino', "Salta"),
("Catalina", "Diaz", "catidiaz@gmail.com", 46225987, 17, "3815087965", 'argentino', "Tucumán"),
("Julian", "Alvarez", "julian@gmail.com", 93041784, 28, "3815493254", 'peruano', NULL),
("Cristian", "Diaz", "cris@gmail.com", 43222677, 26, "3814596324", 'argentino', "Tucumán" ),
("Luciana", "Leiva", "luli126@gmail.com", 45321654, 18, "3882459874", 'argentino', "Jujuy"),
("Solana", "Nara", "solnara@mail.com", 94503215, 21, "381454545", 'venezolano', NULL),
("Bruno", "Baron", "bruno@gmail.com", 93658731, 27, "0112564890", 'peruano', NULL),
("Thiago", "Suarez", "tsuarez@mail.com", 44569823, 19, "3813201455", 'argentino', "Tucumán"),
("Carlos", "Méndez", "carlosm@hotmail.com", 36567803, 32, "3811261455", 'argentino', "Tucumán"),
("Camila", "Lopez", "cami15@gmail.com", 45325854, 17, "3872459874", 'argentino', "Salta"),
("Tomás", "González", "tomig@gmail.com", 44225677, 19, "3814896324", 'argentino', "Tucumán"),
("Nicolás", "Benitez", "nico2001@gmail.com", 41249077, 22, "3815563324", 'argentino', "Tucumán");

INSERT INTO alumnos_secundaria(id_alumno, tipo1, tipo2) VALUES 
	(1, "PU", "NT"),
	(2, "PU", "TE"),
	(3, "PU", "NT"),
    (4, "PR", "TE"),
    (5, "PU", "NT"),
	(6, "PU", "TE"),
	(7, "PR", "NT"),
    (8, "PU", "NT"),
    (9, "PR", "TE"),
    (10, "PR", "TE"),
    (11, "PU", "NT"),
    (12, "PR", "TE"),
    (13, "PR", "NT"),
    (14, "PU", "NT"),
    (15, "PU", "NT");

INSERT INTO inscripciones(id_alumno, id_curso, modalidad, turno) VALUES 
(2, 4, 'P', 'M');

INSERT INTO notas (id_alumno, id_curso, id_examen, año, nota) VALUES 
(2, 4, 7, "2025", 5.65);

INSERT INTO inscripciones(id_alumno, id_curso, modalidad, turno) VALUES 
(4, 1, "V", "T"),
(8, 1, "P",  "T"),
(9, 1, "P",  "M");
    
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

