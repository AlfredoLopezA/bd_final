/*==============================================================================*/
/* SP		: Consulta productos más comprados en un rango de fechas.			*/
/* Tablas	: documento_compra, documento_compra_detalle, producto.				*/
/*==============================================================================*/
/* Parametros de entrada.														*/
/*==============================================================================*/
/* fechainicio : fecha inicio de consulta.										*/
/* fechafinal  : fecha final de consulta.										*/
/*==============================================================================*/
create or replace function SP_ProductoMasComprado(IN fechainicio date, IN fechafinal date) 
returns table(codigo bigint, producto varchar(255),unidades varchar(6), costo bigint)
as 
$$ 
declare 
	registros record;
    begin 
        for registros IN(select documento_compra_detalle.codigo_producto_doc_det, producto.nombre_producto, sum(documento_compra_detalle.cantidad) as unidades,
        sum(documento_compra_detalle.cantidad * documento_compra_detalle.precio) as Total
        from documento_compra inner join documento_compra_detalle on documento_compra.numero_doc=documento_compra_detalle.numero_doc_det 
        and documento_compra.id_proveedor_doc = documento_compra_detalle.id_proveedor_det and documento_compra.tipo_id_doc = documento_compra_detalle.tipo_id_doc_det
        inner join producto on documento_compra_detalle.codigo_producto_doc_det = producto.codigo_producto
        where documento_compra.fecha_doc >=fechainicio and documento_compra.fecha_doc<=fechafinal
        group by documento_compra_detalle.codigo_producto_doc_det, producto.nombre_producto)
        loop
        	codigo := registros.codigo_producto_doc_det;
            producto := registros.nombre_producto;
            unidades := registros.unidades;
            costo := registros.Total;
            return next;
        end loop;
    end; 
$$ 
language 'plpgsql'; 