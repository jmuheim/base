module ApplicationHelper
  def create_link_to(object, content = 'New')
    if can? :create, object
      object_class = (object.kind_of?(Class) ? object : object.class)
      link_to content, [:new, object_class.name.underscore.to_sym]
    end
  end

  def show_link_to(object, content = 'Show')
    if can? :read, object
      link_to content, object
    end
  end

  def edit_link_to(object, content = 'Edit')
    if can? :update, object
      link_to content, [:edit, object]
    end
  end

  def destroy_link_to(object, content = 'Destroy')
    if can? :destroy, object
      link_to content, object, method: :delete, confirm: 'Are you sure?'
    end
  end
end
