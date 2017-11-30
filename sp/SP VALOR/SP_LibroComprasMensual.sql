/*==============================================================================*/
/* SP		: Resumen de compras por mes.										*/
/* Tablas	: tipo_documento, documento_compra.									*/
/*==============================================================================*/
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion: texto opcional, si no se indica entrega todos los resultados.		*/
/*==============================================================================*/
create or replace function SP_LibroComprasMensual(IN mes int, IN ano int) 
returns table(descripcion varchar(255), tipo int, total bigint)
as 
$$ 
declare 
	registros record;
    begin 
        for registros in(select tipo_documento.tipo_descripcion as descripcion, documento_compra.tipo_id_doc as tipo,
        case when (documento_compra.tipo_id_doc = 32 or documento_compra.tipo_id_doc = 34) then
            sum(documento_compra.neto_doc)
        when (documento_compra.tipo_id_doc = 30 or documento_compra.tipo_id_doc = 33 or documento_compra.tipo_id_doc = 55
         or documento_compra.tipo_id_doc = 56 or documento_compra.tipo_id_doc = 45 or documento_compra.tipo_id_doc = 46
         or documento_compra.tipo_id_doc = 914) then 
            sum(documento_compra.neto_doc * 1.19)
        when (documento_compra.tipo_id_doc = 60 or documento_compra.tipo_id_doc = 61) then 
            sum((documento_compra.neto_doc * 1.19) * -1)
        end as total
        from documento_compra inner join tipo_documento on documento_compra.tipo_id_doc = tipo_documento.tipo_id
		where extract(month from documento_compra.fecha_doc) = mes and
        extract(year from documento_compra.fecha_doc) = ano
        group by tipo_documento.tipo_descripcion, documento_compra.tipo_id_doc)
        loop
            descripcion := registros.descripcion;
            tipo := registros.tipo;
            total := registros.total;
            return next;
        end loop;
    end; 
$$ 
language 'plpgsql'; 