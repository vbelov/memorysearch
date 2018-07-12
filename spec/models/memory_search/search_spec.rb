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

  let(:doc1) { {color: 'red',  int: 1}.stringify_keys }
  let(:doc2) { {color: 'blue', int: 2}.stringify_keys }

  # TODO:
  # * non analyzed strings
  before do
    MemorySearch::Client.use
    index_doc(doc1)
    index_doc(doc2)
  end


  it 'test1' do
    # response = Chewy.client.search(index: index, body: {query: {term: {color: 'red'}}})
    response = Chewy.client.search(index: index, body: {query: {term: {int: 2}}})
    # response = Chewy.client.search(index: index, body: {query: {}})
    ap response

    expect(response['hits']['total']).to eq(1)
    expect(response['hits']['hits'][0]['_source']).to eq(doc2)
  end
end
