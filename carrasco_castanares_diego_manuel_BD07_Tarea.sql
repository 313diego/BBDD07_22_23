CREATE OR REPLACE TYPE Personal AS OBJECT(
    codigo INTEGER,
    dni VARCHAR2 (10),
    nombre VARCHAR2 (30),
    apellidos VARCHAR2 (30),
    sexo VARCHAR2 (1),
    fecha_nac DATE
    
)NOT FINAL;
/

CREATE OR REPLACE TYPE Responsable UNDER Personal (
    tipo CHAR,
    antiguedad INTEGER,
    
    CONSTRUCTOR FUNCTION Responsable (codigo INTEGER,
                                    nombre VARCHAR2,
                                    primer_apellido VARCHAR2,
                                    segundo_apellido VARCHAR2,
                                    tipo CHAR)
    RETURN SELF AS RESULT,
    
    MEMBER FUNCTION getNombreCompleto RETURN VARCHAR2
         
)FINAL
INSTANTIABLE;
/

CREATE OR REPLACE TYPE Zonas AS OBJECT(
    codigo INTEGER,
    nombre VARCHAR2 (20),
    refRespon REF Responsable,
    codigoPostal CHAR(5),
    
    MAP MEMBER FUNCTION ordenarZonas RETURN VARCHAR2
    
)NOT FINAL;
/

CREATE OR REPLACE TYPE Comercial UNDER Personal(
    zonaComercial Zonas
);
/

CREATE OR REPLACE TYPE BODY Responsable AS
    CONSTRUCTOR FUNCTION Responsable (
        codigo INTEGER,
        nombre VARCHAR2,
        primer_apellido VARCHAR2,
        segundo_apellido VARCHAR2,
        tipo CHAR)
    RETURN SELF AS RESULT IS
    BEGIN
        SELF.codigo := codigo;
        SELF.nombre := nombre;
        SELF.apellidos := primer_apellido||' '||segundo_apellido;
        SELF.tipo := tipo;
    RETURN;
    END;
    
    MEMBER FUNCTION getNombreCompleto RETURN VARCHAR2 IS
        BEGIN
        
            RETURN SELF.apellidos||' '||SELF.nombre;
            
    END getNombreCompleto;
END;
/

CREATE OR REPLACE TYPE BODY Responsable AS
    CONSTRUCTOR FUNCTION Responsable (
        codigo INTEGER,
        nombre VARCHAR2,
        primer_apellido VARCHAR2,
        segundo_apellido VARCHAR2,
        tipo CHAR)
    RETURN SELF AS RESULT IS
        BEGIN
            SELF.codigo := codigo;
            SELF.nombre := nombre;
            SELF.apellidos := primer_apellido||' '||segundo_apellido;
            SELF.tipo := tipo;
        RETURN;
        END;
    
    MEMBER FUNCTION getNombreCompleto RETURN VARCHAR2 IS
        BEGIN
        
            RETURN SELF.apellidos||' '||SELF.nombre;
            
    END getNombreCompleto;
END;
/    

CREATE TABLE TablaResponsables OF Responsable;

INSERT INTO TablaResponsables VALUES (5, (NULL), 'ELENA', 'POSTA LLANOS', 'F', '31/03/1975', 'N', 4);

INSERT INTO TablaResponsables VALUES (6, '51083099F', 'JAVIER', 'JARAMILLO HERNANDEZ',(NULL), (NULL), 'C', (NULL));
/

DECLARE TYPE ListaZonas IS VARRAY (10) OF Zonas;

    ListaZonas1 ListaZonas := ListaZonas (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    refRespon REF Responsable;
    unComercial Comercial;
    
BEGIN
    SELECT REF (r) INTO refRespon FROM tablaResponsables r WHERE r.codigo = 5;
    ListaZonas1 (1) := zonas (1, 'zona1', refRespon, 06834);
    SELECT REF (r) INTO refRespon FROM tablaResponsables r WHERE r.dni = '51083099F';
    ListaZonas1 (2) := zonas (2, 'zona2', refRespon, 28003); 
    
END;
/

CREATE TABLE TablaComerciales OF Comercial;

INSERT INTO TablaComerciales VALUES (comercial(100, '23401092Z', 'Marcos', 'Suarez Lopez', 'M', '20/3/1990', (NULL)));
INSERT INTO TablaComerciales VALUES (comercial(102, '6932288V', 'Anastasia', 'Gomes Perez', 'F', '28/11/1984', (NULL)));
/

DECLARE
    unComercial Comercial;

BEGIN
    SELECT VALUE (c) INTO unComercial FROM TablaComerciales c WHERE c.codigo = 100;
END;
/

CREATE OR REPLACE TYPE BODY zonas AS
    MAP MEMBER FUNCTION ordenarZonas RETURN VARCHAR2
    IS
    unResponsable Responsable;
    BEGIN
    SELECT DEREF (refRespon) INTO unResponsable FROM Dual;
    RETURN (unResponsable.getNombreCompleto());
    END ordenarZonas;
END;
/

SELECT * FROM tablaResponsables ORDER BY ordenarZonas;
/


