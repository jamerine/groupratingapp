class MatrixPdfReport < PdfReport
  MATRIX_COLOR = 'CC0001'

  def initialize(default_prawn_options = {})
    super(default_prawn_options)
  end

  def matrix_header(title = true)
    current_cursor = cursor

    if title
      bounding_box([0, current_cursor], width: 350, height: 100) do
        move_down 35
        text "#{@account.representative.quote_year} Group Rating Enrollment", style: :bold, size: 20
        transparent(0) { stroke_bounds }
      end
    end

    bounding_box([bounds.right - 115, current_cursor], width: 115, height: 100) do
      matrix_logo
      transparent(0) { stroke_bounds }
    end
  end

  def matrix_logo
    if Rails.env.development?
      image open('public/' + @representative.logo_url), height: 100, width: 115
    else
      image open(@representative.logo_url), height: 100, width: 115
    end
  end

  def inline_text(text, additional_options = [])
    options            = { size: 12, inline_format: true }
    additional_options = additional_options.any? ? additional_options.merge(options) : options
    text text, additional_options
  end

  def agreement_text(text, additional_options = [])
    options            = { size: 8.5, inline_format: true }
    additional_options = additional_options.any? ? additional_options.merge(options) : options
    text text, additional_options
  end

  def faq_text(text, additional_options = [])
    options            = { size: 10, inline_format: true }
    additional_options = additional_options.any? ? additional_options.merge(options) : options
    text text, additional_options
  end

  def matrix_footer
    bounding_box([0, 0], width: 375, height: 50) do
      transparent 0.55 do
        text @representative.phone_number.split('.').join(' ') +
               "   <color rgb='#{MATRIX_COLOR}'>|</color>   " +
               @representative.full_location_address +
               "   <color rgb='#{MATRIX_COLOR}'>|</color>   www.matrixpa.com", size: 8, inline_format: true
      end

      transparent(0) { stroke_bounds }
    end

    bounding_box([bounds.right - 150, 20], width: 150, height: 50) do
      if Rails.env.development?
        image open('public/' + @representative.footer.url), width: 150
      else
        image open(@representative.footer.url), width: 150
      end

      transparent(0) { stroke_bounds }
    end
  end

  def bullet_list(items, use_faq_text = false)
    start_new_page if cursor < 50
    items.each do |item|
      text_box "•", at: [15, cursor], size: 20
      move_down 2.5
      indent(35) do
        use_faq_text ? faq_text(item) : inline_text(item)
      end
    end
  end

  def arrowhead_list(items)
    items.each do |item|
      image("#{Rails.root}/app/assets/images/arrowhead.png", height: 8, at: [15, cursor])
      move_down 0.5
      indent(35) do
        agreement_text item
      end
    end
  end

  def signature_image
    if Rails.env.development?
      image open('public/' + @representative.signature.url), height: 50
    else
      image open(@representative.signature.url), height: 50
    end
  end
end
