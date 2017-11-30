/*==============================================================================*/
/* SP		: Consulta los productos clasificados por categoría.				*/
/* Tablas	: categoria_producto, producto y unidad_medida.						*/
/*==============================================================================*/
/* Parametros de entrada.														*/
/*==============================================================================*/
/* opcion: texto opcional, si no se indica entrega todos los resultados.		*/
/*==============================================================================*/
create or replace function SP_ProductosClasificadosPorCategoria(IN opcion varchar(255) default 'todo') 
returns table(idcat int, categoria varchar(255), codigo bigint, articulo varchar(255), medida varchar(6), stockmin float, stockmax float)
as 
$$ 
declare 
	registros record;
    begin 
    	if opcion='todo' then
            for registros in(select categoria_producto.id_categoria as idcat, categoria_producto.descripcion_cat as categoria, producto.codigo_producto as codigo,
            producto.nombre_producto as articulo, unidad_medida.descripcion_uni_med as medida, producto.stock_minimo as stockmin, producto.stock_maximo as stockmax
            from categoria_producto inner join producto on categoria_producto.id_categoria = producto.id_categoria_prod
            inner join unidad_medida on producto.id_uni_med_prod = unidad_medida.id_uni_med
            order by categoria_producto.descripcion_cat asc, producto.nombre_producto asc)
            loop
                idcat := registros.idcat;
                categoria := registros.categoria;
                codigo := registros.codigo;
                articulo := registros.articulo;
                medida := registros.medida;
                stockmin := registros.stockmin;
                stockmax := registros.stockmax;
                return next;
            end loop;
        else
        	opcion := upper('%' || opcion || '%');
            for registros in(select categoria_producto.id_categoria as idcat, categoria_producto.descripcion_cat as categoria, producto.codigo_producto as codigo,
            producto.nombre_producto as articulo, unidad_medida.descripcion_uni_med as medida, producto.stock_minimo as stockmin, producto.stock_maximo as stockmax
            from categoria_producto inner join producto on categoria_producto.id_categoria = producto.id_categoria_prod
            inner join unidad_medida on producto.id_uni_med_prod = unidad_medida.id_uni_med
            where categoria_producto.descripcion_cat like opcion
            order by categoria_producto.descripcion_cat asc, producto.nombre_producto asc)
            loop
                idcat := registros.idcat;
                categoria := registros.categoria;
                codigo := registros.codigo;
                articulo := registros.articulo;
                medida := registros.medida;
                stockmin := registros.stockmin;
                stockmax := registros.stockmax;
                return next;
            end loop;
        end if;
    end; 
$$ 
language 'plpgsql'; 