class RecipePdf < Prawn::Document
  def initialize(recipe)
    super(top_margin: 70)
    @recipe = recipe
    info_receta
    detalle_receta
    ingredientes
    preparacion
    acerca_de
  end

  def info_receta
    text "#{@recipe.name}", size: 25, style: :bold, :align => :center

  end



  def detalle_receta
    id_sample = open("#{@recipe.foto.path(:thumb)}")
    image id_sample, at: [280,590], height: 161, width: 250
    move_down 20
  end

  def ingredientes
    text "Ingredientes:", size: 15, style: :bold, :align => :left
    move_down 20
    indent(10, 10) do # left and right padding

     @recipe.ingredients.map do |ingrediente|
      text "• #{ingrediente.try(:name)}", size: 10, left_margin: 500
     end
    end
    move_down 20
  end

  def preparacion
    move_down 130
    text "Preparación:", size: 15, style: :bold, :align => :left
    move_down 20
    indent(40, 10) do # left and right padding
      text "#{@recipe.try(:body)}", size: 10, left_margin: 500
    end
    move_down 20
  end

  def acerca_de
    move_down 40
    text "Acerca de:", size: 15, style: :bold, :align => :left
    move_down 20
    indent(40, 10) do # left and right padding
      text "Autor: #{@recipe.user.try(:name)} #{@recipe.user.try(:last_name)}", size: 10, left_margin: 500
      text "Fecha: #{@recipe.try(:created_at).strftime("%d-%m-%Y")}", size: 10, left_margin: 500
    end
    move_down 20
  end







end
