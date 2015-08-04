# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://masstennis.icitymobile.com"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  
  # News
  add news_index_path
  News.find_each do |news|
    add news_path(news)
  end
  # Messages
  add messages_path
  add messages_message_upload_view_path
  # Tennis Essays
  add tennis_essays_path
  TennisEssay.find_each do |essay|
    add tennis_essay_path(essay)
  end
  
end
