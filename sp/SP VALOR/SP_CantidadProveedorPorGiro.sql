/*==============================================================================*/
/* SP		: Consulta cantidad de proveedores por giro.						*/
/* Tablas	: proveedor y giro.													*/
/*==============================================================================*/
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion: texto opcional, si no se indica entrega todos los resultados.		*/
/*==============================================================================*/
create or replace function SP_CantidadProveedorPorGiro(IN opcion varchar(255) default 'todo') 
returns table(codgiro int, giro varchar(255), cuenta int)
as 
$$ 
declare 
	registros record;
    begin 
    	if opcion='todo' then
            for registros in(select proveedor.id_giro_pro as codgiro, giro.descripcion_giro as giro, count(proveedor.id_proveedor) as cuenta
			from proveedor inner join giro on proveedor.id_giro_pro = giro.id_giro
			GROUP BY giro.descripcion_giro, proveedor.id_giro_pro
			order by giro.descripcion_giro)
            loop
                codgiro := registros.codgiro;
                giro := registros.giro;
                cuenta := registros.cuenta;
                return next;
            end loop;
        end if;
        if opcion<>'todo' then
        	opcion := upper('%' || opcion || '%');
            for registros in(select proveedor.id_giro_pro as codgiro, giro.descripcion_giro as giro, count(proveedor.id_proveedor) as cuenta
			from proveedor inner join giro on proveedor.id_giro_pro = giro.id_giro
            where giro.descripcion_giro like opcion
			GROUP BY giro.descripcion_giro, proveedor.id_giro_pro
			order by giro.descripcion_giro)
            loop
                codgiro := registros.codgiro;
                giro := registros.giro;
                cuenta := registros.cuenta;
                return next;
            end loop;
        end if;
    end; 
$$ 
language 'plpgsql'; 