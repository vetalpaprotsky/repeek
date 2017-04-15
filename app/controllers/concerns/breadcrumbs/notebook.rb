module Breadcrumbs
  module Notebook
    extend ActiveSupport::Concern

    included do
      include Routes
      include CrumbsBeforeRender

      def add_breadcrumbs(action)
        case action
        when :index
          add_breadcrumb 'Home', r.root_path
        when :new, :create
          add_breadcrumb 'Home', r.root_path
          add_breadcrumb 'Notebooks', r.notebooks_path
        end
      end
    end
  end
end
