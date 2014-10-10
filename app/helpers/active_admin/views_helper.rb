module ActiveAdmin::ViewsHelper

	 def link_to_add_fields_inputs(name, f, association, *args)
    options = Hash[*args]
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder )
    end
    link_to(name, '#', class: "#{name.split(" ").join("_").downcase.gsub("+", "add")}_fields #{options[:class]}", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def link_to_view_thickness_detail(name, material, thickness)
    detail_view = render("material_details", material: material, thickness: thickness)
    link_to(name, "#", class: "view_thickness_details", data: { detail: detail_view.gsub("\n", "") })
  end
end