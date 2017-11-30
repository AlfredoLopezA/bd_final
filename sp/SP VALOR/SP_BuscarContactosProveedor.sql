/*==============================================================================*/
/* SP		: Consulta los contactos de un proveedores.							*/
/* Tablas	: proveedor y contacto_proveedor.									*/
/*==============================================================================*/
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion: texto opcional, si no se indica entrega todos los resultados.		*/
/*==============================================================================*/
create or replace function SP_BuscarContactosProveedor(IN opcion varchar(255) default 'todo') 
returns table(razonsocial varchar(255), contacto varchar(255), telefono varchar(9), celular  varchar(9), correo varchar(255))
as 
$$ 
declare 
	registros record;
    begin 
    	if opcion='todo' then
            for registros in(select proveedor.razon_social as razonsocial, contacto_proveedor.nombre_contacto as contacto,
            contacto_proveedor.telefono, contacto_proveedor.celular, contacto_proveedor.e_mail as correo
            from proveedor inner join contacto_proveedor on proveedor.id_proveedor = contacto_proveedor.id_proveedor_cont
            order by contacto_proveedor.nombre_contacto asc)
            loop
                razonsocial := registros.razonsocial;
                contacto := registros.contacto;
                telefono := registros.telefono;
                celular := registros.celular;
                correo := registros.correo;
                return next;
            end loop;
        end if;
        if opcion<>'todo' then
        	opcion := upper('%' || opcion || '%');
            for registros in(select proveedor.razon_social as razonsocial, contacto_proveedor.nombre_contacto as contacto,
            contacto_proveedor.telefono, contacto_proveedor.celular, contacto_proveedor.e_mail as correo
            from proveedor inner join contacto_proveedor on proveedor.id_proveedor = contacto_proveedor.id_proveedor_cont
            where proveedor.razon_social like opcion
            order by contacto_proveedor.nombre_contacto asc)
            loop
                razonsocial := registros.razonsocial;
                contacto := registros.contacto;
                telefono := registros.telefono;
                celular := registros.celular;
                correo := registros.correo;
                return next;
            end loop;
        end if;
    end; 
$$ 
language 'plpgsql'; 