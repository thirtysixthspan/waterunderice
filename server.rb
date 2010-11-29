require 'rubygems'
require 'sinatra/base'
require 'eventmachine'
require 'em-websocket'
require 'thin'
require 'base64'

EventMachine.run do

  class Server < Sinatra::Base

    set :environment, :production
    set :root, File.dirname(__FILE__)
    set :public, File.dirname(__FILE__) + "/public"
    set :views, File.dirname(__FILE__) + "/views"

    get '/' do
      erb :index
    end

  end
  
  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |ws|
    storage_path = 'storage'
    upload_file = Hash.new()

    def error(description, websocket=nil)   
      websocket.send("error=>"+description) unless websocket==nil
      puts("Error: #{description}")
    end

    def deliver(description, websocket=nil)   
      websocket.send(description) unless websocket==nil
      puts("Sending: #{description}")
    end
    
    ws.onmessage do |message|

     if upload_file['in_progress'] && message=~/^upload=>(.*)$/i 
        decoded_message = Base64.decode64($1)
        upload_file['file'].write(decoded_message) 
        upload_file['index'] += decoded_message.size
        deliver("response=>upload||#{upload_file['index']}",ws)
        if upload_file['index'] >= upload_file['size']
          upload_file['in_progress'] = false 
          upload_file['file'].close()
          error('File size mismatch') unless upload_file['index'] == upload_file['size']
        end 
      end
      
      if message=~/^query=>(.*)$/i

        args = $1.split('||')
        query = args.shift
        puts "#{query} => #{args}"
        
        if query=~/exist/
          if args.size==1
            filename = args.shift.gsub(/^.*[\/\\](?=\w)|[\/\\][\w\s]*$/,'')
            deliver("response=>exist||#{File.size?(storage_path+'/'+filename)||0}",ws)
          else
            error('Incorrect parameters',ws)          
          end
        end
      end

      if message=~/^command=>(.*)$/i

        args = $1.split('||')
        query = args.shift
      
        if query=~/upload/
          if args.size==3 
            upload_file['name'] = args[0]
            upload_file['size'] = args[1].to_i
            upload_file['index'] = args[2].to_i
            mode = ((upload_file['index'] == 0) ? 'w' : 'a')
            upload_file['file'] = File.new(storage_path+"/"+upload_file['name'], mode)
            if upload_file['file']
              upload_file['in_progress'] = true            
            else
              error('Failed to open file on server',ws)
            end             
          else
            error('Incorrect parameters',ws)          
          end
        end           
      end

    end
    
  end

  Server.run!({:port=>8000})
end

  
