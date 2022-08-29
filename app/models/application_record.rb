class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.save_many(models)
    ActiveRecord::Base.transaction do  
      models.each { |model| model.save }  
    end
  end

  def attach_positioned(*attachable)
    self.images.attach(attachable)
    images_with_position = self.images.select { |image| image.position.present? }
    new_image = self.images.last
    new_image.position = [0, images_with_position.length - 1].max
    new_image.save
  end

  def purge_positioned(image_purging)
    image_purging.purge
    return if image_purging.position.nil?

    biggest = self.images.select { |image| image.position.present? && image.position > image_purging.position}
    biggest.each { |image| image.position -= 1 }
    self.class.save_many(biggest)
  end
end
