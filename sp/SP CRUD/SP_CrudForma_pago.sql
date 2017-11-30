/*==============================================================================*/
/* SP: Para guardar, actualizar o eliminar un registro en la                    */
/* tabla forma_pago.       					                                    */
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion        : indica la operación 1 = guardar o actualizar, 2 = eliminar.	*/
/* _id_forma_pago : valor del campo clave. 										*/
/* _descripcion_fpago : descripcion de la unidad de la forma de pago. 		    */
/*												                                */
/*==============================================================================*/
CREATE OR REPLACE FUNCTION sp_crudforma_pago(IN opcion INT, IN _id_forma_pago INT, IN _descripcion_fpago VARCHAR(255))
    RETURNS VOID AS
$$ 
DECLARE
    BEGIN
    	CASE opcion
        WHEN 1 THEN /* Guarda o actualiza un registro en la tabla forma_pago*/
        	BEGIN
            IF EXISTS(SELECT id_forma_pago FROM forma_pago WHERE id_forma_pago = _id_forma_pago) THEN
                UPDATE forma_pago SET descripcion_fpago = _descripcion_fpago
                WHERE id_forma_pago = _id_forma_pago;
                RAISE NOTICE 'La forma de pago %, fue actualizado correctamente.', _descripcion_fpago;
            ELSE
                INSERT INTO forma_pago (id_forma_pago, descripcion_fpago)
                VALUES(_id_forma_pago, _descripcion_fpago);
                RAISE NOTICE 'Nueva forma de pago  %, fue guardada correctamente.', _descripcion_fpago;
            END IF;
            RETURN;
            END;
        WHEN 2 THEN /* Elimina un registro en la tabla forma_pago. */
        	BEGIN
                DELETE FROM forma_pago WHERE id_forma_pago = _id_forma_pago;
                EXCEPTION WHEN foreign_key_violation THEN
                    RAISE EXCEPTION 'La forma de pago %, no se puede eliminar, porque existe información asociada a su registro.', _descripcion_fpago;
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