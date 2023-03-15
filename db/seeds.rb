def populate_merchants
  p 'Populating merchants'

  File.open('./db/seeds/merchants.csv').each_line do |line|
    attrs = line.strip.split(',')
    Merchant.create(id: attrs[0], name: attrs[1], email: attrs[2], cif: attrs[3])
  end

  p 'Merchants populated successfully'
end

def populate_shoppers
  p 'Populating shoppers'

  File.foreach('./db/seeds/shoppers.csv') do |line|
    attrs = line.strip.split(',')
    Shopper.create(id: attrs[0], name: attrs[1], email: attrs[2], nif: attrs[3])
  end

  p 'Shoppers populated successfully'
end

def populate_orders
  p 'Populating orders'

  File.foreach('./db/seeds/orders.csv') do |line|
    attrs = line.strip.split(',')

    Order.create(
      id: attrs[0],
      merchant_id: attrs[1],
      shopper_id: attrs[2],
      amount: attrs[3],
      created_at: attrs[4],
      completed_at: attrs[5]
    )
  end

  p 'Orders populated successfully'
end

populate_merchants
populate_shoppers
populate_orders
