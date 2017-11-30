/*==============================================================================*/
/* SP: Para guardar, actualizar o eliminar un registro en la tabla              */
/* documento_compra_detalle.       					                            */
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion        : indica la operación 1 = guardar o actualizar, 2 = eliminar.	*/
/* _numero_doc_det : valor del campo clave, numero del docuemnto de detalle.    */
/* _id_proveedor_det          : id del proveedor. 							    */
/* _tipo_id_doc_det   : id del tipo de documento. 								*/
/* _codigo_producto_doc_det : codigo de producto. 						        */
/* _precio: precio. 										                    */
/* _item_doc_det  : numero de item. 											*/
/*==============================================================================*/
CREATE OR REPLACE FUNCTION sp_cruddocumento_compra_detalle(IN opcion INT, IN _numero_doc_det INT, IN _id_proveedor_det INT,IN _tipo_id_doc_det INT, IN _codigo_producto_doc_det INT, IN _cantidad INT,
    IN _precio INT, IN _item_doc_det INT)
    RETURNS VOID AS
$$ 
DECLARE
    BEGIN
    	CASE opcion
        WHEN 1 THEN /* Guarda o actualiza un registro en la tabla documento_compra_detalle. */
        	BEGIN
            IF EXISTS(SELECT numero_doc_det FROM documento_compra_detalle WHERE numero_doc_det = _numero_doc_det)
               AND EXISTS(SELECT id_proveedor_det FROM documento_compra_detalle WHERE id_proveedor_det = _id_proveedor_det)
                  AND EXISTS(SELECT tipo_id_doc_det FROM documento_compra_detalle WHERE tipo_id_doc_det = _tipo_id_doc_det)
                     AND EXISTS(SELECT item_doc_det FROM documento_compra_detalle WHERE item_doc_det = _item_doc_det) 

            THEN
                UPDATE documento_compra_detalle SET id_proveedor_det = _id_proveedor_det, tipo_id_doc_det = _tipo_id_doc_det, codigo_producto_doc_det = _codigo_producto_doc_det,
                cantidad = _cantidad, precio = _precio, item_doc_det = _item_doc_det
                WHERE numero_doc_det = _numero_doc_det AND id_proveedor_det = _id_proveedor_det AND tipo_id_doc_det = _tipo_id_doc_det AND item_doc_det = _item_doc_det;
                RAISE NOTICE 'El detalle de cocumento de compra %, fue actualizado correctamente.', _numero_doc_det;
            ELSE
                INSERT INTO documento_compra_detalle (numero_doc_det,id_proveedor_det,tipo_id_doc_det,codigo_producto_doc_det, cantidad,precio,item_doc_det)
                VALUES(_numero_doc_det,_id_proveedor_det,_tipo_id_doc_det,_codigo_producto_doc_det, _cantidad,_precio,_item_doc_det);
                RAISE NOTICE 'Nuevo detalle de cocumento de compra %, guardado correctamente.', _numero_doc_det;
            END IF;
            RETURN;
            END;
        WHEN 2 THEN /* Elimina un registro en la tabla documento_compra_detalle. */
        	BEGIN
                DELETE FROM documento_compra_detalle WHERE numero_doc_det = _numero_doc_det;
                EXCEPTION WHEN foreign_key_violation THEN
                    RAISE EXCEPTION 'El detalle de cocumento de compra %, no se puede eliminar, porque existe información asociada a su registro.', _numero_doc_det;
                WHEN others THEN
                    RAISE EXCEPTION 'Se produjo un error en la ejecución del procedimiento.'
                    USING HINT = 'El detalle de cocumento de compra fue eliminado.';
            END;
            RETURN;
        ELSE /* Opcion no valida. */
            RAISE NOTICE 'La opción % no es valida. Opciones validas: 1 para guardar detalle de cocumento de compra y 2 para eliminar.', opcion;
            RETURN;
        END CASE;
    END; 
$$ 
language 'plpgsql';