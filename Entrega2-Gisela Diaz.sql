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
        provincia VARCHAR (30)
);

CREATE TABLE alumnos_secundaria (
		id_alumno INT,
        tipo1 VARCHAR(2) NOT NULL,
        tipo2 VARCHAR (2) NOT NULL,
		PRIMARY KEY (id_alumno),
		FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno)
);

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
    
    DELIMITER //
CREATE PROCEDURE sp_insertar_alumno_completo (
    IN p_nombre VARCHAR(30),
    IN p_apellido VARCHAR(40),
    IN p_dni INT,
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_edad INT,
    IN p_nacionalidad VARCHAR(30),
    IN p_provincia VARCHAR(30),
    IN p_tipo1 VARCHAR(2),
    IN p_tipo2 VARCHAR(2),
    IN p_id_curso INT,
    IN p_modalidad VARCHAR(1),
    IN p_turno_cursillo VARCHAR(1)
)
BEGIN
    DECLARE nuevo_id INT;
    INSERT INTO alumnos (nombre, apellido, dni, email, telefono, edad, nacionalidad, provincia)
    VALUES (p_nombre, p_apellido, p_dni, p_email, p_telefono, p_edad, p_nacionalidad, p_provincia);
    
    SET nuevo_id = LAST_INSERT_ID();

    INSERT INTO alumnos_secundaria (id_alumno, tipo1, tipo2)
    VALUES (nuevo_id, p_tipo1, p_tipo2);

    INSERT INTO inscripciones (id_alumno, id_curso, modalidad, turno)
    VALUES (nuevo_id, p_id_curso, p_modalidad, p_turno_cursillo);
END //
DELIMITER ;
    
-- Crear la tabla resumen de estado de curso y promedio

CREATE TABLE estado_curso_alumnos (
    id_alumno INT NOT NULL,
    id_curso INT NOT NULL,
    año INT NOT NULL,
    promedio_notas DECIMAL(5,2),
    estado_curso VARCHAR(15),
    PRIMARY KEY (id_alumno, id_curso, año),
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno),
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
);

-- Función para calcular el promedio de notas de un alumno en un curso y en un año específico
DELIMITER //
CREATE FUNCTION calcular_promedio_notas(
    alumno_id INT,
    curso_id INT,
    año INT
) RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);

    SELECT AVG(nota) INTO promedio
    FROM notas
    WHERE id_alumno = alumno_id
      AND id_curso = curso_id
      AND año = año;

    RETURN IFNULL(promedio, 0);
END //
DELIMITER ;

-- Función para calcular si el alumno aprobó o desaprobó el curso
DELIMITER //
CREATE FUNCTION calcular_estado_curso(
    alumno_id INT,
    curso_id INT,
    año INT
) RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE resultado VARCHAR(15);

    -- Caso especial: curso de suficiencia (id_curso = 4)
    IF curso_id = 4 THEN
        IF EXISTS (
            SELECT 1 FROM notas n
            JOIN examen e ON n.id_examen = e.id_examen
            WHERE n.id_alumno = alumno_id
              AND n.id_curso = curso_id
              AND n.año = año
              AND e.nombre_examen = 'Suficiencia'
              AND n.nota >= 5
        ) THEN
            SET resultado = 'Aprobado';
        ELSE
            SET resultado = 'Desaprobado';
        END IF;

    ELSEIF (
        (SELECT COUNT(*) FROM notas n
         JOIN examen e ON n.id_examen = e.id_examen
         WHERE n.id_alumno = alumno_id AND n.id_curso = curso_id AND n.año = año 
           AND e.nombre_examen IN ('Primer Parcial', 'Segundo Parcial') AND n.nota >= 5) = 2
        OR
        (SELECT COUNT(*) FROM notas n
         JOIN examen e ON n.id_examen = e.id_examen
         WHERE n.id_alumno = alumno_id AND n.id_curso = curso_id AND n.año = año
           AND e.nombre_examen IN ('Recuperación Primer Parcial', 'Recuperación Segundo Parcial', 'Primera Recuperación Integral')
           AND n.nota >= 5) >= 1
        OR
        (SELECT COUNT(*) FROM notas n
         JOIN examen e ON n.id_examen = e.id_examen
         WHERE n.id_alumno = alumno_id AND n.id_curso = curso_id AND n.año = año 
           AND e.nombre_examen = 'Segunda Recuperación Integral'
           AND n.nota >= 5) >= 1
    ) THEN
        SET resultado = 'Aprobado';
    ELSE
        SET resultado = 'Desaprobado';
    END IF;

    RETURN resultado;
END //
DELIMITER ;

-- Trigger para actualizar o insertar automáticamente el estado del curso
DELIMITER //
CREATE TRIGGER trg_actualizar_estado_curso_alumno
AFTER INSERT ON notas
FOR EACH ROW
BEGIN
    DECLARE existe INT;

    SELECT COUNT(*) INTO existe
    FROM estado_curso_alumnos
    WHERE id_alumno = NEW.id_alumno
      AND id_curso = NEW.id_curso
      AND año = NEW.año;
    
    IF existe > 0 THEN
        UPDATE estado_curso_alumnos
        SET 
            promedio_notas = calcular_promedio_notas(NEW.id_alumno, NEW.id_curso, NEW.año),
            estado_curso = calcular_estado_curso(NEW.id_alumno, NEW.id_curso, NEW.año)
        WHERE id_alumno = NEW.id_alumno
          AND id_curso = NEW.id_curso
          AND año = NEW.año;
    ELSE
        INSERT INTO estado_curso_alumnos (
            id_alumno, id_curso, año, promedio_notas, estado_curso
        )
        VALUES (
            NEW.id_alumno,
            NEW.id_curso,
            NEW.año,
            calcular_promedio_notas(NEW.id_alumno, NEW.id_curso, NEW.año),
            calcular_estado_curso(NEW.id_alumno, NEW.id_curso, NEW.año)
        );
    END IF;
END //
DELIMITER ;

-- Stored Procedure para llenar la tabla estado_curso_alumno

DELIMITER //

CREATE PROCEDURE actualizar_estado_curso_alumnos()
BEGIN
DECLARE fin INT DEFAULT FALSE;
DECLARE alumno_id INT;
DECLARE curso_id INT;
DECLARE año INT;

DECLARE cur CURSOR FOR
SELECT DISTINCT id_alumno, id_curso, año FROM notas;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;

OPEN cur;

ciclo: LOOP
FETCH cur INTO alumno_id, curso_id, año;
IF fin THEN
LEAVE ciclo;
END IF;

INSERT INTO estado_curso_alumnos (id_alumno, id_curso, año, promedio_notas,
estado_curso)
VALUES (
alumno_id,
curso_id,
año,

calcular_promedio_notas(alumno_id, curso_id, año),
calcular_estado_curso(alumno_id, curso_id, año)
)
ON DUPLICATE KEY UPDATE
promedio_notas = calcular_promedio_notas(alumno_id, curso_id, año),
estado_curso = calcular_estado_curso(alumno_id, curso_id, año);
END LOOP;

CLOSE cur;
END //

DELIMITER ;

-- Vistas para analizar el impacto de distintos factores en el rendimiento académico de los estudiantes

-- Impacto del tipo de curso (suficiencia, regular, intensivo y cuatrimestre)
CREATE VIEW vista_impacto_tipo_curso AS
SELECT c.nombre_curso, ea.estado_curso, COUNT(*) AS cantidad
FROM estado_curso_alumnos ea
JOIN cursos c ON ea.id_curso = c.id_curso
GROUP BY c.nombre_curso, ea.estado_curso;

-- Impacto del turno (mañana o tarde)
CREATE VIEW vista_impacto_turno AS
SELECT i.turno, ea.estado_curso, COUNT(*) AS cantidad
FROM inscripciones i
JOIN estado_curso_alumnos ea ON ea.id_alumno = i.id_alumno AND ea.id_curso = i.id_curso
GROUP BY i.turno, ea.estado_curso;

-- Impacto de la institución proveniente
CREATE VIEW vista_impacto_institucion AS
SELECT s.tipo1, s.tipo2, ea.estado_curso, COUNT(*) AS cantidad
FROM alumnos_secundaria s
JOIN estado_curso_alumnos ea ON s.id_alumno = ea.id_alumno
GROUP BY s.tipo1, s.tipo2, ea.estado_curso;

-- Impacto del tipo de cursillo (presencial o virtual)
CREATE VIEW vista_impacto_modalidad AS
SELECT i.modalidad, ea.estado_curso, COUNT(*) AS cantidad
FROM inscripciones i
JOIN estado_curso_alumnos ea ON ea.id_alumno = i.id_alumno AND ea.id_curso = i.id_curso
GROUP BY i.modalidad, ea.estado_curso;

-- Impacto de los exámenes parciales
CREATE VIEW vista_notas_parciales AS
SELECT e.nombre_examen, n.nota, ea.estado_curso
FROM notas n
JOIN examen e ON n.id_examen = e.id_examen
JOIN estado_curso_alumnos ea ON ea.id_alumno = n.id_alumno AND ea.id_curso = n.id_curso
WHERE e.nombre_examen IN ('Primer Parcial', 'Segundo Parcial');

-- Impacto de la procedencia del aspirante
CREATE VIEW vista_impacto_procedencia AS
SELECT a.provincia, ea.estado_curso, COUNT(*) AS cantidad
FROM alumnos a
JOIN estado_curso_alumnos ea ON a.id_alumno = ea.id_alumno
GROUP BY a.provincia, ea.estado_curso;

-- falta vista según nacionalidad

-- Crea reporte anual
DELIMITER //
CREATE PROCEDURE generar_reporte_estado_curso(
    IN año INT
   )
BEGIN
    SELECT 
        a.id_alumno,
        CONCAT(a.nombre, ' ', a.apellido) AS nombre_completo,
        c.nombre_curso,
        ea.promedio_notas,
        ea.estado_curso,
        a.provincia,
        a.nacionalidad,
        i.turno,
        i.modalidad,
        s.tipo1 AS institucion_tipo,
        s.tipo2 AS orientacion
    FROM estado_curso_alumnos ea
    JOIN alumnos a ON a.id_alumno = ea.id_alumno
    JOIN cursos c ON c.id_curso = ea.id_curso
    LEFT JOIN inscripciones i ON i.id_alumno = a.id_alumno AND i.id_curso = c.id_curso
    LEFT JOIN alumnos_secundaria s ON s.id_alumno = a.id_alumno
    WHERE ea.año = año;
END //
DELIMITER ;

