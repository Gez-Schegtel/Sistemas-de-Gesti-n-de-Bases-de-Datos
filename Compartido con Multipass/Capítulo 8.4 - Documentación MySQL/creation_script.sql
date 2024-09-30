CREATE TABLE graba (
    idbanda INT,
    idalbum INT,
    PRIMARY KEY (idbanda, idalbum),
    FOREIGN KEY (idbanda) REFERENCES bandas(idbanda),
    FOREIGN KEY (idalbum) REFERENCES albums(idalbum)
);

CREATE TABLE canciones (
    idcanción INT AUTO_INCREMENT,
    nombre VARCHAR(45),
    duración TIME NOT NULL,
    PRIMARY KEY (idcanción)
);

CREATE TABLE pertenece (
    idalbum INT,
    idcanción INT,
    PRIMARY KEY (idalbum, idcanción),
    FOREIGN KEY (idalbum) REFERENCES albums(idalbum),
    FOREIGN KEY (idcanción) REFERENCES canciones(idcanción)
);
