/*==============================================================================*/
/* SP: Para guardar, actualizar o eliminar  un registro en la                   */
/* tabla contacto_proveedor.       					                            */
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion        : indica la operación 1 = guardar o actualizar, 2 = eliminar.	*/
/* _id_contacto : valor del campo clave. 										*/
/* _id_proveedor_cont :         id contacto proveedor. 							*/
/* _nombre_contacto   : nombre del contacto. 								    */
/* _telefono : telefono contacto proveedor. 								    */
/* _celular    : celular del contacto proveedor. 								*/
/* _e_mail: email contacto proveedor. 										    */
/*==============================================================================*/
CREATE OR REPLACE FUNCTION sp_crudcontacto_proveedor(IN opcion INT, IN _id_contacto INT, IN _id_proveedor_cont INT, IN _nombre_contacto VARCHAR(255), IN _telefono INT,
    IN _celular INT, IN _e_mail VARCHAR(255))
    RETURNS VOID AS
$$ 
DECLARE
    BEGIN
    	CASE opcion
        WHEN 1 THEN /* Guarda o actualiza un registro en la  tabla contacto_proveedor */
        	BEGIN
            IF EXISTS(SELECT id_contacto FROM contacto_proveedor WHERE id_contacto = _id_contacto) THEN
                UPDATE contacto_proveedor SET id_proveedor_cont = _id_proveedor_cont, nombre_contacto = _nombre_contacto, telefono = _telefono,
                celular = _celular, e_mail = _e_mail
                WHERE id_contacto = _id_contacto;
                RAISE NOTICE 'El contacto de proveedor %, fue actualizado correctamente.', _nombre_contacto;
            ELSE
                INSERT INTO contacto_proveedor (id_contacto, id_proveedor_cont, nombre_contacto, telefono, celular, e_mail)
                VALUES(_id_contacto, _id_proveedor_cont, _nombre_contacto, _telefono, _celular, _e_mail);
                RAISE NOTICE 'Nuevo contacto de proveedor %, guardado correctamente.', _nombre_contacto;
            END IF;
            RETURN;
            END;
        WHEN 2 THEN /* Elimina un proveedor. */
        	BEGIN
                DELETE FROM contacto_proveedor WHERE id_contacto = _id_contacto;
                EXCEPTION WHEN foreign_key_violation THEN
                    RAISE EXCEPTION 'El contacto de proveedor %, no se puede eliminar, porque existe información asociada a su registro.', _nombre_contacto;
                WHEN others THEN
                    RAISE EXCEPTION 'Se produjo un error en la ejecución del procedimiento.'
                    USING HINT = 'El contacto de proveedor fue eliminado.';
            END;
            RETURN;
        ELSE /* Opcion no valida. */
            RAISE NOTICE 'La opción % no es valida. Opciones validas: 1 para guardar un contacto de proveedor y 2 para eliminar.', opcion;
            RETURN;
        END CASE;
    END; 
$$ 
language 'plpgsql';