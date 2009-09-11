require 'rubygems'
require 'ruport'

module MyReports

  class SalesReport < Ruport::Renderer
    include Ruport::Renderer::Helpers

    def run
      build [:header,:body,:footer],:document
      finalize :document
    end

    def report_title=(t)
      options.report_title=(t)
    end

    def titles=(t)
      options.titles=(t)
    end

  end

  class SalesReportText < Ruport::Format::Plugin
    SalesReport.add_format self, :txt

    def pad(str, len)
      return "".ljust(len) if str.nil?
      str = str.slice(0, len) # truncate long strings
      str.ljust(len) # pad with whitespace
    end

    def build_document_header
      unless options.report_title.nil?
        output << "".ljust(75,"*") << "\n"
        output << "  #{options.report_title}\n" 
        output << "".ljust(75,"*") << "\n"
        output << "\n"
      end
    end
    
    def build_document_body
      # table heading
      output << pad("isbn", 15) << "|" << pad("title",30) << "|" << pad("author", 15) << "|" << pad("sales", 10) << "\n"
      output << "".ljust(75,"#") << "\n"

      # table data
      unless options.titles.nil?
          options.titles.each do |title|
            output << pad(title["isbn"],15) << "|"
            output << pad(title["title"],30) << "|"
            output << pad(title["author"],15) << "|"
            output << pad(title["sales"].to_s,10) << "\n"
          end
      end
      
      output << "".ljust(75,"#") << "\n"
    end

    def build_document_footer
      # do nothing, we won't bother with a footer at this stage
    end

    def finalize_document
      # text doesn't need any special rendering, so just return the output
      output
    end

  end


  class SalesReportPDF <  Ruport::Format::PDF
    SalesReport.add_format self, :pdf

    def add_title( title )
      width = 200
      height = 20
      top_left_x  = pdf_writer.absolute_right_margin - width
      top_left_y  = pdf_writer.absolute_top_margin
      radius = 5
      
      font_size = 12
      loop = true
      title = "<b>#{title}</b>" 
      while ( loop == true )
        sz = pdf_writer.text_width( title, font_size )
        if ( (top_left_x + sz) > top_left_x+width )
            font_size -= 1
        else
            loop = false
        end
      end

      pdf_writer.fill_color(Color::RGB::Gray80)
      pdf_writer.rounded_rectangle(top_left_x, top_left_y, width, height, radius).fill_stroke
      pdf_writer.fill_color(Color::RGB::Black)
      pdf_writer.stroke_color(Color::RGB::Black)
      pdf_writer.text( title, :absolute_left => top_left_x,
                              :absolute_right => top_left_x + width,
                              :justification => :center,
                              :font_size => font_size)
    end

    def build_document_header
      add_title( options.report_title ) unless options.report_title.nil?
      move_cursor_to(pdf_writer.y - 50) # padding
    end
    
    def build_document_body
      ::PDF::SimpleTable.new do |table|
        table.maximum_width = 500
        table.orientation   = :center
        table.data          = options.titles
        table.column_order  = %w[isbn title author sales]
        table.render_on(pdf_writer)
      end
    end

    def build_document_footer
      # do nothing, we won't bother with a footer at this stage
    end

    def finalize_document
      output << pdf_writer.render
    end

  end
end
