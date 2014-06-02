require 'bundler'
require 'sinatra'

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

