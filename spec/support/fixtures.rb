RSpec.configure do |config|

  def load_fixture(name, type='txt')
    File.read File.join(File.dirname(__FILE__), 'fixtures', "#{name}.#{type}")
  end

end
