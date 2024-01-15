require 'rails_helper'

describe "Books API", type: :request do
  describe 'GET /books' do
    it 'get status for books' do
      get '/api/v1/books'
      expect(response).to have_http_status(:success)
    end

    it 'returns all books' do
      FactoryBot.create(:book, title:"1984", author:"George")
      FactoryBot.create(:book, title:"1982", author:"Bowel")
      get '/api/v1/books'

      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'POST /books' do
    it 'check response code' do
      post '/api/v1/books', params: { book: {title:'Hello World', author:'Strousoup'} }

      expect(response).to have_http_status(:created)
    end

    it 'check count' do
      expect{
        post '/api/v1/books', params: { book: {title:'Hello World', author:'Strousoup'} }
    }.to change {Book.count}.from(0).to(1)
    end
  end

end
