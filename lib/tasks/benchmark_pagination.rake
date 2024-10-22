# frozen_string_literal: true

require 'benchmark'

# NOTE: rails benchmark:pagination PAGE=XXX CURSOR=XXXX で実行する
namespace :benchmark do
  desc 'Benchmark offset and cursor pagination'
  task pagination: :environment do
    page = ENV['PAGE'] ? ENV['PAGE'].to_i : 1
    per_page = ENV['PER_PAGE'] ? ENV['PER_PAGE'].to_i : 20
    cursor = ENV['CURSOR'] ? ENV['CURSOR'].to_i : Post.minimum(:id)

    offset = (page - 1) * per_page

    puts "\nBenchmarking Offset Pagination..."
    Benchmark.bm do |x|
      x.report('Offset Pagination') do
        Post.order(:id).offset(offset).limit(per_page).load
      end
    end

    puts "\nBenchmarking Cursor Pagination..."
    Benchmark.bm do |x|
      x.report('Cursor Pagination') do
        Post.where('id > ?', cursor).order(:id).limit(per_page).load
      end
    end
  end
end
