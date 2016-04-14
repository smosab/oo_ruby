class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count) # error here; The problem is that since quantity is an instance variable, it must be accessed with the @quantity notation when setting it.
    # prevent negative quantities from being set
    quantity = updated_count if updated_count >= 0
  end
end