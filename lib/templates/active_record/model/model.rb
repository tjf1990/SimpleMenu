class <%= class_name %> < <%= parent_class_name.classify %><% attributes.select {|attr| attr.reference? }.each do |attribute| -%>
  belongs_to :<%= attribute.name %><% end -%><% unless accessible_attributes.empty? -%>
  attr_accessible <%= accessible_attributes.map {|a| ":#{a.name}" }.join(', ') %>
  alias_attribute :to_s, :name
  has_paper_trail
  <% if (attributes.inject(false) {|memo, attr| memo || (attr.type == :decimal)})-%>
  validates_numericality_of <%= (attributes.inject([]) {|memo, attr| attr.type == :decimal ? (memo << ":#{attr.name}") : memo}).join(', ')%><% end -%>
  <% end -%>validates_presence_of :name
end

