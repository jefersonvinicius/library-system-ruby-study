class AttachmentPositionable 
    def self.attach(image:, to:)
        to.images.attach(image)
        new_image = to.images.last
        new_image.position = to.images.length - 1
        new_image
    end
end