class RecipePdf < Prawn::Document
  def initialize(recipe)
    super(top_margin: 70)
    @recipe = recipe
    info_recipe
    line_items
    detalles_item
  end

  def info_recipe
    text "Venta", size: 25, style: :bold, :align => :center

  end



  def line_items
    move_down 20
    table [["Ruta", "Cliente", "Responsable", "Nombre Comercial", "Folio"],[@venta.ruta.try(:Ruta), @venta.try(:CodCliente), @venta.try(:cliente).try(:Nombre), @venta.try(:cliente).try(:NombreCorto), @venta.try(:Documento)]], :cell_style => { :font => "Helvetica", :size => 9, :border_width => 0.5, :borders => [:top, :bottom], :border_color => "B0B0B0", :text_color => "737373"} do
      row(0).font_style = :bold
      columns(1..3).align = :center
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end



  def detalles_item
    move_down 20
    table detalles_item_rows, :cell_style => { :font => "Helvetica", :size => 9, :border_width => 0.5, :borders => [:top, :bottom], :border_color => "B0B0B0", :text_color => "737373"}  do
      row(0).font_style = :bold
      columns(1..3).align = :center
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def detalles_item_rows
    [["Sku", "Producto", "Unidad", "Cantidad", "Precio unitario", "Subtotal", "IVA", "Descuento", "Total"]] +
     @detalles.map do |detalleve|
      [detalleve.try(:Articulo), detalleve.try(:Descripcion), if detalleve.Tipo == 0 then "Cajas" else "piezas" end, detalleve.try(:Pza), (detalleve.Precio / ((detalleve.producto.IVA.to_f/100)+1)).to_d.truncate(2).to_f,
       detalleve.try(:Importe),detalleve.try(:IVA), detalleve.try(:DescMon), (detalleve.try(:Importe) + detalleve.try(:IVA)) - detalleve.try(:DescMon)]
    end
  end





end
