require "sinatra"
require "instagram"
require "open-uri"


Instagram.configure do |config|
	config.client_id = "383cdfe8df5a48bd9df8c5cfade0d9cc"
	config.client_secret = "54c79081e4aa4d9fa4ffbcb6f1c64527"
end
while true
	response=Instagram.tag_recent_media('sirfcball')
	puts response

	puts 'Num hits: '
	puts response.count

	response.count.times do |count|
		puts "Retrieving image #{count}"
		puts response[count].id
		caption=response[count].caption.text.gsub!(' ','_')
		image=response[count].images
		puts image

		image_url=response[count].images.standard_resolution.url

		puts image_url

		open('/Users/darren/Desktop/SIRFCBall2015/'+caption+'.jpg', 'wb') do |file|
	  		file << open(image_url).read
		end
	end

	
	sleep(10)
end	

exit
