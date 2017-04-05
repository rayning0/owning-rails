require "test_helper"

require "active_record"
require "muffin_blog/app/models/application_record"
require "muffin_blog/app/models/post"

class ActiveRecordTest < Minitest::Test
  def setup
    Post.establish_connection(
      database: "#{__dir__}/muffin_blog/db/development.sqlite3")
  end

  def test_initialize
    post = Post.new(id: 1, title: "My first post")
    assert_equal 1, post.id
    assert_equal "My first post", post.title
  end

  def test_find
    post = Post.find(1)
    assert_kind_of Post, post
    assert_equal 1, post.id
    assert_equal "Blueberry Muffins", post.title
  end

  def test_execute_sql
    rows = Post.connection.execute("SELECT * FROM posts")
    assert_kind_of Array, rows
    row = rows.first
    assert_kind_of Hash, row
    assert_equal [:id, :title, :body, :created_at, :updated_at], row.keys
  end
end