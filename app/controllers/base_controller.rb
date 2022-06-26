class BaseController < ApplicationController
  
  PER_PAGE = 5
  
  def make_meta(total_records:, page:)
    @total_pages = (total_records / PER_PAGE).ceil + 1
    return {
      first_page: [0, 1].include?(page),
      last_page: page >= @total_pages,
      total_pages: @total_pages,
      page: page,
      per_page: PER_PAGE
    }
  end
end