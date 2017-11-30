/*==============================================================================*/
/* SP		: Consulta los productos comprados a los proveedores por mes.		*/
/* Tablas	: categoria_producto, producto, unidad_medida, documento_compra.	*/
/* documento_compra_detalle, proveedor.											*/
/*==============================================================================*/
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion: texto opcional, si no se indica entrega todos los resultados.		*/
/*==============================================================================*/
create or replace function SP_CompraPromedioAnualPorProveedor(IN ano int) 
returns table(proveedor varchar(255), mes int, anoconsulta int, comprapromedio bigint)
as 
$$ 
declare 
	registros record;
    begin 
        for registros in(select proveedor.razon_social as proveedor, extract(month from documento_compra.fecha_doc) as mes, 
        extract(year from documento_compra.fecha_doc) as anoconsulta,
		avg(documento_compra_detalle.precio) as comprapromedio
        from proveedor inner join documento_compra on documento_compra.id_proveedor_doc = proveedor.id_proveedor
        inner join documento_compra_detalle on documento_compra.numero_doc = documento_compra_detalle.numero_doc_det
        and documento_compra.id_proveedor_doc = documento_compra_detalle.id_proveedor_det and documento_compra.tipo_id_doc = documento_compra_detalle.tipo_id_doc_det 
		where extract(year from documento_compra.fecha_doc) = ano
        group by proveedor.razon_social, documento_compra.fecha_doc
        order by proveedor.razon_social asc, documento_compra.fecha_doc asc)
        loop
            proveedor := registros.proveedor;
            mes := registros.mes;
            anoconsulta := registros.anoconsulta;
            comprapromedio := registros.comprapromedio;
            return next;
        end loop;
    end; 
$$ 
language 'plpgsql'; 