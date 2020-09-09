# frozen_string_literal: true

module Application::ResponseHandler
  extend ActiveSupport::Concern

  def serializer
    ActiveModelSerializers::SerializableResource
  end

  def render_collection(collection, options = {}, serialize_options = {})
    data = {}
    data[options[:name]] = serializer.new(collection, serialize_options)
    data[:total_count] = serialize_options[:total_count] if serialize_options[:total_count].present?
    render status: :ok, json: {
      message: 'success',
      data: data
    }
  end

  def render_object(object, options = {}, serialize_options = {})
    data = {}
    serialize_options = serialize_options.merge(serializer: options[:serializer]) if options[:serializer].present?
    data[options[:name]] = serializer.new(object, serialize_options)
    render status: :ok, json: {
      message: 'success',
      data: data
    }
  end

  def render_grouped_collection(grouped_collection)
    data = {}
    grouped_collection.each do |name, collection_parameters|
      data[name] = serializer.new(collection_parameters.first, collection_parameters.last)
    end
    render status: :ok, json: {
      message: 'success',
      data: data
    }
  end

  def render_success
    render status: :ok, json: {
      message: 'success'
    }
  end
end
