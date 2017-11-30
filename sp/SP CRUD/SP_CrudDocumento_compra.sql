/*==============================================================================*/
/* SP: Para guardar, actualizar o eliminar un registro en la tabla              */
/* documento_compra.       					                                    */
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion        : indica la operación 1 = guardar o actualizar, 2 = eliminar.	*/
/* _numero_doc : valor del campo clave.                                         */
/* _id_proveedor_doc : id del proveedor. 				        			    */
/* _tipo_id_doc   : id del tipo de documento. 								    */
/* _fecha_doc : fecha del docuemnto.                                            */
/* _fecha_vencimiento_doc : fecha de vencimiento del docuemto. 				    */
/* _neto_doc: neto del documento. 										        */
/* _pagado_doc  : booleano de pagado.                                           */
/* _id_forma_pago_doc:	id de forma de pago.					                */
/*==============================================================================*/
CREATE OR REPLACE FUNCTION sp_cruddocumento_compra(IN opcion INT, IN _numero_doc INT, IN _id_proveedor_doc INT,IN _tipo_id_doc INT, IN _fecha_doc date, IN _fecha_vencimiento_doc date,
    IN _neto_doc INT, IN _pagado_doc boolean, IN _id_forma_pago_doc INT)
    RETURNS VOID AS
$$ 
DECLARE
    BEGIN
    	CASE opcion
        WHEN 1 THEN /* Guarda o actualiza un registro en la tabla documento_compra. */
        	BEGIN
            IF EXISTS(SELECT numero_doc FROM documento_compra WHERE numero_doc = _numero_doc)
               AND EXISTS(SELECT id_proveedor_doc FROM documento_compra WHERE id_proveedor_doc = _id_proveedor_doc)
                  AND EXISTS(SELECT tipo_id_doc FROM documento_compra WHERE tipo_id_doc = _tipo_id_doc)
            THEN
                UPDATE documento_compra SET id_proveedor_doc = _id_proveedor_doc, tipo_id_doc = _tipo_id_doc, fecha_doc = _fecha_doc,
                fecha_vencimiento_doc = _fecha_vencimiento_doc, neto_doc = _neto_doc, pagado_doc = _pagado_doc, id_forma_pago_doc = _id_forma_pago_doc
                WHERE numero_doc = _numero_doc AND id_proveedor_doc = _id_proveedor_doc AND tipo_id_doc = _tipo_id_doc;
                RAISE NOTICE 'El detalle de cocumento de compra %, fue actualizado correctamente.', _numero_doc;
            ELSE
                INSERT INTO documento_compra (numero_doc,id_proveedor_doc,tipo_id_doc,fecha_doc, fecha_vencimiento_doc,neto_doc,pagado_doc, id_forma_pago_doc)
                VALUES(_numero_doc,_id_proveedor_doc,_tipo_id_doc,_fecha_doc, _fecha_vencimiento_doc,_neto_doc,_pagado_doc,_id_forma_pago_doc);
                RAISE NOTICE 'Nuevo detalle de cocumento de compra %, guardado correctamente.', _numero_doc;
            END IF;
            RETURN;
            END;
        WHEN 2 THEN /* Elimina un registro en la tabla documento_compra. */
        	BEGIN
                DELETE FROM documento_compra WHERE numero_doc = _numero_doc;
                EXCEPTION WHEN foreign_key_violation THEN
                    RAISE EXCEPTION 'El detalle de cocumento de compra %, no se puede eliminar, porque existe información asociada a su registro.', _numero_doc;
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