class BaseModelView
    protected
        def render_images(model)
            fill_null_positions(model)
            images = model.images.sort_by(&:position)
            images.map { |image| {id: image.id, url: url_for(image), position: image.position} }
        end

    private
        def fill_null_positions(model)
            index = model.images.select { |image| image.position.present? }.length + 1
            model.images.each do |image|
                if image.position.nil?
                    image.position = index
                    index += 1
                end
            end
        end
end