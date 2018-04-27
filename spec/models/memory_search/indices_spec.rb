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

  def build_index_request(index: nil, type: nil, id: nil, document: nil)
    index ||= Faker::Team.name.split(' ').join('_').underscore
    type ||= Faker::Hacker.noun
    id ||= rand(1_000)
    document ||= Faker::Types.complex_hash

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

    context 'when multiple indices exist' do
      before do
        Chewy.client.index(build_index_request(index: 'index1'))
        Chewy.client.index(build_index_request(index: 'index2'))
        Chewy.client.index(build_index_request(index: 'products'))
      end

      it 'handles array' do
        response = Chewy.client.indices.exists?(index: %w(index1 index2))
        expect(response).to be true
      end

      it 'handles pattern' do
        response = Chewy.client.indices.exists?(index: 'index*')
        expect(response).to be true
      end

      it 'returns false if no index matches pattern' do
        response = Chewy.client.indices.exists?(index: 'ndex*')
        expect(response).to be false
      end

      it 'handles array with patterns' do
        response = Chewy.client.indices.exists?(index: %w(index* products))
        expect(response).to be true
      end

      it 'returns false if no index matches element of array' do
        response = Chewy.client.indices.exists?(index: %w(index* ndex))
        expect(response).to be false
      end
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
