/*==============================================================================*/
/* SP		: Consulta los productos comprados a los proveedores por mes.		*/
/* Tablas	: categoria_producto, producto, unidad_medida, documento_compra.	*/
/* documento_compra_detalle, proveedor.											*/
/*==============================================================================*/
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion: texto opcional, si no se indica entrega todos los resultados.		*/
/*==============================================================================*/
create or replace function SP_PrecioPromedioProductosPorMes(IN mes int, IN ano int) 
returns table(articulo varchar(255), medida varchar(6), unidades int, preciopromedio bigint)
as 
$$ 
declare 
	registros record;
    begin 
        for registros in(select producto.nombre_producto as articulo, unidad_medida.descripcion_uni_med as medida, sum(documento_compra_detalle.cantidad) as unidades, 
		avg(documento_compra_detalle.precio) as preciopromedio
        from categoria_producto inner join producto on categoria_producto.id_categoria = producto.id_categoria_prod
        inner join unidad_medida on producto.id_uni_med_prod = unidad_medida.id_uni_med
        inner join documento_compra_detalle on producto.codigo_producto = documento_compra_detalle.codigo_producto_doc_det
        inner join documento_compra on documento_compra.numero_doc = documento_compra_detalle.numero_doc_det 
        inner join proveedor on documento_compra.id_proveedor_doc = proveedor.id_proveedor
        and documento_compra.id_proveedor_doc = documento_compra_detalle.id_proveedor_det and documento_compra.tipo_id_doc = documento_compra_detalle.tipo_id_doc_det 
		where extract(month from documento_compra.fecha_doc) = mes and
        extract(year from documento_compra.fecha_doc) = ano
        group by producto.nombre_producto, unidad_medida.descripcion_uni_med)
        loop
            articulo := registros.articulo;
            medida := registros.medida;
            unidades := registros.unidades;
            preciopromedio := registros.preciopromedio;
            return next;
        end loop;
    end; 
$$ 
language 'plpgsql'; 