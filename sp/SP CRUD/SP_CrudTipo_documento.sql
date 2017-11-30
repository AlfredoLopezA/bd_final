/*==============================================================================*/
/* SP: Para guardar, actualizar o eliminar un registro en                       */
/* la tabla tipo_documento.       		                                        */
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion        : indica la operación 1 = guardar o actualizar, 2 = eliminar.	*/
/* _tipo_id : valor del campo clave. 										    */
/* _tipo_descripcion : nombre del proveedor. 									*/
/* _tipo_exenta    : valor booleando de si esta exenta. 						*/
/*==============================================================================*/
CREATE OR REPLACE FUNCTION sp_crudtipo_documento(IN opcion INT, IN _tipo_id INT, IN _tipo_descripcion VARCHAR(255),
    IN _tipo_exenta boolean)
    RETURNS VOID AS
$$ 
DECLARE
    BEGIN
    	CASE opcion
        WHEN 1 THEN /* Guarda o actualiza un tipo de cocumento. */
        	BEGIN
            IF EXISTS(SELECT tipo_id FROM tipo_documento WHERE tipo_id = _tipo_id) THEN
                UPDATE tipo_documento SET tipo_descripcion = _tipo_descripcion,
                tipo_exenta = _tipo_exenta
                WHERE tipo_id = _tipo_id;
                RAISE NOTICE 'El tipo de documento %, fue actualizado correctamente.', _tipo_descripcion;
            ELSE
                INSERT INTO tipo_documento (tipo_id, tipo_descripcion, tipo_exenta)
                VALUES(_tipo_id, _tipo_descripcion, _tipo_exenta);
                RAISE NOTICE 'Nuevo tipo de documento %, guardado correctamente.', _tipo_descripcion;
            END IF;
            RETURN;
            END;
        WHEN 2 THEN /* Elimina un tipo de documento. */
        	BEGIN
                DELETE FROM tipo_documento WHERE tipo_id = _tipo_id;
                EXCEPTION WHEN foreign_key_violation THEN
                    RAISE EXCEPTION 'El tipo de documento %, no se puede eliminar, porque existe información asociada a su registro.', _tipo_descripcion;
                WHEN others THEN
                    RAISE EXCEPTION 'Se produjo un error en la ejecución del procedimiento.'
                    USING HINT = 'El tipo de documento fue eliminado.';
            END;
            RETURN;
        ELSE /* Opcion no valida. */
            RAISE NOTICE 'La opción % no es valida. Opciones validas: 1 para guardar tipo_documento y 2 para eliminar.', opcion;
            RETURN;
        END CASE;
    END; 
$$ 
language 'plpgsql';