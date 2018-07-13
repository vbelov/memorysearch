RSpec.describe 'Search document:', type: :model do
  let(:index) { 'books' }
  let(:type) { 'book' }
  let(:id) { rand(1_000) }
  let(:document) do
    {title: 'sldjfksld', author: 'sldkjflsdkj'}
  end
  let(:document_with_meta) do
    {index: index, type: type, id: id, body: document}
  end

  def index_doc(document = {})
    @id ||= 0
    @id += 1
    document_with_meta = {index: index, type: type, id: @id, body: document}
    Chewy.client.index(document_with_meta)
  end

  let(:doc1) { {color: 'red',   age: 1, level: 11}.stringify_keys }
  let(:doc2) { {color: 'blue',  age: 2, level: 12}.stringify_keys }
  let(:doc3) { {color: 'green', age: 3, level: 13}.stringify_keys }

  MemorySearch::Client.use

  # TODO:
  # * non analyzed strings
  before do
    index_doc(doc1)
    index_doc(doc2)
    index_doc(doc3)
  end

  def search(query)
    response = Chewy.client.search(index: index, body: {query: query})
    Hashie::Mash.new(response)
  end


  it 'test1' do
    response = search(term: {age: 2})

    expect(response.hits.total).to eq(1)
    expect(response.hits.hits[0]._source).to eq(doc2)
  end

  it 'test2' do
    response = search(bool: {must: [
        {term: {age: 2}},
        {term: {level: 12}},
    ]})
    expect(response.hits.total).to eq(1)
    expect(response.hits.hits[0]._source).to eq(doc2)
  end

  it 'test3' do
    response = search(bool: {must: [
        {term: {age: 2}},
        {term: {level: 11}},
    ]})
    expect(response.hits.total).to eq(0)
  end

  it 'test4' do
    response = search(bool: {should: [
        {term: {age: 2}},
        {term: {level: 13}},
    ]})
    expect(response.hits.total).to eq(2)
    expect(response.hits.hits[0]._source).to eq(doc2)
    expect(response.hits.hits[1]._source).to eq(doc3)
  end
end
