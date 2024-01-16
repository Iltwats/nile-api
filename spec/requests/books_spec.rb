require 'rails_helper'

describe "Books API", type: :request do
  let(:first_author){FactoryBot.create(:author, first_name:'Geroge',last_name:'Michale',age:43)}
  let(:second_author){FactoryBot.create(:author, first_name:'Barrack',last_name:'Obama',age:23)}
  describe 'GET /books' do
    before do
      FactoryBot.create(:book, title:"1984", author:first_author)
      FactoryBot.create(:book, title:"1982", author:second_author)
    end
    it 'get status for books' do
      get '/api/v1/books'
      expect(response).to have_http_status(:success)
    end

    it 'returns all books' do
      get '/api/v1/books'

      expect(response_body.size).to eq(2)
    end
  end

  describe 'POST /books' do
    it 'check response code' do
      post '/api/v1/books', params: {
        book: {title:'2 States'},
        author:{first_name:'Chetan', last_name:'Bhagat', age:45}
      }

      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
      expect(response_body).to eq(
        {
          'id' => 1,
          'title' => '2 States',
          'author_name' => 'Chetan Bhagat',
          'author_age' => 45
        }
      )
    end

    it 'check count' do
      expect{
        post '/api/v1/books', params: {
          book: {title:'2 States'},
          author:{first_name:'Chetan', last_name:'Bhagat', age:45}
        }
      }.to change {Book.count}.from(0).to(1)
    end
  end

  describe 'DELETE /books' do
    let!(:book) { FactoryBot.create(:book, title:"1984", author:first_author) }

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
