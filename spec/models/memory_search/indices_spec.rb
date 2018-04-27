RSpec.describe 'Index methods:', type: :model do
  # TODO move somewhere
  let(:index) { 'books' }
  let(:type) { 'book' }
  let(:id) { rand(1_000) }
  let(:document) do
    {title: 'sldjfksld', author: 'sldkjflsdkj'}
  end
  let(:document_with_meta) do
    {index: index, type: type, id: id, body: document}
  end

  describe 'exists?' do
    it 'returns false if index does not exist' do
      response = Chewy.client.indices.exists?(index: index)
      expect(response).to be false
    end

    it 'returns true if index exists' do
      Chewy.client.index(document_with_meta)
      response = Chewy.client.indices.exists?(index: index)
      expect(response).to be true
    end
  end

  describe 'delete' do
    before do
      Chewy.client.index(document_with_meta)
    end

    it 'deletes previously created index' do
      response = Chewy.client.indices.delete(index: index)
      expect(response['acknowledged']).to eq(true)
    end

    it 'deletes index within memory' do
      Chewy.client.indices.delete(index: index)
      expect(Chewy.client.storage.indices[index]).to be_nil
    end

    it 'deletes all documents within index' do
      Chewy.client.indices.delete(index: index)

      response = Chewy.client.get(index: index, type: type, id: id)
      expect(response['found']).to eq false
    end
  end
end
