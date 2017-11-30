/*==============================================================================*/
/* SP: Para guardar, actualizar o eliminar un registro en la                    */
/* tabla unidad_medida.       					                                */
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion        : indica la operación 1 = guardar o actualizar, 2 = eliminar.	*/
/* _id_uni_med : valor del campo clave. 										*/
/* _descripcion_uni_med : descripcion de la unidad de medida. 				    */
/*												                                */
/*==============================================================================*/
CREATE OR REPLACE FUNCTION sp_crudunidad_medida(IN opcion INT, IN _id_uni_med INT, IN _descripcion_uni_med VARCHAR(255))
    RETURNS VOID AS
$$ 
DECLARE
    BEGIN
    	CASE opcion
        WHEN 1 THEN /* Guarda o actualiza un registro en la tabla unidad_medida*/
        	BEGIN
            IF EXISTS(SELECT id_uni_med FROM unidad_medida WHERE id_uni_med = _id_uni_med) THEN
                UPDATE unidad_medida SET descripcion_uni_med = _descripcion_uni_med
                WHERE id_uni_med = _id_uni_med;
                RAISE NOTICE 'La unidad de medida %, fue actualizado correctamente.', _descripcion_uni_med;
            ELSE
                INSERT INTO unidad_medida (id_uni_med, descripcion_uni_med)
                VALUES(_id_uni_med, _descripcion_uni_med);
                RAISE NOTICE 'Nueva categoria de unidad de medida %, guardada correctamente.', _descripcion_uni_med;
            END IF;
            RETURN;
            END;
        WHEN 2 THEN /* Elimina un registro en la tabla unidad_medida. */
        	BEGIN
                DELETE FROM unidad_medida WHERE id_uni_med = _id_uni_med;
                EXCEPTION WHEN foreign_key_violation THEN
                    RAISE EXCEPTION 'La unidad de medida %, no se puede eliminar, porque existe información asociada a su registro.', _descripcion_uni_med;
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