RSpec.configure do |config|

  def load_fixture(name, type='txt', options={})
    type = type.to_s
    string = File.read(File.join(File.dirname(__FILE__), 'fixtures', "#{name}.#{type}"))
    if type == 'html' && options.fetch(:remove_whitespace, true)
      string.gsub("\n",'')
    else
      string
    end
  end

end
