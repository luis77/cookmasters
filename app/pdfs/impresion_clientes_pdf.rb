class ImpresionClientesPdf < Prawn::Document
  def initialize(empresa,tiket,lista)
    super(top_margin: 70,:page_size => [143, 71])
    @empresa = empresa
    @tiket = tiket
    @clientes = lista
    info_Cliente
  end

  def logo
    pigs = "#{Rails.root}/app/assets/images/#{@empresa}_ticket.jpg"
    image pigs, :at => [-33,15], :width => 40
    pigs
  end

  def info_Cliente
    clientes
  end



  def clientes
    @clientes_length = @clientes.length - 1
    @clientes.each_with_index do |(c, cliente_id), i|
      logo
      draw_text "#{Cliente.find_by(IdCli: cliente_id).try(:NombreCorto)}", :at => [0,22], :size => 5, :style => :bold
      cliente_id = image open("https://barcode.tec-it.com/barcode.ashx?data=#{cliente_id}&code=Code128&multiplebarcodes=false&translate-esc=false&unit=Fit&dpi=96&imagetype=PNG&rotation=0&color=%23000000&bgcolor=%23ffffff&qunit=Mm&quiet=0"), width: 60, height: 40, :at => [30,17]
  #      move_down 20
      start_new_page unless i == @clientes_length
    end
  end



end
