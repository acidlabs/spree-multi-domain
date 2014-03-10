Deface::Override.new(
  virtual_path: 'spree/admin/taxonomies/_list',
  name: 'add_stores_to_colgroup',
  replace: "table[data-hook] colgroup",
  text: "
          <colgroup>
            <col style='width: 10%'>
            <col style='width: 40%'>
            <col style='width: 35%'>
            <col style='width: 15%'>
          </colgroup>
        "
)

Deface::Override.new(
  virtual_path: 'spree/admin/taxonomies/_list',
  name: 'add_stores_header_to_table',
  insert_before: "[data-hook='taxonomies_header'] .actions",
  text: "<th><%= Spree.t(:stores) %></th>"
)

Deface::Override.new(
  virtual_path: 'spree/admin/taxonomies/_list',
  name: 'add_store_column_to_table',
  insert_before: "[data-hook='taxonomies_row'] .actions",
  text: "<td class='align-center'><%= taxonomy.stores.pluck(:name).join(', ') %></td>"
)