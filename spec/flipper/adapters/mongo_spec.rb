require 'helper'
require 'timeout'
require 'flipper/adapters/mongo'
require 'flipper/spec/shared_adapter_specs'

Mongo::Logger.logger.level = Logger::INFO

describe Flipper::Adapters::Mongo do
  let(:host) { ENV["BOXEN_MONGODB_HOST"] || '127.0.0.1' }
  let(:port) { ENV["BOXEN_MONGODB_PORT"] || 27017 }

  let(:collection) {
    Mongo::Client.new(["#{host}:#{port}"], :database => 'testing')['testing']
  }

  subject { described_class.new(collection) }

  before do
    begin
      Timeout::timeout(1) do
        collection.drop
      end
    rescue Mongo::Error::OperationFailure => e
      puts
      puts "Error executing operation on Mongo. Is Mongo running?"
      puts
      raise e
    rescue Timeout::Error => e
      puts
      puts "Timeout connecting to Mongo. Is Mongo running?"
      puts
      raise e
    end
    collection.create
  end

  it_should_behave_like 'a flipper adapter'
end
