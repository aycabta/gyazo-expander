require 'bundler'
require 'json'
require 'sinatra'
require 'mechanize'

get '/' do
  resp = <<"EOR"
<html>
<head>
<title>The Nou</title>
<body>
<p><img src="http://i.gyazo.com/ed99df3af54e6c9102f41fe77d90b940.jpg" width="1024" height="768" /></p>
</body>
</html>
EOR
end

post '/gyagyagya' do
  content_type :text
  json = JSON.parse(request.body.read)
  if not json["events"].nil?
    json["events"].map do |e|
      if e["message"] && e["message"]["text"] =~ %r`^http://gyazo\.com/\w+$`
        message = e["message"]["text"]
        agent = Mechanize.new
        agent.user_agent = "Mozilla/5.0 (Windows NT 6.2; WOW64; rv:26.0) Gecko/20100101 Firefox/26.0"
        agent.get(gyazo_url)
        image_node = @agent.page.parser.xpath("//meta[@name='twitter:image']").first.attributes["content"]
        if image_node
          image_node.value
        else
          "\n"
        end
      end
    end
  end
end

