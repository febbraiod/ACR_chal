class ConsolidatorController < ApplicationController
  require 'csv'

  def file_upload
  end

  def parser
    @output = Parser.parse(params[:file])
  end

end
