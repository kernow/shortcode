class Shortcode::Processor

  def process(string)
    transformer.apply parser.parse(string)
  end

  private

    def parser
      @parser ||= Shortcode::Parser.new
    end

    def transformer
      @transformer ||= Shortcode::Transformer.new
    end

end
