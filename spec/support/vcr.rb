VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :faraday
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<CREDENTIALS>') do
    Base64.encode64("#{ENV['CASSIA_CLIENT_ID']}:#{ENV['CASSIA_SECRET']}").strip
  end
  c.filter_sensitive_data('<CLIENT_ID>') do
    ENV['CASSIA_CLIENT_ID']
  end
  c.filter_sensitive_data('<API_URL>') do
    ENV['CASSIA_AC_URL']
  end
end
