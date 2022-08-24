class BaseModelView
    protected
        def render_images(model)
            Sorting.fill_nil_positions(model.images)
            images = model.images.sort_by(&:position)
            images.map { |image| {id: image.id, url: url_for(image), position: image.position} }
        end
end