module Etsy
  class Listing
    
    include Etsy::Model
    
    STATES = %w(active removed sold_out expired alchemy)
    
    finder :all, '/shops/:user_id/listings'
    
    attribute :id, :from => :listing_id
    attribute :view_count, :from => :views
    attribute :created, :from => :creation_epoch
    attribute :currency, :from => :currency_code
    attribute :ending, :from => :ending_epoch
    
    attributes :title, :description, :state, :url, :price, :quantity, :tags, :materials

    STATES.each do |state|
      define_method "#{state}?" do
        self.state == state.sub('_', '')
      end
    end
    
    def created_at
      Time.at(created)
    end
    
    def ending_at
      Time.at(ending)
    end
    
    def images
      @result['all_images'].map {|image_data| Image.new(image_data) }
    end
    
    def image
      images.first
    end
    
  end
end
