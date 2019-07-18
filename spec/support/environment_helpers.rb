module EnvironmentHelpers
  def with_environment(partial_env)
    old = ENV.to_hash
    ENV.update partial_env
    begin
      yield
    ensure
      ENV.replace old
    end
  end
end
