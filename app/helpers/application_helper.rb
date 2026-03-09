module ApplicationHelper
  def person_detail_card(label, value = nil, value_classes: "", &block)
    rendered_value = block_given? ? capture(&block) : value
    return if rendered_value.blank?

    content_tag(:div, class: "rounded-xl bg-slate-50 px-4 py-3") do
      concat content_tag(:p, label, class: "text-xs font-semibold uppercase tracking-wide text-slate-500")
      concat content_tag(:p, rendered_value, class: "mt-1 text-sm font-medium text-slate-900 #{value_classes}")
    end
  end
end
