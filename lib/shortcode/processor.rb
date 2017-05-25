class Shortcode::Processor

  def process(string, configuration, additional_attributes=nil)
    transformer(configuration).apply parser(configuration).parse(string), additional_attributes: additional_attributes
  end

  private

  def parser(configuration)
    @parser ||= Shortcode::Parser.new(configuration)
  end

  def transformer(configuration)
    @transformer ||= Shortcode::Transformer.new(configuration)
  end
end
