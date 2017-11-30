/*==============================================================================*/
/* SP: Para guardar, actualizar o eliminar un producto.       					*/
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion        : indica la operación 1 = guardar o actualizar, 2 = eliminar.	*/
/* _codigo_producto : valor del campo clave. 								    */
/* _id_categoria_prod          : rut del proveedor. 							*/
/* _nombre_producto : nombre del producto. 										*/
/* _id_uni_med_prod    : id de la unidad de medida del producto. 				*/
/* _stock_minimo: stock minimo de producto. 									*/
/* _stock_maximo  : stock maximo de producto. 									*/
/*==============================================================================*/
CREATE OR REPLACE FUNCTION sp_crudproducto(IN opcion INT, IN _codigo_producto INT, IN _id_categoria_prod INT, IN _nombre_producto VARCHAR(255), IN _id_uni_med_prod INT, IN _stock_minimo INT, IN _stock_maximo INT)
    RETURNS VOID AS
$$ 
DECLARE
    BEGIN
    	CASE opcion
        WHEN 1 THEN /* Guarda o actualiza un producto. */
        	BEGIN
            IF EXISTS(SELECT codigo_producto FROM producto WHERE codigo_producto = _codigo_producto) THEN
                UPDATE producto SET  id_categoria_prod = _id_categoria_prod, nombre_producto = _nombre_producto,
                id_uni_med_prod = _id_uni_med_prod, stock_minimo = _stock_minimo, stock_maximo = _stock_maximo
                WHERE codigo_producto = _codigo_producto;
                RAISE NOTICE 'El producto %, fue actualizado correctamente.', _nombre_producto;
            ELSE
                INSERT INTO producto (codigo_producto, id_categoria_prod, nombre_producto, id_uni_med_prod, stock_minimo, stock_maximo)
                VALUES(_codigo_producto, _id_categoria_prod, _nombre_producto, _id_uni_med_prod, _stock_minimo, _stock_maximo);
                RAISE NOTICE 'Nuevo producto %, guardado correctamente.', _nombre_producto;
            END IF;
            RETURN;
            END;
        WHEN 2 THEN /* Elimina un producto. */
        	BEGIN
                DELETE FROM producto WHERE codigo_producto = _codigo_producto;
                EXCEPTION WHEN foreign_key_violation THEN
                    RAISE EXCEPTION 'El producto %, no se puede eliminar, porque existe información asociada a su registro.', _nombre_producto;
                WHEN others THEN
                    RAISE EXCEPTION 'Se produjo un error en la ejecución del procedimiento.'
                    USING HINT = 'El producto fue eliminado.';
            END;
            RETURN;
        ELSE /* Opcion no valida. */
            RAISE NOTICE 'La opción % no es valida. Opciones validas: 1 para guardar producto y 2 para eliminar.', opcion;
            RETURN;
        END CASE;
    END; 
$$ 
language 'plpgsql';