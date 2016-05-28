class CardsService
  attr_reader :connection

  def initialize
    @connection = Faraday.new(url: "http://deckofcardsapi.com/api/")
  end

  def deck_of_cards_hash
    parse(get_cards)
  end

  private

    def get_cards
      connection.get "deck/new/draw/?count=52"
    end

    def parse(response)
      JSON.parse(response.body, symbolize_names: true)
    end
end
