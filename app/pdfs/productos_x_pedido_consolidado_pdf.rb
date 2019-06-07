class ProductosXPedidoConsolidadoPdf < Prawn::Document
  def initialize(producto, tiket, cpp, empresa)
    super(top_margin: 70)
    @producto = producto
    @tiket = tiket
    @empresa = empresa
    @cpp = cpp
    info_pedido
    line_items
    firma_vendedor
  end

  def info_pedido
    text "CONSOLIDADO DE PEDIDOS", size: 15, style: :bold, :align => :center
    move_down 20
    imagenes  
    indent(40, 10) do # left and right padding
      text "#{@tiket.try(:Linea1)}", size: 10, left_margin: 500
      text "#{@tiket.try(:Linea2)}", size: 10, :align => :left
      text "#{@tiket.try(:Linea3)}", size: 10, :align => :left
      text "#{@tiket.try(:Linea4)}", size: 10, :align => :left
    end

    move_down 20
    text "Ruta: #{@cpp['Ruta']}", size: 10, :align => :left
    text "Fecha de entrega: #{@cpp['Fecha Entrega']}", size: 10, :align => :right

                                 
  end

  def line_items
    move_down 10
    table line_item_rows, :cell_style => { :font => "Helvetica", :size => 10, :border_width => 0.5, :borders => [:top, :bottom], :border_color => "B0B0B0", :text_color => "737373"} do
      row(0).font_style = :bold
      style row(0), :font_size => 27
      columns(1..5).align = :center
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end


  end

  def line_item_rows
    [["Producto Generico", "Cajas Pedido", "Cajas Promo", "Piezas", "Total Cajas", "Total Piezas"]] +
     @producto.map do |producto|
      [producto['Producto Generico'], producto['Cajas Pedido'], producto['Cajas Promo'], producto['Piezas'], producto['Total Cajas'], producto['Total Piezas']]
    end
  end


  def firma_vendedor
    move_down 30
    #stroke_horizontal_line(170, 350, at: 200)
    stroke_horizontal_line(170, 370)
    move_down 5
    text "#{@cpp['Vendedor']}", size: 12, style: :bold, :align => :center
  end

  def imagenes
    pigs = "#{Rails.root}/app/assets/images/#{@empresa}.jpeg" 
    image pigs, :at => [-15,680], :width => 50  
    pigs   
  end


end



