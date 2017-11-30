/*==============================================================================*/
/* SP		: Consulta proveedor con más compras en un rango de fechas.			*/
/* Tablas	: proveedor y documento_compra.										*/
/*==============================================================================*/
/* Parametros de entrada.														*/
/*==============================================================================*/
/* fechainicio : fecha inicio de consulta.										*/
/* fechafinal  : fecha final de consulta.										*/
/*==============================================================================*/
create or replace function SP_ProveedorMasComprado(IN fechainicio date, IN fechafinal date) 
returns table(rut varchar(10), proveedor varchar(255), compratotal bigint)
as 
$$ 
declare 
	registros record;
    begin 
        for registros IN(select (proveedor.rut || '-' || proveedor.digito_rut) as dni, proveedor.razon_social, SUM(documento_compra.neto_doc) as totalcompra
		from documento_compra inner join proveedor on documento_compra.id_proveedor_doc = proveedor.id_proveedor
        where documento_compra.fecha_doc >= fechainicio and documento_compra.fecha_doc <= fechafinal
		group by proveedor.rut, proveedor.digito_rut, proveedor.razon_social, documento_compra.neto_doc)
        loop
        	rut := registros.dni;
            proveedor := registros.razon_social;
            compratotal := registros.totalcompra;
            return next;
        end loop;
    end; 
$$ 
language 'plpgsql'; 