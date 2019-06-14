class StoredProceduresController < ApplicationController
  before_action :authenticate_usuario!
  before_action :permiso_listar, only: [:comisiones, :cantidad_productosxpedido, :monitoreo_de_precios, :liquidaciones, :reporte_consolidado_de_carga, :reporte_consolidado_piezas, :consentrado_pedido_del_dia_siguiente, :reporte_consolidado_de_envases, :reporte_liquidacion]

  def modulo
    if action_name == "comisiones"
      @Descripcion_Modulo = "Reporte de comisiones"
    elsif action_name == "cantidad_productosxpedido"
      @Descripcion_Modulo = "Reporte de cantidad productos por pedido"
    elsif action_name == "monitoreo_de_precios"
      @Descripcion_Modulo = "Reporte de monitoreo de precios"
    elsif action_name == "liquidaciones"
      @Descripcion_Modulo = "Reporte de liquidación"
    elsif action_name == "reporte_consolidado_de_carga"
      @Descripcion_Modulo = "Reporte consolidado de carga"
    elsif action_name == "reporte_consolidado_piezas"
      @Descripcion_Modulo = "Reporte de consolidado piezas"
    elsif action_name == "consentrado_pedido_del_dia_siguiente"
      @Descripcion_Modulo = "Reporte consolidado pedido del día siguiente"
    elsif action_name == "reporte_consolidado_de_envases"
      @Descripcion_Modulo = "Reporte consolidado de envases"
    elsif action_name == "reporte_liquidacion"
      @Descripcion_Modulo = "Reporte de Liquidación 2"
    end
  end

  def reporte_liquidacion_concentrado_detalles
    params[:search6] = current_usuario.empresa_id
    elementos_de_busqueda_ruta_autocompletar

    @rep_liq_con_contado = Pedidoliberado.rep_liq_con_contado(params).sum("DP.Importe + DP.Iva").to_f.round(2)
    @rep_liq_con_credito = Pedidoliberado.rep_liq_con_credito(params).sum("DP.Importe + DP.Iva").to_f.round(2)
    @rep_liq_ObsequioCajas = Pedidoliberado.rep_liq_ObsequioCajas(params).sum("DV.Pza * P.VBase").to_f.round(2)
    @rep_liq_ObsequioPiezas = Pedidoliberado.rep_liq_ObsequioPiezas(params).sum("(DV.Pza * P.VBase)/PxP.PzaXCja").to_f.round(2)
    @rep_liq_Descuento = Pedidoliberado.rep_liq_Descuento(params).sum("DV.DESCUENTO * ((CONVERT(FLOAT,(P.IVA))/100)+1)").to_f.round(2)

  	@estadistica_venta = Vent.estadisticas_liquidacion_concentrado(params)
    @liquidacion_productos = Stored_procedure.fetch_db_records("exec SPAD_ReporteLiquidaciones '#{(params[:fechaDiaO].try(:to_date)).try(:strftime,"%Y-%m-%d")}','#{((params[:fechaDiaO].try(:to_date))+1.day).try(:strftime,"%Y-%m-%d")}','#{params[:search]}','#{params[:search6]}', '#{params[:diaO]}'")
    @monto_entregas = Pedidoliberado.reportes_monto_entregas(params)
  	respond_to do |format|
  		format.js
      format.xls
  	end
  end

  def reporte_liquidacion_concentrado
    @controlador = 'stored_procedures'
    @accion = 'reporte_liquidacion_concentrado'
    elementos_de_busqueda_dia
    @pathDeBusqueda = reporte_liquidacion_concentrado_path
    respond_to do |format|
      format.html
      format.js
      format.xls
    end
  end

  def comisiones
    @controlador = 'stored_procedures'
    @accion = 'comisiones'
    elementos_de_busqueda
    @pathDeBusqueda = stored_procedures_comisiones_path
    @comisiones = Stored_procedure.fetch_db_records("exec SPAD_ReporteComisiones '#{params[:search]}','#{(params[:search4].try(:to_date).try(:beginning_of_day)).try(:strftime,"%Y-%m-%d %T")}','#{(params[:search5].try(:to_date).try(:end_of_day)).try(:strftime,"%Y-%m-%d %T")}','#{params[:search6]}'")
    @venta = @comisiones.sum { |h| h['Importe'] }
  #  @cajas = @comisiones.select{| hash| hash["Tipo"] == "Cajas" }.sum { |h| h['Cantidad']}
  #  @piezas = @comisiones.select{| hash| hash["Tipo"] == "Piezas" }.sum{ |h| h['Cantidad']}
    @piezas = @comisiones.sum{ |h| h['Cantidad']}
    @comision_vendedor = @comisiones.sum { |h| h['ComisionVendedor'] }
    @Ayudante1 = @comisiones.sum { |h| h['ComisionAyudante1'] }
    @Ayudante2 = @comisiones.sum { |h| h['ComisionAyudante2'] }
    respond_to do |format|
      format.html
      format.js
      format.xls
    end
  end

  def elementos_de_busqueda
    params[:search6] = current_usuario.empresa_id
    elementos_de_busqueda_ruta_autocompletar
    @searchRutaB = Ruta.por_empresa(current_usuario.empresa_id).search(search_params)
    # make name the default sort column
    @searchRutaB.sorts = 'IdRutas' if @searchRutaB.sorts.empty?
    @rutas_Selector = @searchRutaB.result().page(params[:rutas])
  end

  def elementos_de_busqueda_dia
    params[:search6] = current_usuario.empresa_id
    elementos_de_busqueda_ruta_autocompletar
    @searchRutaB = Ruta.por_empresa(current_usuario.empresa_id).search(search_params)
    # make name the default sort column
    @searchRutaB.sorts = 'IdRutas' if @searchRutaB.sorts.empty?
    @rutas_Selector = @searchRutaB.result().page(params[:rutas])

    @searchDiaOpB = Diaop.selector_dia_operativo(params).search(search_params)
    @searchDiaOpB.sorts = 'DiaO DESC' if @searchDiaOpB.sorts.empty?
    @DiasOp_Selector = @searchDiaOpB.result().page(params[:DiasOp])
    @vendedores = Relvendruta.por_ruta(params[:ruta])

  end

  def pdf
    params[:search6] = current_usuario.empresa_id

    @comisiones = Stored_procedure.fetch_db_records("exec SPAD_ReporteComisiones '#{params[:search]}','#{(params[:search4].try(:to_date).try(:beginning_of_day)).try(:strftime,"%Y-%m-%d %T")}','#{(params[:search5].try(:to_date).try(:end_of_day)).try(:strftime,"%Y-%m-%d %T")}','#{params[:search6]}'")
    @comision = @comisiones.select{| hash| hash["Fecha"] == params[:F] }.select{| hash| hash["Articulo"] == params[:A] }.select{| hash| hash["ClaveVend"] == params[:v] }

    #@venta = Vent.busqueda_general(params).find_by_Id(params[:V])
    #@detalles = Detalleve.por_ruta(@venta.try(:RutaId)).por_documento(@venta.try(:Documento))
    respond_to do |format|
        format.html
        format.pdf do
          pdf = ComisionPdf.new(@comision)
          send_data pdf.render, filename: "Comision.pdf",
                                type: "application/pdf",
                                disposition: "inline"
        end
    end
  end


  def productos_x_pedido_consolidado_pdf
    params[:search6] = current_usuario.empresa_id
    @pedidos_consolidados = Stored_procedure.fetch_db_records("exec SPAD_ReporteProductosxPedidoResumen '#{Date.parse(params[:Fecha]).strftime("%Y-%m-%d")}','#{params[:search]}','#{params[:Status]}','#{params[:search6]}'")
    @cantidad_productosxpedido = Stored_procedure.fetch_db_records("exec SPAD_ReporteProductosxPedido '#{Date.parse(params[:Fecha]).strftime("%Y-%m-%d")}','#{params[:search]}','#{params[:Status]}','#{params[:search6]}'").first
    @tiket = Tiket.find_by_IdEmpresa(current_usuario.empresa_id)
    @empresa = current_usuario.empresamadre.Empresa
    respond_to do |format|
        format.html
        format.pdf do
          pdf = ProductosXPedidoConsolidadoPdf.new(@pedidos_consolidados, @tiket, @cantidad_productosxpedido, @empresa)
          send_data pdf.render, filename: "Productos_x_pedido_consolidado.pdf",
                                type: "application/pdf",
                                disposition: "inline"
        end
    end
  end


  def cantidad_productosxpedido
    @controlador = 'stored_procedures'
    @accion = 'cantidad_productosxpedido'
    elementos_de_busqueda
  #  @cantidad_productosxpedido = Stored_procedure.fetch_db_records("exec SPAD_ReporteProductosxPedido '20171020',7,'108'")
    if params[:search] != nil
      @cantidad_productosxpedido = Stored_procedure.fetch_db_records("exec SPAD_ReporteProductosxPedido '#{Date.parse(params[:Fecha]).strftime("%Y-%m-%d")}','#{params[:search]}','#{params[:Status]}','#{params[:search6]}'")
    #  @cantidad_productosxpedido = Stored_procedure.fetch_db_records("exec SPAD_ReporteProductosxPedido '20171020',7,'108'")
    #  @cantidad_productosxpedido = Stored_procedure.fetch_db_records("exec SPAD_ReporteProductosxPedido '20171020',7,'108'")Time.current.beginning_of_day-1.day
      @pedidos_consolidados = Stored_procedure.fetch_db_records("exec SPAD_ReporteProductosxPedidoResumen '#{Date.parse(params[:Fecha]).strftime("%Y-%m-%d")}','#{params[:search]}','#{params[:Status]}','#{params[:search6]}'")
      @etiquetas = Stored_procedure.fetch_db_records("exec SPAD_ReporteProdxPedEtiquetas '#{Date.parse(params[:Fecha]).strftime("%Y-%m-%d")}','#{params[:search]}','#{params[:Status]}','#{params[:search6]}'")

    end
    respond_to do |format|
      format.html
      format.js
      format.xls
    end
  end


  def pedidos_ruta_impresion_etiquetas_pdf
    params[:search6] = current_usuario.empresa_id
    @empresa = current_usuario.empresamadre.Empresa
    @pedidos = Stored_procedure.fetch_db_records("exec SPAD_ReporteProdxPedEtiquetas '#{Date.parse(params[:fecha]).strftime("%Y-%m-%d")}','#{params[:ruta]}','#{params[:status]}','#{params[:search6]}'")
    @etiquetas_para_imprimir = params[:lista_etiquetas]

    respond_to do |format|
        format.pdf do
          pdf = PedidosRutaImpresionEtiquetasPdf.new(@empresa,@etiquetas_para_imprimir,@pedidos)
          send_data pdf.render, filename: "Pedidos_ruta_impresion_etiquetas.pdf",
                                type: "application/pdf",
                                disposition: "inline"



        end
    end
  end


  def cantidad_productosxpedido_consolidado
    @controlador = 'stored_procedures'
    @accion = 'cantidad_productos_x_pedido_consolidar'
    elementos_de_busqueda
    if params[:search] != nil
      @pedidos_consolidados = Stored_procedure.fetch_db_records("exec SPAD_ReporteProductosxPedidoResumen '#{Date.parse(params[:Fecha]).strftime("%Y-%m-%d")}','#{params[:search]}','#{params[:Status]}','#{params[:search6]}'")
    end
    respond_to do |format|
      format.js
      format.xls
    end
  end

  def monitoreo_de_precios
    @controlador = 'stored_procedures'
    @accion = 'monitoreo_de_precios'
    elementos_de_busqueda
    if params[:search] != nil
      @monitoreo_de_precios = Stored_procedure.fetch_db_records("exec SPAD_ReporteEncuestas '#{params[:search]}','#{(params[:search4].try(:to_date)).try(:strftime,"%Y-%m-%d")}','#{((params[:search5].try(:to_date))+1.day).try(:strftime,"%Y-%m-%d")}','#{params[:search6]}'")
    end
    respond_to do |format|
      format.html
      format.js
      format.xls
    end
  end

  def liquidaciones
    @controlador = 'stored_procedures'
    @accion = 'liquidaciones'
    @pathDeBusqueda = liquidaciones_path
    elementos_de_busqueda_dia
    if params[:search] != nil && params[:fechaDiaO] != nil
      @liquidacion_productos = Stored_procedure.fetch_db_records("exec SPAD_ReporteLiquidaciones '#{(params[:fechaDiaO].try(:to_date)).try(:strftime,"%Y-%m-%d")}','#{((params[:fechaDiaO].try(:to_date))+1.day).try(:strftime,"%Y-%m-%d")}','#{params[:search]}','#{params[:search6]}', '#{params[:diaO]}'")
      @liquidacion_envases = Stored_procedure.fetch_db_records("exec SPAD_ReporteLiquidaciones_Envases '#{(params[:fechaDiaO].try(:to_date)).try(:strftime,"%Y-%m-%d")}','#{((params[:fechaDiaO].try(:to_date))+1.day).try(:strftime,"%Y-%m-%d")}','#{params[:search]}','#{params[:search6]}', '#{params[:diaO]}'")
      @liquidacion_ventas_contado = Vent.rep_liquidaciones_tabla_contado(params)
      @liquidacion_ventas_credito = Vent.rep_liquidaciones_tabla_credito(params)
    end
    respond_to do |format|
      format.html
      format.js
      format.xls
    end
  end

  def reporte_consolidado_de_carga
    params[:search6] = current_usuario.empresa_id
    if params[:Fecha] != nil
      @reporte_consolidado_de_carga = Stored_procedure.fetch_db_records("exec SPAD_ReporteCargaConcentradoOldFormat '#{(params[:Fecha].try(:to_date)).try(:strftime,"%Y-%m-%d")}','#{params[:search6]}'")
    end
    respond_to do |format|
      format.html
      format.js
      format.xls
    end
  end

  def reporte_consolidado_piezas
    params[:search6] = current_usuario.empresa_id
    if params[:Fecha] != nil
      @reporte_consolidado_piezas = Stored_procedure.fetch_db_records("exec SPAD_ReporteConcentradoDSP '#{(params[:Fecha].try(:to_date)).try(:strftime,"%Y-%m-%d")}','#{params[:search6]}'")
    end
    respond_to do |format|
      format.html
      format.js
      format.xls
    end
  end

  def consentrado_pedido_del_dia_siguiente
    params[:search6] = current_usuario.empresa_id
    if params[:Fecha] != nil
      @consentrado_pedido_del_dia_siguiente = Stored_procedure.fetch_db_records("exec SPAD_ReporteConcentradoDS '#{(params[:Fecha].try(:to_date)).try(:strftime,"%Y-%m-%d")}','#{params[:search6]}'")
    end
    respond_to do |format|
      format.html
      format.js
      format.xls
    end
  end

  def reporte_consolidado_de_envases
    @controlador = 'stored_procedures'
    @accion = 'reporte_consolidado_de_envases'
    elementos_de_busqueda
    if params[:Tipo_Env] == "Promocion"
      @reporte_consolidado_de_envases = Stored_procedure.fetch_db_records("exec SPAD_ConcentradoEnvasesPromo '#{(params[:search4].try(:to_date)).try(:strftime,"%Y-%m-%d")}','#{((params[:search5].try(:to_date))+1.day).try(:strftime,"%Y-%m-%d")}','#{params[:search]}','#{params[:search6]}'")
    elsif params[:Tipo_Env] == "Comodato"
      @reporte_consolidado_de_envases = Stored_procedure.fetch_db_records("exec SPAD_ConcentradoEnvasesComodato '#{(params[:search4].try(:to_date)).try(:strftime,"%Y-%m-%d")}','#{((params[:search5].try(:to_date))+1.day).try(:strftime,"%Y-%m-%d")}','#{params[:search]}','#{params[:search6]}'")
    end
    respond_to do |format|
      format.html
      format.js
      format.xls
    end
  end


end
