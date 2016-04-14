require 'pry'

class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end
  # binding.pry
  def update_quantity(updated_count)
    binding.pry
    @quantity = updated_count if updated_count >= 0
  end

end

invoiceentry = InvoiceEntry.new("coffee", 1)

invoiceentry.update_quantity(5)

# invoiceentry.quantity = 5

p invoiceentry.quantity