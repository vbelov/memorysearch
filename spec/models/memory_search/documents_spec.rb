RSpec.describe 'Document methods:', type: :model do
  let(:index) { 'books' }
  let(:type) { 'book' }
  let(:id) { rand(1_000) }
  let(:document) do
    {title: 'sldjfksld', author: 'sldkjflsdkj'}
  end
  let(:document_with_meta) do
    {index: index, type: type, id: id, body: document}
  end

  describe 'index' do
    let(:expected_response) do
      {
          _index: index,
          _type: type,
          _id: id.to_s,
          _version: 1,
          result: "created",
          _shards: {
              total: 1,
              successful: 1,
              failed: 0
          },
          created: true
      }.deep_stringify_keys
    end

    it 'returns correct response' do
      expect(Chewy.client.index(document_with_meta)).to eq(expected_response)
    end

    it 'stores document in memory' do
      Chewy.client.index(document_with_meta)
      documents = Chewy.client.storage.indices[index].documents
      expect(documents.count).to eq(1)
      expect(documents[0][:id]).to eq(id.to_s)
    end
  end

  describe 'get' do
    it "doesn't return document if it wasn't indexed" do
      response = Chewy.client.get(index: index, type: type, id: id)
      expect(response['found']).to eq false
    end

    let(:expected_response) do
      {
          _index: index,
          _type: type,
          _id: id.to_s,
          _version: 1,
          found: true,
          _source: document
      }.deep_stringify_keys
    end

    it 'returns previously indexed document' do
      Chewy.client.index(document_with_meta)
      response = Chewy.client.get(index: index, type: type, id: id)
      expect(response).to eq(expected_response)
    end
  end
end
