# frozen_string_literal: true

require 'benchmark'

# NOTE: rails benchmark:pagination PAGE=XXX CURSOR=XXXX で実行する
namespace :benchmark do
  desc 'Benchmark offset and cursor pagination'
  task pagination: :environment do
    page = ENV['PAGE'] ? ENV['PAGE'].to_i : 1
    per_page = ENV['PER_PAGE'] ? ENV['PER_PAGE'].to_i : 20
    cursor = ENV['CURSOR'] ? ENV['CURSOR'].to_i : Post.minimum(:id)
    count = ENV['COUNT'] ? ENV['COUNT'].to_i : 3

    offset = (page - 1) * per_page

    count.times do
      reset_query_cache_and_buffer_pool

      puts "\nBenchmarking Offset Pagination..."
      Benchmark.bm(17) do |x|
        x.report('Offset Pagination') do
          Post.order(:id).offset(offset).limit(per_page).load
        end
      end

      reset_query_cache_and_buffer_pool

      puts "\nBenchmarking Cursor Pagination..."
      Benchmark.bm(17) do |x|
        x.report('Cursor Pagination') do
          Post.where('id > ?', cursor).order(:id).limit(per_page).load
        end
      end
    end
  end
end

private

def reset_query_cache_and_buffer_pool
  ActiveRecord::Base.connection.clear_query_cache
  # キャッシュを埋めるために、大きなダミークエリを実行
  puts "\nFilling buffer pool with dummy data..."
  DummyDatum.in_batches(of: 10_000).each_record(&:id)
end
