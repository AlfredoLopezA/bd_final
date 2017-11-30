/*==============================================================================*/
/* SP		: Consulta los productos comprados a los proveedores por mes.		*/
/* Tablas	: categoria_producto, producto, unidad_medida, documento_compra.	*/
/* documento_compra_detalle, proveedor.											*/
/*==============================================================================*/
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion: texto opcional, si no se indica entrega todos los resultados.		*/
/*==============================================================================*/
create or replace function SP_TotalesCompradosPorCategoriaPorMes(IN mes int, IN ano int) 
returns table(categoria varchar(255), medida varchar(6), unidades int, costototal bigint)
as 
$$ 
declare 
	registros record;
    begin 
        for registros in(select categoria_producto.descripcion_cat as categoria, unidad_medida.descripcion_uni_med as medida, 
		sum(documento_compra_detalle.cantidad) as unidades, sum(documento_compra_detalle.precio) as costototal
        from categoria_producto inner join producto on categoria_producto.id_categoria = producto.id_categoria_prod
        inner join unidad_medida on producto.id_uni_med_prod = unidad_medida.id_uni_med
        inner join documento_compra_detalle on producto.codigo_producto = documento_compra_detalle.codigo_producto_doc_det
        inner join documento_compra on documento_compra.numero_doc = documento_compra_detalle.numero_doc_det 
        inner join proveedor on documento_compra.id_proveedor_doc = proveedor.id_proveedor
        and documento_compra.id_proveedor_doc = documento_compra_detalle.id_proveedor_det and documento_compra.tipo_id_doc = documento_compra_detalle.tipo_id_doc_det 
		where extract(month from documento_compra.fecha_doc) = 6 and
        extract(year from documento_compra.fecha_doc) = 2017
        group by categoria_producto.descripcion_cat, unidad_medida.descripcion_uni_med
        order by categoria_producto.descripcion_cat asc)
        loop
            categoria := registros.categoria;
            medida := registros.medida;
            unidades := registros.unidades;
            costototal := registros.costototal;
            return next;
        end loop;
    end; 
$$ 
language 'plpgsql'; 