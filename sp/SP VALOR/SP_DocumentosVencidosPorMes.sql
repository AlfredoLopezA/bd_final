/*==============================================================================*/
/* SP		: Consultar facturas de compra vencidas no pagadas por mes.			*/
/* Tablas	: documento_compra, tipo_documento, proveedor.						*/
/*==============================================================================*/
/* Parametros de entrada.														*/
/*==============================================================================*/
/* mes : mes de consulta.														*/
/* ano : año de consulta.														*/
/*==============================================================================*/
create or replace function SP_DocumentosVencidosPorMes(IN mes int, IN ano int) 
returns table(CodProv bigint, Numero bigint, TipoDoc varchar(255), RazonSocial varchar(255), Fecha date,
             Vencimiento date, Total bigint)
as 
$$ 
declare 
	registros record;
    begin 
        for registros in(select documento_compra.id_proveedor_doc as id_prov, documento_compra.numero_doc as numero, 
        tipo_documento.tipo_descripcion as tipo_doc, proveedor.razon_social, documento_compra.neto_doc,
        documento_compra.fecha_doc as fecha, documento_compra.fecha_vencimiento_doc as vencimiento,
        case when (documento_compra.tipo_id_doc = 32 or documento_compra.tipo_id_doc = 34) then
            documento_compra.neto_doc
        when (documento_compra.tipo_id_doc = 30 or documento_compra.tipo_id_doc = 33 or documento_compra.tipo_id_doc = 55
         or documento_compra.tipo_id_doc = 56 or documento_compra.tipo_id_doc = 45 or documento_compra.tipo_id_doc = 46
         or documento_compra.tipo_id_doc = 914) then 
            documento_compra.neto_doc * 1.19
        end as total
        from documento_compra inner join proveedor on documento_compra.id_proveedor_doc = proveedor.id_proveedor
        inner join tipo_documento on documento_compra.tipo_id_doc = tipo_documento.tipo_id
        where extract(month from documento_compra.fecha_vencimiento_doc) = mes and extract(year from documento_compra.fecha_vencimiento_doc) = ano
        and documento_compra.pagado_doc = false
        order by proveedor.razon_social asc, documento_compra.fecha_vencimiento_doc asc)
        loop
        	CodProv := registros.id_prov;
            Numero := registros.numero;
            TipoDoc := registros.tipo_doc;
            RazonSocial := registros.razon_social;
            Fecha := registros.fecha;
            Vencimiento := registros.vencimiento;
            Total := registros.total;
            return next;
        end loop;
    end; 
$$ 
language 'plpgsql'; 