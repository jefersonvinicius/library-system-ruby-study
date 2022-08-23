class Sorting
    def self.sort(models:, changing:, to:)
        return [] if to > models.length || to < 0

        changing_model = models.find { |model| model.id == changing.id }
        return [] if changing_model.position == to 
                     

        self.fill_nil_positions(models)
        # binding.pry
        sorted = models.sort_by(&:position)
        # binding.pry

        target_model = sorted[to]
        
        is_sorting_to_ahead = to > changing_model.position
        start = is_sorting_to_ahead ? changing_model.position + 1 : to
        final = is_sorting_to_ahead ? to : changing_model.position - 1
        factor = is_sorting_to_ahead ? -1 : 1

        to_update = sorted[start..final]
        to_update.each { |model| model.position += factor }
        changing_model.position = to

        return [changing_model, *to_update]
    end

    def self.fill_nil_positions(items) 
        items_with_nil_positions = items.select { |item| item.position.nil? }
        index = items.length - items_with_nil_positions.length
        items_with_nil_positions.each do |item|
            item.position = index
            index += 1
        end
    end
end