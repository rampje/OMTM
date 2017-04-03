# add comment for fun

# initial commit using example from documentation
# run "scrapy runspider crawler1.py -o quotes.json in" terminal


import scrapy

class NewsArticle(scrapy.Item):
    title = scrapy.Field()
   # text = scrapy.Field()
    link = scrapy.Field()

class NewsSpider(scrapy.Spider):
    name = 'newsspider'
    start_urls = ['http://www.politico.com',
                  'http://www.nytimes.com']

    def parse(self, response):
        for url in response.xpath('//a'):
            news = NewsArticle()

            news['title'] = url.xpath('text()').extract()
            news['link'] = url.xpath('@href').extract()

            yield news


