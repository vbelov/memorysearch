require 'test_helper'


class SimpleTest < ActiveSupport::TestCase
  test "the truth" do
    MemorySearch::Client.use

    response = Chewy.client.indices.delete(index: 'books')
    ap response

    response = Chewy.client.index(index: 'books', type: 'book', id: '123', body: {title: 'sldjfksld', author: 'sldkjflsdkj'})
    ap response

    response = Chewy.client.get(index: 'books', type: 'book', id: '123')
    ap response
  end
end
