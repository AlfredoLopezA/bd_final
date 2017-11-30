/*==============================================================================*/
/* SP: Para guardar, actualizar o eliminar un proveedor.       					*/
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion        : indica la operación 1 = guardar o actualizar, 2 = eliminar.	*/
/* _id_proveedor : valor del campo clave. 										*/
/* _rut          : rut del proveedor. 											*/
/* _digito_rut   : digito validador del rut. 									*/
/* _razon_social : nombre del proveedor. 										*/
/* _direccion    : dirección del proveedor. 									*/
/* _id_comuna_pro: comuna de residencia. 										*/
/* _id_giro_pro  : giro comercial. 												*/
/*==============================================================================*/
CREATE OR REPLACE FUNCTION sp_crudproveedor(IN opcion INT, IN _id_proveedor INT, IN _rut INT, IN _digito_rut CHAR(1), IN _razon_social VARCHAR(255),
    IN _direccion VARCHAR(255), IN _id_comuna_pro INT, IN _id_giro_pro INT)
    RETURNS VOID AS
$$ 
DECLARE
    BEGIN
    	CASE opcion
        WHEN 1 THEN /* Guarda o actualiza un proveedor. */
        	BEGIN
            IF EXISTS(SELECT id_proveedor FROM proveedor WHERE id_proveedor = _id_proveedor) THEN
                UPDATE proveedor SET rut = _rut, digito_rut = _digito_rut, razon_social = _razon_social,
                direccion = _direccion, id_comuna_pro = _id_comuna_pro, id_giro_pro = _id_giro_pro
                WHERE id_proveedor = _id_proveedor;
                RAISE NOTICE 'El proveedor %, fue actualizado correctamente.', _razon_social;
            ELSE
                INSERT INTO proveedor (id_proveedor, rut, digito_rut, razon_social, direccion, id_comuna_pro, id_giro_pro)
                VALUES(_id_proveedor, _rut, _digito_rut, _razon_social, _direccion, _id_comuna_pro, _id_giro_pro);
                RAISE NOTICE 'Nuevo proveedor %, guardado correctamente.', _razon_social;
            END IF;
            RETURN;
            END;
        WHEN 2 THEN /* Elimina un proveedor. */
        	BEGIN
                DELETE FROM proveedor WHERE id_proveedor = _id_proveedor;
                EXCEPTION WHEN foreign_key_violation THEN
                    RAISE EXCEPTION 'El proveedor %, no se puede eliminar, porque existe información asociada a su registro.', _razon_social;
                WHEN others THEN
                    RAISE EXCEPTION 'Se produjo un error en la ejecución del procedimiento.'
                    USING HINT = 'El proveedor fue eliminado.';
            END;
            RETURN;
        ELSE /* Opcion no valida. */
            RAISE NOTICE 'La opción % no es valida. Opciones validas: 1 para guardar proveedor y 2 para eliminar.', opcion;
            RETURN;
        END CASE;
    END; 
$$ 
language 'plpgsql';