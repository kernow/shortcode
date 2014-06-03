RSpec.configure do |config|

  def load_fixture(name, type='txt')
    type = type.to_s
    string = File.read(File.join(File.dirname(__FILE__), 'fixtures', "#{name}.#{type}"))
    type == 'txt' ? string : string.gsub("\n",'')
  end

end
