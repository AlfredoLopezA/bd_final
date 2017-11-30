/*==============================================================================*/
/* SP		: Consulta los contactos de un proveedores.							*/
/* Tablas	: proveedor y comuna.												*/
/*==============================================================================*/
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion: texto opcional, si no se indica entrega todos los resultados.		*/
/*==============================================================================*/
create or replace function SP_CantidadProveedoresPorComuna(IN opcion varchar(255) default 'todo') 
returns table(codcomuna int, comuna varchar(255), cuenta int)
as 
$$ 
declare 
	registros record;
    begin 
    	if opcion='todo' then
            for registros in(select proveedor.id_comuna_pro as codcomuna, comuna.nombre_comuna as comuna, count(proveedor.id_proveedor) as cuenta
            from proveedor inner join comuna on proveedor.id_comuna_pro = comuna.id_comuna
            GROUP BY comuna.nombre_comuna, proveedor.id_comuna_pro
            order by comuna.nombre_comuna)
            loop
                codcomuna := registros.codcomuna;
                comuna := registros.comuna;
                cuenta := registros.cuenta;
                return next;
            end loop;
        else
        	opcion := upper('%' || opcion || '%');
            for registros in(select proveedor.id_comuna_pro as codcomuna, comuna.nombre_comuna as comuna, count(proveedor.id_proveedor) as cuenta
            from proveedor inner join comuna on proveedor.id_comuna_pro = comuna.id_comuna
            where comuna.nombre_comuna like opcion
            group by comuna.nombre_comuna, proveedor.id_comuna_pro
            order by comuna.nombre_comuna)
            loop
                codcomuna := registros.codcomuna;
                comuna := registros.comuna;
                cuenta := registros.cuenta;
                return next;
            end loop;
        end if;
    end; 
$$ 
language 'plpgsql'; 