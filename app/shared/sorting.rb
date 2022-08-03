class Sorting
    def self.sort(models:, changing:, to:)
        return [] if to > models.length || to < 0 || changing.position == to

        target_model = models[to]
        changing_model = models.find { |model| model.id == changing.id }
        
        is_sorting_to_ahead = to > changing_model.position
        start = is_sorting_to_ahead ? changing_model.position + 1 : to
        final = is_sorting_to_ahead ? to : changing_model.position - 1
        factor = is_sorting_to_ahead ? -1 : 1

        to_update = models[start..final]
        to_update.each { |model| model.position += factor }
        changing_model.position = to

        return [changing_model, *to_update]
    end
end