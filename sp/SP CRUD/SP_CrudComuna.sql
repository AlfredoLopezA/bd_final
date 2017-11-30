/*==============================================================================*/
/* SP: Para guardar, actualizar o eliminar un registro en la                    */
/* tabla comuna.       					                                        */
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion        : indica la operación 1 = guardar o actualizar, 2 = eliminar.	*/
/* _id_comuna : valor del campo clave. 										    */
/* _nombre_comuna : nombre de la comuna. 				                        */
/*												                                */
/*==============================================================================*/
CREATE OR REPLACE FUNCTION sp_crudcomuna(IN opcion INT, IN _id_comuna INT, IN _nombre_comuna VARCHAR(255))
    RETURNS VOID AS
$$ 
DECLARE
    BEGIN
    	CASE opcion
        WHEN 1 THEN /* Guarda o actualiza un proveedor. */
        	BEGIN
            IF EXISTS(SELECT id_comuna FROM comuna WHERE id_comuna = _id_comuna) THEN
                UPDATE comuna SET nombre_comuna = _nombre_comuna
                WHERE id_comuna = _id_comuna;
                RAISE NOTICE 'La comuna de nombre %, fue actualizada correctamente.', _nombre_comuna;
            ELSE
                INSERT INTO comuna (id_comuna, nombre_comuna)
                VALUES(_id_comuna, _nombre_comuna);
                RAISE NOTICE 'Nueva comuna de nombre %, fue guardada correctamente.', _nombre_comuna;
            END IF;
            RETURN;
            END;
        WHEN 2 THEN /* Elimina una categoria de producto. */
        	BEGIN
                DELETE FROM comuna WHERE id_comuna = _id_comuna;
                EXCEPTION WHEN foreign_key_violation THEN
                    RAISE EXCEPTION 'La comuna %, no se puede eliminar, porque existe información asociada a su registro.', _nombre_comuna;
                WHEN others THEN
                    RAISE EXCEPTION 'Se produjo un error en la ejecución del procedimiento.'
                    USING HINT = 'La comuna fue eliminada.';
            END;
            RETURN;
        ELSE /* Opcion no valida. */
            RAISE NOTICE 'La opción % no es valida. Opciones validas: 1 para guardar proveedor y 2 para eliminar.', opcion;
            RETURN;
        END CASE;
    END; 
$$ 
language 'plpgsql';