require 'rails_helper'

describe "Books API", type: :request do
  describe 'GET /books' do
    before do
      FactoryBot.create(:book, title:"1984", author:"George")
      FactoryBot.create(:book, title:"1982", author:"Bowel")
    end
    it 'get status for books' do
      get '/api/v1/books'
      expect(response).to have_http_status(:success)
    end

    it 'returns all books' do
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

  describe 'DELETE /books' do
    let!(:book) { FactoryBot.create(:book, title:"1984", author:"George") }

    it 'check destroy status code' do
      delete "/api/v1/books/#{book.id}"

      expect(response).to have_http_status(:no_content)
    end

    it 'check if record is deleted or not' do
      expect{
        delete "/api/v1/books/#{book.id}"
    }.to change {Book.count}.from(1).to(0)
    end
  end

end
