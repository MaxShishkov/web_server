require 'socket'
require 'uri'
Dir.glob('lib/**/*.rb').each do |file|
  require file
end

module WebServer
  class Server
    DEFAULT_PORT = 2468
    #files will be served from this directory
    WEB_ROOT = './public_html'
    
    

    def initialize(options={})
      # Set up WebServer's configuration files and logger here
      # Do any preparation necessary to allow threading multiple requests

      httpd_hash = Hash.new
      puts "\nBefore Hash \n"

      File.foreach("config/httpd.conf").with_index do |line|
        puts "#{line}"
        next if line.include? "#"
        next if /\S/ !~ line
        line_array = line.split(" ", 2) 
        line_array[1].gsub! /"/, ''
        httpd_hash[line_array[0]] = line_array[1]
        
      end

      puts "\nThe Hash \n"
      httpd_hash.each do |key, value|
      puts key + ' : ' + value
      end
			
			




    end

    def start
      # Begin your 'infinite' loop, reading from the TCPServer, and
      # processing the requests as connections are made

      #Initialize a TCPServer Object that would listen for incoming
      #connections on localhost through the DEFAULT_PORT
      server = TCPServer.new('localhost', DEFAULT_PORT)

      loop do
        #Wait for a clint to connect than return a TCPSocket
	socket = server.accept

	#Read the first line of the request
	request = socket.gets

	#output the request to console for debuging.
	STDERR.puts request

	#create a response
	response = "200 OK\r\n"

	#include content-type and content-length headers into response
	socket.print "HTTP/1.1 200 OK\r\n" +
		     "Content-Type: text/plain\r\n" +
		     "Content-Length: #{response.bytesize}\r\n" +
		     "Connection: close\r\n"

        #print a newline to separate the header from the body
	socket.print "\r\n"

	#print the response body
	socket.print response

	#close the socket
	socket.close
      end
    end

    private
  end
end

WebServer::Server.new.start
