class Shortcode::Processor

  def process(string, additional_attributes=nil)
    transformer.apply parser.parse(string), additional_attributes: additional_attributes
  end

  def strip(string, additional_attributes=nil)
    stripper.apply parser.parse(string), additional_attributes: additional_attributes
  end

  private

    def parser
      @parser ||= Shortcode::Parser.new
    end

    def transformer
      @transformer ||= Shortcode::Transformer.new
    end

    def stripper
      @stripper ||= Shortcode::Stripper.new()
    end

end
