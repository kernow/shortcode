RSpec::Matchers.define :write do |message|

  chain(:to) do |io|
    @io = io
  end

  match do |block|
    output =
      case io
      when :output then fake_stdout(&block)
      when :error  then fake_stderr(&block)
      else raise("Allowed values for `to` are :output and :error, got `#{io.inspect}`")
      end
    output.include? message
  end

  description do
    "write \"#{message}\" #{io_name}"
  end

  failure_message_for_should do
    "expected to #{description}"
  end

  failure_message_for_should_not do
    "expected to not #{description}"
  end

  def supports_block_expectations?
    true
  end

  # Fake STDERR and return a string written to it.
  def fake_stderr
    original_stderr = $stderr
    $stderr = StringIO.new
    yield
    $stderr.string
  ensure
    $stderr = original_stderr
  end

  # Fake STDOUT and return a string written to it.
  def fake_stdout
    original_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
  end

  # default IO is standard output
  def io
    @io ||= :output
  end

  # IO name is used for description message
  def io_name
    { output: "standard output", error: "standard error" }[io]
  end
end
