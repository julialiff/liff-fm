class PagesController < ApplicationController
  include Resources::HttpClient
  include ::Lastfm::HttpClientConfiguration

  def home
    if user_signed_in?
      response = get(url: "/2.0/", params: {method: 'user.getweeklyartistchart', user: current_user.lastfm, api_key: 'b2c88a5682e5c945de92a96b46c110ad', format: 'json'})
      # response = get(url: "/2.0/", params: {method: 'user.getweeklyartistchart', user: current_user.lastfm, api_key: Rails.application.credentials.last_fm_api_key, format: 'json'})
      @artists = JSON.parse response.body

      chars = "Meus artistas mais ouvidos esta semana foram: http://last.fm/user/#{current_user.lastfm}".length
      twitter = ''
      @print_list = ''
      @artists['weeklyartistchart']['artist'].each do |a|
        if (chars + a['name'].length + a['playcount'].length + 5) > 280
          @print_list = @print_list[0..-3] + '. '
          twitter = twitter[0..-3] + ". http://last.fm/user/#{current_user.lastfm}"
          break
        else
          chars += + a['name'].length + a['playcount'].length + 5
          @print_list += '<b>' + a['name'] + '</b> (' + a['playcount'] +'), '
          twitter += a['name'] + '(' + a['playcount'] + '), '
        end
      end
      @print_list = @print_list.html_safe
    end
  end

  def new

  end

  def contact
  end

  def about
  end

  def show
  end
end
