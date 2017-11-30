/*==============================================================================*/
/* SP: Para guardar, actualizar o eliminar un registro en la                    */
/* tabla giro.       					                                */
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion        : indica la operación 1 = guardar o actualizar, 2 = eliminar.	*/
/* _id_giro : valor del campo clave. 										*/
/* _descripcion_giro : descripcion de la unidad del giro. 				    */
/*												                                */
/*==============================================================================*/
CREATE OR REPLACE FUNCTION sp_crudgiro(IN opcion INT, IN _id_giro INT, IN _descripcion_giro VARCHAR(255))
    RETURNS VOID AS
$$ 
DECLARE
    BEGIN
    	CASE opcion
        WHEN 1 THEN /* Guarda o actualiza un registro en la tabla giro*/
        	BEGIN
            IF EXISTS(SELECT id_giro FROM giro WHERE id_giro = _id_giro) THEN
                UPDATE giro SET descripcion_giro = _descripcion_giro
                WHERE id_giro = _id_giro;
                RAISE NOTICE 'El giro %, fue actualizado correctamente.', _descripcion_giro;
            ELSE
                INSERT INTO giro (id_giro, descripcion_giro)
                VALUES(_id_giro, _descripcion_giro);
                RAISE NOTICE 'Nueva categoria de giro %, guardada correctamente.', _descripcion_giro;
            END IF;
            RETURN;
            END;
        WHEN 2 THEN /* Elimina un registro en la tabla giro. */
        	BEGIN
                DELETE FROM giro WHERE id_giro = _id_giro;
                EXCEPTION WHEN foreign_key_violation THEN
                    RAISE EXCEPTION 'El giro %, no se puede eliminar, porque existe información asociada a su registro.', _descripcion_giro;
                WHEN others THEN
                    RAISE EXCEPTION 'Se produjo un error en la ejecución del procedimiento.'
                    USING HINT = 'La categoria de producto fue eliminada.';
            END;
            RETURN;
        ELSE /* Opcion no valida. */
            RAISE NOTICE 'La opción % no es valida. Opciones validas: 1 para guardar proveedor y 2 para eliminar.', opcion;
            RETURN;
        END CASE;
    END; 
$$ 
language 'plpgsql';