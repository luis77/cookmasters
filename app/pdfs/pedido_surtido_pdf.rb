class PedidoSurtidoPdf < Prawn::Document
  def initialize(pedido,detalles)
    super(top_margin: 70)
    @pedido = pedido
    @detalles = detalles
    info_pedido
    line_items
    detalles_item
  end

  def info_pedido
    text "PEDIDO POR SURTIR", size: 25, style: :bold, :align => :center
  end

  def line_items
    move_down 20
    table line_item_rows do
      row(0).font_style = :bold
      columns(1..3).align = :center
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def line_item_rows
    [["RUTA", "PEDIDO O FOLIO CONSOLIDADO"]] +
     @pedido.map do |pedido|
      [pedido.ruta.try(:Ruta), pedido.try(:Pedido)]
    end
  end



  def detalles_item
    move_down 20
    table detalles_item_rows do
      row(0).font_style = :bold
      columns(1..3).align = :center
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def detalles_item_rows
    [["Articulo", "Cantidad"]] +
     @detalles.map do |detalle|
      [detalle.try(:articulo), detalle.try(:CANTIDAD)]
    end
  end

end
