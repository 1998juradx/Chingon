require "prawn/table"

class DebtReportPdf
  include Prawn::View

  def initialize(debt)
    @debt = debt
    @client = debt.client
    @payments = debt.payments.order(due_at: :asc)
    @document = Prawn::Document.new(page_size: 'A4', margin: 40)
    generate_report
  end

  def render
    @document.render
  end

  private

  def generate_report
    generate_header(pdf)
    pdf.move_down 20
    generate_client_info(pdf)
    pdf.move_down 15
    generate_summary_note(pdf)
    pdf.move_down 15
    generate_payments_table(pdf)
    pdf.move_down 20
    generate_totals(pdf)
    pdf.move_down 40
    generate_footer(pdf)
  end

  def generate_header(pdf)
    logo_path = "#{Rails.root}/app/assets/images/rocasol_logo.png"

    pdf.y_position = pdf.cursor
    if File.exist?(logo_path)
      pdf.bounding_box([0, pdf.y_position], width: 150) do
        pdf.image(logo_path, width: 120)
      end
    end
    
    pdf.bounding_box([180, pdf.y_position], width: 340) do
      pdf.text "ROCASOL S.A.S.", size: 16, style: :bold, align: :right
      pdf.text "Nit: 900.222.111-1", align: :right, size: 10
      pdf.text "Manizales, Caldas", align: :right, size: 10
      pdf.text "comercial@rocasol.com.co | 318 532 2405", align: :right, size: 10
      pdf.text "Fecha de Generación: #{Time.now.in_time_zone('America/Bogota').strftime('%d/%m/%Y')}", align: :right, size: 9
    end
    pdf.move_down 20
    pdf.stroke_horizontal_rule
  end

  def generate_client_info(pdf)
    pdf.stroke_rectangle [0, pdf.cursor], pdf.bounds.width, 60
    pdf.move_down 5
    pdf.bounding_box([10, pdf.cursor], width: pdf.bounds.width - 20) do
      pdf.text "<b>Señores:</b>", size: 10, inline_format: true
      pdf.text "#{@client.try(:name) || 'Cliente sin especificar'}", size: 10, style: :bold
      pdf.text "Dirección: #{@client.try(:address) || 'No especificada'}", size: 10
      pdf.text "Nit/CC: #{@client.try(:id) || 'No especificado'}", size: 10
    end
  end
  
  def generate_summary_note(pdf)
    pdf.stroke_rectangle [0, pdf.cursor], pdf.bounds.width, 40
    pdf.move_down 5
    pdf.bounding_box([10, pdf.cursor], width: pdf.bounds.width - 20) do
      pdf.text "<b>Estimado cliente:</b>", size: 10, inline_format: true
      pdf.text "Este es un recordatorio de su cuenta que se encuentra vencida. A continuación podrá ver el detalle:", size: 10
    end
  end

  def generate_payments_table(pdf)
    if @payments.empty?
      pdf.text "No hay pagos (cuotas) registrados para esta deuda."
    else
      table_data = [
        ["Documento", "Fecha Doc.", "Cuota", "Fecha Venc.", "Días en Mora", "Valor Mora", "Valor Cuota", "Valor Total"]
      ]
      @payments.each do |payment|
        dias_en_mora = 0
        if payment.due_at.present? && payment.due_at.to_date < Date.today
          dias_en_mora = (Date.today - payment.due_at.to_date).to_i
        end
        dias_en_mora_texto = dias_en_mora > 0 ? "#{dias_en_mora} VENCIDOS" : "AL DÍA"
        
        table_data << [
          payment.receipt_number.to_s,
          payment.created_at.strftime("%d/%m/%Y"),
          payment.installment.to_s,
          payment.due_at ? payment.due_at.strftime("%d/%m/%Y") : "N/A",
          dias_en_mora_texto,
          format_currency(payment.default_interest_amount),
          format_currency(payment.amount),
          format_currency(payment.amount + payment.default_interest_amount)
        ]
      end

      pdf.table(table_data, header: true, width: pdf.bounds.width) do
        row(0).font_style = :bold
        row(0).background_color = 'EFEFEF'
        self.cell_style = { size: 8, padding: 5, border_width: 0.5, border_color: 'AAAAAA' }
        column(5..7).align = :right
      end
    end
  end
  
  def generate_totals(pdf)
    total_valor = @payments.sum(:amount)
    total_mora = @payments.sum(:default_interest_amount)
    total_general = total_valor + total_mora

    pdf.stroke_rectangle [0, pdf.cursor], pdf.bounds.width, 30
    pdf.move_down 5
    pdf.bounding_box([300, pdf.cursor], width: pdf.bounds.width - 310) do
       pdf.table([
         ["Total Valor:", format_currency(total_valor)],
         ["Total Mora:", format_currency(total_mora)],
         ["<b>Total General:</b>", "<b>#{format_currency(total_general)}</b>"]
       ], cell_style: { borders: [], padding: 2, size: 8, inline_format: true }) do |t|
          t.column(0).align = :right
          t.column(1).align = :right
       end
    end
  end

  def generate_footer(pdf)
    pdf.stroke_rectangle [0, pdf.cursor], pdf.bounds.width, 40
    pdf.move_down 5
    pdf.bounding_box([10, pdf.cursor], width: pdf.bounds.width - 20) do
      pdf.text "Si ya canceló, por favor omita esta circular, de lo contrario lo invitamos a comunicarse con nuestra área de cartera.", size: 8, align: :center
      pdf.move_down 5
      pdf.text "Cordialmente.", size: 8, align: :center
    end
  end

  def format_currency(value)
    ActionController::Base.helpers.number_to_currency(value || 0, unit: "$", precision: 0, separator: ",", delimiter: ".")
  end
end