require 'rails_helper'

class FakeImage 
    attr_accessor :position

    def initialize(position = nil)
        @position = position
    end
end


class ImagesCollection < Array
    def initialize(images = [])
        super()
    end

    def attach(image)
        self << image
    end
end

class FakeModel
    attr_reader :images

    def initialize()
        @images = ImagesCollection.new
    end
end

RSpec.describe 'AttachmentPositionable' do
    context "empty images" do
        let(:model) { FakeModel.new }

        it "should add at first position" do
            image = FakeImage.new
            new_image = AttachmentPositionable.attach(image: image, to: model)
           
            expect(model.images.length).to eq(1)
            expect(model.images[0].position).to eq(0)
            expect(new_image.position).to eq(0)
        end
        
        it "should add at second position" do
            image1 = FakeImage.new
            image2 = FakeImage.new

            AttachmentPositionable.attach(image: image1, to: model)
            new_image = AttachmentPositionable.attach(image: image2, to: model)
            
            expect(model.images.length).to eq(2)
            expect(model.images[0].position).to eq(0)
            expect(model.images[1].position).to eq(1)
            expect(new_image.position).to eq(1)
         end
    end
end