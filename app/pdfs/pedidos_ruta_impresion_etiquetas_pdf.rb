class PedidosRutaImpresionEtiquetasPdf < Prawn::Document
  def initialize(empresa,etiquetas_para_imprimir,pedidos)
    super(top_margin: 70,:page_size => [143, 71])
    @empresa = empresa
    @etiquetas_para_imprimir = etiquetas_para_imprimir
    @pedidos = pedidos
    info_pedido
  end

  def logo
    pigs = "#{Rails.root}/app/assets/images/#{@empresa}_ticket.jpg"
    image pigs, :at => [75,33], :width => 30
    pigs
  end

  def info_pedido
    pedidos
  end


  def pedidos
    @etiquetas_para_imprimir_length = @etiquetas_para_imprimir.length - 1
    @etiquetas_para_imprimir.each_with_index do |(pedido,producto),i|
        @pedidos.to_a.each do |ped|
          if ped['Pedido'] == (pedido.dup.sub!(%r{_#{producto}},"")) and ped['Articulo'] == producto

            for indice in 1..ped['Cajas']
              logo
              draw_text "#{ped['Pedido']}", :at => [-29,28], :size => 5, :style => :bold
              draw_text "#{ped['Cliente']}", :at => [-29,10], :size => 5, :style => :bold
              draw_text "#{ped['Nombre']}", :at => [-29,0], :size => 5, :style => :bold
              draw_text "#{ped['Articulo']}", :at => [-29,-10], :size => 5, :style => :bold
              draw_text "#{ped['Descripcion']}", :at => [-29,-22], :size => 5, :style => :bold
              draw_text "1 Caja", :at => [75,-30], :size => 5, :style => :bold
               if indice < ped['Cajas'] then
                start_new_page
               elsif indice == ped['Cajas'] and ped['Piezas'] > 0
                 start_new_page
               end
            end

            if ped['Piezas'] > 0
              logo
              draw_text "#{ped['Pedido']}", :at => [-29,28], :size => 5, :style => :bold
              draw_text "#{ped['Cliente']}", :at => [-29,10], :size => 5, :style => :bold
              draw_text "#{ped['Nombre']}", :at => [-29,0], :size => 5, :style => :bold
              draw_text "#{ped['Articulo']}", :at => [-29,-10], :size => 5, :style => :bold
              draw_text "#{ped['Descripcion']}", :at => [-29,-22], :size => 5, :style => :bold
              draw_text "#{ped['Piezas']} Piezas", :at => [75,-30], :size => 5, :style => :bold
            end

          end
        end
        start_new_page unless i == @etiquetas_para_imprimir_length
    end
  end



end
