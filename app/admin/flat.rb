ActiveAdmin.register Flat do
  filter :title
  index do
    column "Id" do |flat|
      link_to flat.title, admin_flat_path(flat)
    end

    column :address
    column :price
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :title
      f.input :address
      f.input :price
      f.input :full_price, as: :boolean
      f.input :desc, as: :text
    end
    f.actions
  end
  controller do
    def create
      super do |format|
        redirect_to collection_url and return if resource.valid?
      end
    end

    def update
      super do |format|
        redirect_to collection_url and return if resource.valid?
      end
    end
  end
  permit_params :address, :created_at, :desc, :price, :full_price
end