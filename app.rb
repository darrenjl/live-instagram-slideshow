require "sinatra"
require "instagram"
require "open-uri"
require "set"
require "YAML"


Instagram.configure do |config|
	config.client_id = "383cdfe8df5a48bd9df8c5cfade0d9cc"
	config.client_secret = "54c79081e4aa4d9fa4ffbcb6f1c64527"
end

ids = Set.new

begin
	ids = YAML.load(File.read('ids.out'))
rescue Errno::ENOENT
	puts 'No ids file'
end

begin
  while true
	puts 'Requesting new photos'
	response=Instagram.tag_recent_media('sirfcball')
	# puts response

	puts 'Num hits: '
	puts response.count

	response.count.times do |count|
		puts "Retrieving image #{count}"
		id=response[count].id.to_s
		puts "id: " + id
		unless ids.include? id
  			puts "id not already processed"
  			ids.add id
			caption=response[count].caption.text.gsub!(' ','_')
			image=response[count].images
			puts image

			image_url=response[count].images.standard_resolution.url

			puts image_url

			open('/Users/darren/Desktop/SIRFCBall2015/'+caption+rand(100).to_s+'.jpg', 'wb') do |file|
		  		file << open(image_url).read
			end
		end
		
	end
	
	sleep(10)
  end
rescue Interrupt
  puts "\nexiting..."
  puts ids

File.open('ids.out', 'w') {|f| f.write(YAML.dump(ids)) }
rescue Exception => e
  puts e
end

	

exit
