class SpbarController < ApplicationController
  def SP_BuscarContactosProveedor
    @consulta = "select * from sp_buscarcontactosproveedor('"+params[:nombre]+"')"
    @registro = ActiveRecord::Base.connection.execute(@consulta)
    render json: @registro
  end

  def SP_CantidadProveedoresPorComuna
    @consulta = "select * from sp_cantidadproveedoresporcomuna('"+params[:comuna]+"')"
    @registro = ActiveRecord::Base.connection.execute(@consulta)
    render json: @registro
  end

  def SP_CantidadProveedorPorGiro
    @consulta = "select * from SP_CantidadProveedorPorGiro('"+params[:giro]+"')"
    @registro = ActiveRecord::Base.connection.execute(@consulta)
    render json: @registro
  end

  def SP_CompraPromedioAnualPorProveedor
    @consulta = "select * from sp_comprapromedioanualporproveedor('"+params[:yyyy]+"')"
    @registro = ActiveRecord::Base.connection.execute(@consulta)
    render json: @registro
  end

  def SP_CompraPromedioMensualPorProveedor
    @consulta = "select * from sp_comprapromediomensualporproveedor('"+params[:mes]+"','"+params[:yyyy]+"')"
    @registro = ActiveRecord::Base.connection.execute(@consulta)
    render json: @registro
  end

  def SP_DocumentosVencidos
    @consulta = "select * from sp_documentosvencidos('"+params[:fecha]+"')"
    @registro = ActiveRecord::Base.connection.execute(@consulta)
    render json: @registro
  end

  def SP_DocumentosVencidosPorMes
    @consulta = "select * from sp_documentosvencidospormes('"+params[:mes]+"','"+params[:yyyy]+"')"
    @registro = ActiveRecord::Base.connection.execute(@consulta)
    render json: @registro
  end

  def SP_LibroComprasMensual
    @consulta = "select * from sp_librocomprasmensual('"+params[:mes]+"','"+params[:yyyy]+"')"
    @registro = ActiveRecord::Base.connection.execute(@consulta)
    render json: @registro
  end

  def SP_PrecioPromedioProductosPorMes
    @consulta = "select * from sp_preciopromedioproductospormes('"+params[:mes]+"','"+params[:yyyy]+"')"
    @registro = ActiveRecord::Base.connection.execute(@consulta)
    render json: @registro
  end

  def SP_ProductoMasComprado
    @consulta = "select * from sp_productomascomprado('"+params[:inicio]+"','"+params[:final]+"')"
    @registro = ActiveRecord::Base.connection.execute(@consulta)
    render json: @registro
  end
  def SP_ProductosClasificadosPorCategoria
    @consulta = "select * from sp_productosclasificadosporcategoria('"+params[:categ]+"')"
    @registro = ActiveRecord::Base.connection.execute(@consulta)
    render json: @registro
  end

  def SP_ProductosCompradosPorMes
    @consulta = "select * from sp_productoscompradospormes('"+params[:mes]+"','"+params[:yyyy]+"')"
    @registro = ActiveRecord::Base.connection.execute(@consulta)
    render json: @registro
  end

  def SP_ProductosCompradosPorProveedor
    @consulta = "select * from sp_productoscompradosporproveedor('"+params[:proveedor]+"')"
    @registro = ActiveRecord::Base.connection.execute(@consulta)
    render json: @registro
  end

  def SP_ProveedorMasComprado
    @consulta = "select * from sp_proveedormascomprado('"+params[:inicio]+"','"+params[:final]+"')"
    @registro = ActiveRecord::Base.connection.execute(@consulta)
    render json: @registro
  end
end
