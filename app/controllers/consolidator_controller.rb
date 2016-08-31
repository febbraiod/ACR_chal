class ConsolidatorController < ApplicationController
  require 'csv'

  def file_upload
  end

  def parser
    @output = Parser.parse(params[:file])
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"consolidated_trades\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

end
