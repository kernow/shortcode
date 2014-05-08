class Shortcode::Processor

  def process(string, additional_attributes=nil)
    transformer.apply parser.parse(string), additional_attributes: additional_attributes
  end

  private

    def parser
      @parser ||= Shortcode::Parser.new
    end

    def transformer
      @transformer ||= Shortcode::Transformer.new
    end

end
