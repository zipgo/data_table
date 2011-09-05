module DataTable
  module Mongoid
    module ClassMethods
      def _find_objects params, fields, search_fields
        self.where(_where_conditions params[:sSearch], search_fields).
             order_by(_order_by_fields params, fields).
             page(_page params).
             per(_per_page params)
      end

      def _matching_count params, search_fields
        self.where(_where_conditions params[:sSearch], search_fields).count
      end

      def _where_conditions raw_query, search_fields
        return if (query = raw_query.gsub(/\//, "")).blank?

        if search_fields.size == 1
          terms = query.strip.split(/\s+/)

          if terms.size == 1
            {search_fields.first => /#{terms.first}/i}
          else
            {search_fields.first => {"$all" => terms.map {|term| /#{term}/i }}}
          end
        else
          {"$or" => search_fields.map {|field| {field => /#{query}/i} }}
        end
      end

      def _order_by_fields params, fields
        [fields[params[:iSortCol_0].to_i], params[:sSortDir_0]]
      end
    end
  end
end

