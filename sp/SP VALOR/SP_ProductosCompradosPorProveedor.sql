/*==============================================================================*/
/* SP		: Consulta los productos comprados a uno o todos los proveedores.	*/
/* Muestra detalles de las compras.												*/
/* Tablas	: categoria_producto, producto, unidad_medida, documento_compra.	*/
/* documento_compra_detalle, proveedor.											*/
/*==============================================================================*/
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion: texto opcional, si no se indica entrega todos los resultados.		*/
/*==============================================================================*/
create or replace function SP_ProductosCompradosPorProveedor(IN opcion varchar(255) default 'todo') 
returns table(idcat int, categoria varchar(255), codigo bigint, articulo varchar(255), medida varchar(6), stockmin float, stockmax float,
             numdocto bigint, idprov bigint, prov varchar(255), fecha date, cantidad int, precio bigint)
as 
$$ 
declare 
	registros record;
    begin 
    	if opcion='todo' then
            for registros in(select categoria_producto.id_categoria as idcat, categoria_producto.descripcion_cat as categoria, producto.codigo_producto as codigo,
            producto.nombre_producto as articulo, unidad_medida.descripcion_uni_med as medida, producto.stock_minimo as stockmin, producto.stock_maximo as stockmax,
            documento_compra.numero_doc as numdocto, documento_compra.id_proveedor_doc as idprov, proveedor.razon_social as prov, documento_compra.fecha_doc as fecha,
            documento_compra_detalle.cantidad, documento_compra_detalle.precio
            from categoria_producto inner join producto on categoria_producto.id_categoria = producto.id_categoria_prod
            inner join unidad_medida on producto.id_uni_med_prod = unidad_medida.id_uni_med
            inner join documento_compra_detalle on producto.codigo_producto = documento_compra_detalle.codigo_producto_doc_det
            inner join documento_compra on documento_compra.numero_doc = documento_compra_detalle.numero_doc_det 
            inner join proveedor on documento_compra.id_proveedor_doc = proveedor.id_proveedor
            and documento_compra.id_proveedor_doc = documento_compra_detalle.id_proveedor_det and documento_compra.tipo_id_doc = documento_compra_detalle.tipo_id_doc_det 
            order by categoria_producto.descripcion_cat asc, producto.nombre_producto asc)
            loop
                idcat := registros.idcat;
                categoria := registros.categoria;
                codigo := registros.codigo;
                articulo := registros.articulo;
                medida := registros.medida;
                stockmin := registros.stockmin;
                stockmax := registros.stockmax;
                numdocto := registros.numdocto;
                idprov := registros.idprov;
                prov := registros.prov;
                fecha := registros.fecha;
                cantidad := registros.cantidad;
                precio := registros.precio;
                return next;
            end loop;
        else
        	opcion := upper('%' || opcion || '%');
            for registros in(select categoria_producto.id_categoria as idcat, categoria_producto.descripcion_cat as categoria, producto.codigo_producto as codigo,
            producto.nombre_producto as articulo, unidad_medida.descripcion_uni_med as medida, producto.stock_minimo as stockmin, producto.stock_maximo as stockmax,
            documento_compra.numero_doc as numdocto, documento_compra.id_proveedor_doc as idprov, proveedor.razon_social as prov, documento_compra.fecha_doc as fecha,
            documento_compra_detalle.cantidad, documento_compra_detalle.precio
            from categoria_producto inner join producto on categoria_producto.id_categoria = producto.id_categoria_prod
            inner join unidad_medida on producto.id_uni_med_prod = unidad_medida.id_uni_med
            inner join documento_compra_detalle on producto.codigo_producto = documento_compra_detalle.codigo_producto_doc_det
            inner join documento_compra on documento_compra.numero_doc = documento_compra_detalle.numero_doc_det 
            inner join proveedor on documento_compra.id_proveedor_doc = proveedor.id_proveedor
            and documento_compra.id_proveedor_doc = documento_compra_detalle.id_proveedor_det and documento_compra.tipo_id_doc = documento_compra_detalle.tipo_id_doc_det 
            where proveedor.razon_social like opcion
            order by categoria_producto.descripcion_cat asc, producto.nombre_producto asc)
            loop
                idcat := registros.idcat;
                categoria := registros.categoria;
                codigo := registros.codigo;
                articulo := registros.articulo;
                medida := registros.medida;
                stockmin := registros.stockmin;
                stockmax := registros.stockmax;
                numdocto := registros.numdocto;
                idprov := registros.idprov;
                prov := registros.prov;
                fecha := registros.fecha;
                cantidad := registros.cantidad;
                precio := registros.precio;
                return next;
            end loop;
        end if;
    end; 
$$ 
language 'plpgsql'; 