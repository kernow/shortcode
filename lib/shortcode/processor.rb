class Shortcode::Processor

  def initialize(configuration)
    @configuration = configuration
  end

  def process(string, additional_attributes=nil)
    transformer.apply parser.parse(string), additional_attributes: additional_attributes
  end

  private

    def parser
      @parser ||= Shortcode::Parser.new(@configuration)
    end

    def transformer
      @transformer ||= Shortcode::Transformer.new(@configuration)
    end

end
