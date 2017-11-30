/*==============================================================================*/
/* SP: Para guardar, actualizar o eliminar un registro en la                    */
/* tabla categoria_producto.       					                            */
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion        : indica la operación 1 = guardar o actualizar, 2 = eliminar.	*/
/* _id_categoria : valor del campo clave. 										*/
/* _descripcion_cat : descripcion de la categoria del producto. 				*/
/*												                                */
/*==============================================================================*/
CREATE OR REPLACE FUNCTION sp_crudcategoria_producto(IN opcion INT, IN _id_categoria INT, IN _descripcion_cat VARCHAR(255))
    RETURNS VOID AS
$$ 
DECLARE
    BEGIN
    	CASE opcion
        WHEN 1 THEN /* Guarda o actualiza un proveedor. */
        	BEGIN
            IF EXISTS(SELECT id_categoria FROM categoria_producto WHERE id_categoria = _id_categoria) THEN
                UPDATE categoria_producto SET descripcion_cat = _descripcion_cat
                WHERE id_categoria = _id_categoria;
                RAISE NOTICE 'La categoria de producto %, fue actualizado correctamente.', _descripcion_cat;
            ELSE
                INSERT INTO categoria_producto (id_categoria, descripcion_cat)
                VALUES(_id_categoria, _descripcion_cat);
                RAISE NOTICE 'Nueva categoria de producto %, guardada correctamente.', _descripcion_cat;
            END IF;
            RETURN;
            END;
        WHEN 2 THEN /* Elimina una categoria de producto. */
        	BEGIN
                DELETE FROM categoria_producto WHERE id_categoria = _id_categoria;
                EXCEPTION WHEN foreign_key_violation THEN
                    RAISE EXCEPTION 'La categpria del producto %, no se puede eliminar, porque existe información asociada a su registro.', _descripcion_cat;
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
