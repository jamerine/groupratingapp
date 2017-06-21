class PdfReport < Prawn::Document

  # Often-Used Constants

  TABLE_ROW_COLORS = ["FFFFFF","DDDDDD"]
  TABLE_FONT_SIZE = 9
  TABLE_BORDER_STYLE = :grid

  def initialize(default_prawn_options={})
    super(default_prawn_options)
    font_size 10
  end

  def header(title=nil)
    if [9,10,16].include? @account.representative.id
      image "#{Rails.root}/app/assets/images/minute men hr.jpeg", height: 100
    elsif [2].include? @account.representative.id
      image "#{Rails.root}/app/assets/images/cose_logo.jpg", height: 100
    elsif [17].include? @account.representative.id
      image "#{Rails.root}/app/assets/images/tartan_logo.jpg", height: 100
    else
      image "#{Rails.root}/app/assets/images/logo.png", height: 50
    end
    text "#{ @account.representative.company_name}", size: 18, style: :bold, align: :center
    if title
      text title, size: 14, style: :bold_italic, align: :center
    end
  end

  def footer(account)
    bounding_box([0, 0], :width => bounds.width/3, :height => 10) do
     number_pages "#{account.name.titleize}", { :start_count_at => 0, :page_filter => :all, align: :left, :size => 8 }
    end
    bounding_box([(bounds.width/3), 0], :width => bounds.width/3, :height => 10) do
     number_pages "Page <page> of <total>", { :start_count_at => 0, :page_filter => :all, align: :center, :size => 8 }
    end
    bounding_box([((bounds.width/3)*2), 0], :width => bounds.width/3, :height => 10) do
      number_pages "#{@current_date.strftime("%A, %B %e, %Y")}", { :start_count_at => 0, :page_filter => :all, align: :right, :size => 8 }
    end
  end

  def price(num)
    @view.number_to_currency(num)
  end

  def round(num, prec)
    @view.number_with_precision(num, precision: prec, :delimiter => ',')
  end

  def rate(num, prec)
    if num.nil?
      return nil
    end
    num = num * 100
    @view.number_with_precision(num, precision: prec)
  end

  def percent(num)
    num = num * 100
    @view.number_to_percentage(num, precision: 0)
  end
  # ... More helpers

end
