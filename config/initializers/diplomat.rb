=begin
Diplomat.configure do |config|
	host = ENV["CONSUL_HOST"]
	port = ENV["CONSUL_PORT"]
	
	if host.to_s.empty?
		host = "localhost"
	end
	if port.to_s.empty?
		port =  "8500"
	end

	puts "CONSUL_HOST=#{host}"
	puts "CONSUL_PORT=#{port}"

	config.url = "http://#{host}:#{port}"
end
=end