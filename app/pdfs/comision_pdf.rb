class ComisionPdf < Prawn::Document
  def initialize(comision)
    super(top_margin: 70)
    @comision = comision
    info_comision
    comision_item
    comision_continuacion_item
    comision_continuacion2_item
    comision_continuacion3_item
  end

  def info_comision
    text "Comisión", size: 25, style: :bold, :align => :center
  end

  def comision_item
    move_down 20
    table comision_item_rows, :cell_style => { :font => "Helvetica", :size => 9, :border_width => 0.5, :borders => [:top, :bottom], :border_color => "B0B0B0", :text_color => "737373"}  do
      row(0).font_style = :bold
      columns(1..3).align = :center
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end


  def comision_item_rows
    [["Fecha", "Articulo", "Nombre", "CantidadPzas", "PrecioUnitario", "Importe"]] +
     @comision.map do |comision|
      [comision['Fecha'].try(:strftime,"%d-%m-%Y"), comision['Articulo'], comision['NombreArticulo'], comision['Cantidad'], comision['PrecioUnitario'], comision['Importe']]
    end
  end

  def comision_continuacion_item
    move_down 20
    table comision_item_rows2, :cell_style => { :font => "Helvetica", :size => 9, :border_width => 0.5, :borders => [:top, :bottom], :border_color => "B0B0B0", :text_color => "737373"}  do
      row(0).font_style = :bold
      columns(1..3).align = :center
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def comision_item_rows2
    [["Clave", "Vendedor", "Comisión", "Comisión vendedor"]] +
     @comision.map do |comision|
      [comision['ClaveVend'], comision['Vendedor'], comision['PorcVend'], comision['ComisionVendedor']]
    end
  end

  def comision_continuacion2_item
    move_down 20
    table comision_item_rows2, :cell_style => { :font => "Helvetica", :size => 9, :border_width => 0.5, :borders => [:top, :bottom], :border_color => "B0B0B0", :text_color => "737373"}  do
      row(0).font_style = :bold
      columns(1..3).align = :center
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def comision_item_rows2
    [["Clave", "Ayudante1", "Porc", "Comisión", "Clave", "Ayudante2", "Porc", "Comisión"]] +
     @comision.map do |comision|
      [comision['ClaveAyud1'], comision['NombreAyudante1'], comision['PorcAyud1'], comision['ComisionAyudante1'], comision['ClaveAyud2'], comision['NombreAyudante2'], comision['PorcAyud2'], comision['ComisionAyudante2']]
    end
  end

  def comision_continuacion3_item
    move_down 20
    table comision_item_rows3, :cell_style => { :font => "Helvetica", :size => 9, :border_width => 0.5, :borders => [:top, :bottom], :border_color => "B0B0B0", :text_color => "737373"}  do
      row(0).font_style = :bold
      columns(1..3).align = :center
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def comision_item_rows3
    [["Notas"]] +
     @comision.map do |comision|
      [comision['Notas']]
    end
  end











end
