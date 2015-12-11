class Interest < ActiveRecord::Base
  acts_as_taggable
  attr_accessor :interest_type_hash, :doc_id

  has_many :images, as: :owner

  default_scope { order(updated_at: :desc) }

  def initialize(attributes = {}, options = {})
    super(attributes, options)
    initialize_with_attributes(attributes) if attributes.present?
  end

  def take_screencap!
    self.image_url = ScreenShot.capture(url)[:url] unless Rails.env.test?
  end

  def embed?
    Interest.interest_types.find { |d| d["name"] == provider }.try(:[], "embeddable")
  end

  def document_profile(url)
    hashes = Interest.interest_types.keep_if do |interest_type|
      interest_type["supported_schemas"].any? do |schema|
        if url =~ /#{escape(schema)}/
          matches = /#{escape(schema)}/.match(url)
          self.doc_id = matches[matches.size - 1]
          true
        end
      end
    end
    hashes.first
  end

  def self.supported_types
    interest_types.collect { |interest_type| interest_type["name"] }
  end

  private

  def initialize_with_attributes(attributes)
    self.interest_type_hash = document_profile(attributes[:url]) || { "url" => url, "treatment" => "link", "type" => "website" }
    self.doc_id = url if doc_id.blank?
    self.url = url
    self.treatment = interest_type_hash["treatment"]
    self.interest_type = interest_type_hash["type"]
    self.provider = interest_type_hash["name"]
    self.embed_url = interest_type_hash["url"] % { id: doc_id } if interest_type_hash["url"]
    self.title = title_from_url(url)
    self.take_screencap! unless embed?
  end

  def title_from_url(url)
    m = Mechanize.new
    m.user_agent_alias = "Mac Safari"
    m.get(url).title.gsub(/- #{provider}/i, '')
  end

  def escape(url)
    regex = Regexp.escape(url)
    regex.gsub!(/\\\*/, "(.*)")
    regex.gsub!(/http:/, "(https|http):")
    regex
  end

  def self.interest_types
    file_path = Rails.root.join('config', 'supported_documents.yml')
    YAML.load_file(file_path)["interest_types"]
  end
end
