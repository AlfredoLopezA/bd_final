/*==============================================================================*/
/* SP		: Consulta promedio compra mensual por proveedor.					*/
/* Tablas	: proveedor y documento_compra.										*/
/*==============================================================================*/
/* Parametros de entrada.														*/
/*==============================================================================*/
/* mes	: mes de consulta.														*/
/* mes	: año de consulta.														*/
/*==============================================================================*/
create or replace function SP_CompraPromedioMensualPorProveedor(IN mes int, IN ano int) 
returns table(proveedor varchar(255), cuenta int, promedio bigint)
as 
$$ 
declare 
	registros record;
    begin 
        for registros in(select proveedor.razon_social, count(documento_compra.numero_doc) as cuenta, avg(documento_compra.neto_doc) AS promedio
		from proveedor inner join documento_compra on proveedor.id_proveedor = documento_compra.id_proveedor_doc
        where extract(month from documento_compra.fecha_doc) = mes and
        extract(year from documento_compra.fecha_doc) = ano
        GROUP BY proveedor.razon_social)
        loop
            proveedor := registros.razon_social;
            cuenta := registros.cuenta;
            promedio := registros.promedio;
            return next;
        end loop;
    end; 
$$ 
language 'plpgsql'; 